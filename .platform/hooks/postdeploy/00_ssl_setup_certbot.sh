#!/bin/bash
# IMPORTANT: use this bash otherwise following error: "failed with error exit status 127. Stderr:/usr/bin/env: bash: No such file or directory"
# IMPORTANT: use LF instead of CRLF for .sh files, otherwise following error: "00_ssl_setup_certbot.sh: no such file or directory"
# IMPORTANT: for LF: also set "* text eol=lf" in ".gitattributes" file otherwise git will convert it into CRLF again on Windows :(

set -euo pipefail

# Postdeploy script for enabling SSL (single instance)
# Compatible only with Amazon Linux 2 EC2 instances

LOG_PATH=$(find /var/log/ -type f -iname 'eb-hooks.log')
DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# IMPORTANT: no whitespaces in CERTBOT_NAME, otherwise following error: "invalid number of arguments in "ssl_certificate" directive in /etc/nginx/nginx.conf:81"
CERTBOT_NAME='<certificate_name>'
CERTBOT_EMAIL='<certificate_email>'
# Multiple domain example: CERTBOT_DOMAINS='bort.com,www.bort.com,bort-env.eba-2kg3gsq2.us-east-2.elasticbeanstalk.com'
CERTBOT_DOMAINS='<eb_url>'

crontab_exists() {
    crontab -u root -l 2>/dev/null | grep 'certbot -q renew' >/dev/null 2>/dev/null
}

log_and_exit() {
    if [ -n "$LOG_PATH" ] && [ -n "$DATE" ]; then
        echo "$DATE | $1" | tee -a "$LOG_PATH"
    fi
    exit 0
}

# Variable check

if [ ! -n "$CERTBOT_NAME" ] || [ ! -n "$CERTBOT_EMAIL" ] || [ ! -n "$CERTBOT_DOMAINS" ]; then
    log_and_exit 'INFO: Certbot and/or proxy server information is missing.'
fi

# Auto allow yes for all yum install
# SUGGESTION: Remove after deployment

if ! grep -q 'assumeyes=1' /etc/yum.conf; then
    echo 'assumeyes=1' | tee -a /etc/yum.conf
fi

# Install EPEL
# Source: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/amazon-linux-ami-basics.html

if ! yum list installed epel-release; then
    yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
fi

# Install certbot

if yum list installed epel-release && ! command -v certbot &>/dev/null; then
    yum install certbot python2-certbot-nginx
fi


HTTP_STRING='^http\s*{$'
NAME_LIMIT='http {\nserver_names_hash_bucket_size 192;\n'

# Prevent replace if not clean sample app

if ! grep -Fxq "$NAME_LIMIT" /etc/nginx/nginx.conf; then
    # Increase size of string name for --domains (for default EB configs)
    
    if ! sed -i "s/$HTTP_STRING/$NAME_LIMIT/g" /etc/nginx/nginx.conf; then
        log_and_exit 'ERROR: Changing server name limit failed'
    fi
fi

# Set up certificates

if command -v certbot &>/dev/null; then
    if nginx -t; then
        certbot --nginx --cert-name "$CERTBOT_NAME" -m "$CERTBOT_EMAIL" --domains "$CERTBOT_DOMAINS" --redirect --agree-tos --no-eff-email --keep-until-expiring --non-interactive
    else
        log_and_exit 'ERROR: Nginx configuration is invalid.'
    fi
else
    log_and_exit 'ERROR: Certbot installation may have failed.'
fi

# Create cron task (attempt) to renew certificate every 29 days

if ! crontab_exists; then
    systemctl start crond
    systemctl enable crond
    
    LINE="0 0 */29 * * certbot -q renew; service nginx reload; service nginx restart"
    
    (
        crontab -u root -l
        echo "$LINE"
    ) | crontab -u root -
fi

log_and_exit 'SUCCESS: Script ran successfully.'
