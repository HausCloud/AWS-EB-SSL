#!/usr/bin/env bash
# Install SSL

# Auto allow yes for all yum install
# Suggestion: Remove after deployment
echo 'assumeyes=1' | tee -a /etc/yum.conf

if ! [ -x "$(command -v certbot)" ]; then
    # Enable EPEL
    # Source: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/amazon-linux-ami-basics.html
    if grep -q "PRETTY_NAME=\"Amazon Linux 2\"" /etc/os-release || grep -q 'cpe:.*:amazon_linux:2' /etc/os-release; then
        yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
    else
        yum-config-manager --enable epel
    fi

    #yum install certbot python2-certbot-apache
    yum install certbot python2-certbot-nginx
fi

# Install SSL for nginx
certbot --nginx --redirect --cert-name "$CERTBOT_CERT_NAME" -m "$CERTBOT_EMAIL" --domains "$CERTBOT_DOMAIN_LIST" --agree-tos --no-eff-email
#certbot --apache --redirect --cert-name "$CERTBOT_CERT_NAME" -m "$CERTBOT_EMAIL" --domains "$CERTBOT_DOMAIN_LIST" --agree-tos --no-eff-email
