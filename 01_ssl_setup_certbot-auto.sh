#!/usr/bin/env bash

original_string=$(echo "elif [ -f /etc/redhat-release ]" | sed -e 's/[]\/$*.^[]/\\&/g')
new_string=$(echo "elif [ -f /etc/redhat-release ] || grep -q "PRETTY_NAME=\"Amazon Linux 2\"" /etc/os-release || grep -q 'cpe:.*:amazon_linux:2' /etc/os-release" | sed -e 's/[]\/$*.^[]/\\&/g')
http_string='^http\s*{$'
bucket_increase='http {\nserver_names_hash_bucket_size  128;\n'

# Auto allow yes for all yum install
# Suggestion: Remove after deployment
echo 'assumeyes=1' | sudo tee -a /etc/yum.conf

# Increase size of string name for --domains
sed -i "s/$http_string/$bucket_increase/g" /etc/nginx/nginx.conf

# Install certbot-auto
wget https://dl.eff.org/certbot-auto
mv certbot-auto /usr/local/bin/certbot-auto
chown root /usr/local/bin/certbot-auto
chmod 0755 /usr/local/bin/certbot-auto

# Detect OS for bootstrapping for Amazon Linux 2
# Source: https://medium.com/@andrenakkurt/great-guide-thanks-for-putting-this-together-gifford-nowland-c3ce0ea2455
sed -i "s/${original_string}/${new_string}/g" /usr/local/bin/certbot-auto

# Install SSL for nginx
# For apache, replace --nginx with --apache
if ! /usr/local/bin/certbot-auto --nginx --redirect --cert-name "$CERTBOT_CERT_NAME" -m "$CERTBOT_EMAIL" --domains "$CERTBOT_DOMAIN_LIST" --agree-tos --no-eff-email; then
    # Workaround to use Python3 for --no-site--packages issue for Python2
    # Source: https://community.letsencrypt.org/t/how-do-i-specify-the-python-version-when-running-certbot-auto-command/89059
    USE_PYTHON_3=1 /usr/local/bin/certbot-auto --nginx --redirect --cert-name "$CERTBOT_CERT_NAME" -m "$CERTBOT_EMAIL" --domains "$CERTBOT_DOMAIN_LIST" --agree-tos --no-eff-email
fi

# Autorenewal
echo "0 0,12 * * * root python -c 'import random; import time; time.sleep(random.random() * 3600)' && /usr/local/bin/certbot-auto renew -q" | sudo tee -a /etc/crontab >/dev/null
