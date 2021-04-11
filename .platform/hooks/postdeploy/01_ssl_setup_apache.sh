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
# Above may not apply for apache
CERTBOT_NAME='<certificate_name>'
CERTBOT_EMAIL='<certificate_email>'
# Multiple domain example: CERTBOT_DOMAINS='bort.com,www.bort.com,bort-env.eba-2kg3gsq2.us-east-2.elasticbeanstalk.com'
CERTBOT_DOMAINS='<eb_url>'

LOG_PATH=$(find /var/log/ -type f -iname 'eb-hooks.log')
log_level() {
    if [ -n "$LOG_PATH" ]; then
        DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
        echo "$DATE | $1: $2" | tee -a "$LOG_PATH"
    fi
}

log_debug() { log_level 'DEBUG' "$1"; }
log_info() { log_level 'INFO' "$1"; }
log_error() { log_level 'ERROR' "$1"; }

# Variable check
log_debug "Check certbot variables"
if [ -z "$CERTBOT_NAME" ] || [ -z "$CERTBOT_EMAIL" ] || [ -z "$CERTBOT_DOMAINS" ]; then
    log_error 'Certbot and/or proxy server information is missing.'
    exit 1
fi

# Install EPEL
# Source: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/amazon-linux-ami-basics.html
log_debug "yum: Install EPEL"
if ! yum list installed epel-release; then
    yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
fi

# Install certbot
log_debug "yum: Install certbot"
if yum list installed epel-release && ! command -v certbot &>/dev/null; then
    yum install -y certbot python2-certbot-apache
fi

# Set up certificates
if command -v certbot &>/dev/null; then
    log_debug "nginx: Check configuration"
    if apachectl configtest; then
        log_debug "certbot: Install apache configuration"
        certbot --apache \
          --cert-name "$CERTBOT_NAME" \
          --email "$CERTBOT_EMAIL" \
          --domains "$CERTBOT_DOMAINS" \
          --redirect \
          --agree-tos \
          --no-eff-email \
          --keep-until-expiring \
          --non-interactive
    else
        log_error 'Apache configuration is invalid.'
        exit 1
    fi
else
    log_error 'Certbot installation may have failed.'
    exit 1
fi

# cron: Attempt to renew certificates twice a day (to account for revocations, etc.)
cat >> /etc/cron.d/certbot_renew << END_CRON
MAILTO="$CERTBOT_EMAIL"
42 2,14 * * * root certbot renew --quiet --no-self-upgrade --deploy-hook "service httpd reload && service httpd restart"
END_CRON
chmod +x /etc/cron.d/certbot_renew

log_info 'Script ran successfully.'
