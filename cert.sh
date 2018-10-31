#!/bin/sh
set -e

# NEEDS THE FOLLOWING VARS IN ENV:
# DOMAIN
# CLOUDFLARE_EMAIL
# CLOUDFLARE_API_KEY
# HEROKU_API_KEY
# HEROKU_APP

# Download dependencies
curl https://get.acme.sh | sh
curl https://cli-assets.heroku.com/install.sh | sh

# Reload the environment
source /etc/profile

# Map to environment variables that the ACME script requires
export CF_Email=$CLOUDFLARE_EMAIL
export CF_Key=$CLOUDFLARE_API_KEY

# Generate wildcard certificate (this will take approx 130s)
acme.sh  --issue -d $DOMAIN  -d "*.$DOMAIN"  --dns dns_cf

# Update the certificate in the live app
heroku certs:add "~/.acme.sh/$DOMAIN/$DOMAIN.cer" "~/.acme.sh/$DOMAIN/$DOMAIN.key" --app $HEROKU_APP