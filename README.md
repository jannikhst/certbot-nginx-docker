# Ready-to-use Docker Compose Setup

### Requirements
- Docker Compose (comes built in with latest docker version)
- Git

### Setup
1. Clone this repository and move the `ssl_setup` folder in your root project folder (next to your Dockerfile).
2. Make the generator executable with `chmod +x ssl_setup/generate.sh`.
3. Run `./ssl_setup/generate.sh` and fill the options.
4. Do not set a too low refresh rate to avoid rate-limits.
5. The script generated a `docker-compose.yml` and `nginx.conf` file.
6. Adjust the files further if you want (Warning: do not run `/generate` again, since it will override).

### DNS Settings
- Set A Record (and AAA Record) to point to your servers IPv4 (and IPv6) address in your domains DNS settings.
- If you use a proxy like Cloudflare make sure that requests like http://{{YOUR_DOMAIN}}/.well-known/acme-challenge/* are getting forwarded (do not force HTTPS).

### Start / Stop
1. run `docker compose up --build -d` to start or update the server (`docker-compose` for older versions)
2. run `docker compose down` to stop the server
