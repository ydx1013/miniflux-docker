version: "3"

services:

   miniflux:
     image: miniflux/miniflux:latest
     container_name: miniflux
     restart: unless-stopped
     ports:
       - "8888:8080"
     depends_on:
       - db
       - rsshub
     environment:
       - DATABASE_URL=postgres://miniflux:somepass888@db/miniflux?sslmode=disable
       - POLLING_FREQUENCY=15
       - RUN_MIGRATIONS=1

   db:
     image: postgres:latest
     container_name: postgres
     restart: unless-stopped
     environment:
       - POSTGRES_USER=miniflux
       - POSTGRES_PASSWORD=somepass888
     volumes:
       - miniflux-db:/var/lib/postgresql/data

   rsshub:
     image: diygod/rsshub:latest
     container_name: rsshub
     restart: unless-stopped
     ports:
       - "1200:1200"
     environment:
       NODE_ENV: production
       CACHE_TYPE: redis
       REDIS_URL: "redis://redis:6379/"
       PUPPETEER_WS_ENDPOINT: "ws://browserless:3000"
     depends_on:
       - redis
       - browserless

   browserless:
     image: browserless/chrome:latest
     container_name: browserless
     restart: unless-stopped

   redis:
     image: redis:alpine
     container_name: redis
     restart: unless-stopped
     volumes:
       - redis-data:/data

volumes:
  miniflux-db:
  redis-data:
