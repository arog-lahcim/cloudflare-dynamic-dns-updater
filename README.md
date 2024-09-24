# Cloudflare Dynamic DNS Updater

Simple service updating DNS records in Cloudflare whenever public IP changes for given domain.

## Configuration

It is intended to be used from a container therefore configuration is possible only using environmental variables.

Following ones need to be set in order for this to work.

- `API_KEY` - token with `Zone.DNS` permission granted - https://dash.cloudflare.com/profile/api-tokens
- `ZONE_ID` - can be taken from Cloudflare dashboard for a website
- `DOMAIN_NAME` - `your.domain.com`
- `TIMEOUT_SEC` - time in seconds to wait between individual IP checks

Optionally `DNS_RECORD_ID` can be provided to avoid issues when resolving it automatically.

## Docker Compose

Simple compose config using public image.

```
services:
  cloudflare-dynamic-dns-updater:
    image: aroglahcim/cloudflare-dynamic-dns-updater
    container_name: cloudflare-dynamic-dns-updater
    environment:
      - ZONE_ID=${CLOUDFLARE_DNS_UPDATE_CLIENT_ZONE_ID}
      - API_KEY=${CLOUDFLARE_DNS_UPDATE_CLIENT_API_KEY}
      - DOMAIN_NAME=${CLOUDFLARE_DNS_UPDATE_CLIENT_DOMAIN_NAME}
      - TIMEOUT_SEC=600
    restart: unless-stopped
```
