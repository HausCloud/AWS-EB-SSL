#!/usr/bin/env bash
# Bash script to attach to postdeploy hook for SSL
# Compatible only with Amazon Linux 2 EC2 instances

# Auto allow yes for all yum install
# Suggestion: Remove after deployment
if ! grep -q 'assumeyes=1' /etc/yum.conf; then
    echo 'assumeyes=1' | tee -a /etc/yum.conf
fi

# Increase size of string name for --domains
if which nginx; then
    http_string='^http\s*{$'
    bucket_increase='http {\nserver_names_hash_bucket_size 300;\n'
    sed -i "s/$http_string/$bucket_increase/g" /etc/nginx/nginx.conf
fi

# Install EPEL
# Source: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/amazon-linux-ami-basics.html
if ! yum list installed epel-release; then
    yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
fi

if ! [ -x "$(command -v certbot)" ] && yum list installed epel-release; then
    yum install certbot python2-certbot-nginx
fi

if [ ! -z "${CERTBOT_CERT_NAME+x}" ] && [[ -n "$CERTBOT_CERT_NAME" ]] && [ ! -z "${CERTBOT_EMAIL+x}" ] && [[ -n "$CERTBOT_EMAIL" ]] && [ ! -z "${CERTBOT_DOMAIN_LIST+x}" ] && [[ -n "$CERTBOT_DOMAIN_LIST" ]] && [ -x "$(command -v certbot)" ]; then
    certbot --nginx --redirect --debug --cert-name "$CERTBOT_CERT_NAME" -m "$CERTBOT_EMAIL" --domains "$CERTBOT_DOMAIN_LIST" --agree-tos --no-eff-email --keep-until-expiring --non-interactive
fi

crontab_exists() {
    crontab -l 2>/dev/null | grep 'certbot -q renew' >/dev/null 2>/dev/null
}
if ! crontab_exists ; then
    systemctl start crond
    systemctl enable crond
    line="0 */12 * * * certbot -q renew; systemctl reload nginx.service"
    (crontab -u root -l; echo "$line" ) | crontab -u root -
fi
