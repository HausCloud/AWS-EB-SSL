#!/usr/bin/env bash
# Postdeploy hook to setup SSL simple version
set -euf -o pipefail

# Auto allow yes for all yum install
# Suggestion: Remove after deployment
if ! grep -q 'assumeyes=1' /etc/yum.conf; then
    echo 'assumeyes=1' | tee -a /etc/yum.conf
fi

# Install EPEL
# Source: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/amazon-linux-ami-basics.html
if ! yum list installed epel-release; then
    if grep -q "PRETTY_NAME=\"Amazon Linux 2\"" /etc/os-release || grep -q 'cpe:.*:amazon_linux:2' /etc/os-release; then
        yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
    else
        yum-config-manager --enable epel
    fi
fi

if ! [ -x "$(command -v certbot)" ] && yum list installed epel-release; then
    if which nginx; then
        yum install certbot python2-certbot-nginx
    elif which apache || which apache2; then
        yum install certbot python2-certbot-apache
    fi
fi

# Install SSL
if [ -z "${CERTBOT_CERT_NAME+x}" ] && [ -z "${CERTBOT_EMAIL+x}" ] && [ -z "${CERTBOT_DOMAIN_LIST+x}" ] && [ -x "$(command -v certbot)" ]; then
    if which nginx; then
        certbot --nginx --redirect --cert-name "$CERTBOT_CERT_NAME" -m "$CERTBOT_EMAIL" --domains "$CERTBOT_DOMAIN_LIST" --agree-tos --no-eff-email --keep-until-expiring --non-interactive
    elif which apache || which apache2; then
        certbot --apache --redirect --cert-name "$CERTBOT_CERT_NAME" -m "$CERTBOT_EMAIL" --domains "$CERTBOT_DOMAIN_LIST" --agree-tos --no-eff-email --keep-until-expiring --non-interactive
    fi
fi
