# Ready-to-use Nginx-Certbot-Docker Compose Setup

### What is this?
This project is all about simplifying the process of securing your web traffic with SSL encryption.
It's designed to seamlessly integrate Nginx as a reverse proxy with Certbot for automated SSL certificate management, all wrapped up with Docker Compose.


### Requirements
- [Docker Compose](https://docs.docker.com/compose/install/) (comes built in with latest docker version)
- [Git](https://git-scm.com/downloads) (optional)

### Setup
1. Clone/Download this repository and move the `ssl_setup` folder in your root project folder (next to your Dockerfile).
2. Make the generator executable with `chmod +x ssl_setup/generate.sh`.
3. Run `./ssl_setup/generate.sh` and fill the options.
4. Do not set a too low refresh rate to avoid rate-limits.
5. The script generated a `docker-compose.yml` and `nginx.conf` file.
6. Adjust the files further if you want (Warning: do not run `/generate` again, it will override).

### DNS Settings
- Set A Record (and AAA Record) to point to your servers IPv4 (and IPv6) address in your domains DNS settings.
- If you use a proxy like Cloudflare make sure that requests like `http://{{YOUR_DOMAIN}}/.well-known/acme-challenge/*` are getting forwarded (do not force HTTPS).

### Start / Stop
1. run `docker compose up --build -d` to start or update the server (`docker-compose` for older versions)
2. run `docker compose down` to stop the server
