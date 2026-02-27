# Tuotantoonvienti

## HTTPS-sertifikaatti (Let's Encrypt)

Lisää `docker-compose.yml`:ään:

```yaml
  certbot:
    image: certbot/certbot
    volumes:
      - ./certbot/conf:/etc/letsencrypt
      - ./certbot/www:/var/www/certbot
    entrypoint: >
      sh -c "certbot certonly --webroot -w /var/www/certbot
             -d your-domain.com --email you@email.com --agree-tos -n"
```

Päivitä `nginx.conf`:iin:
```nginx
listen 443 ssl;
ssl_certificate /etc/letsencrypt/live/your-domain.com/fullchain.pem;
ssl_certificate_key /etc/letsencrypt/live/your-domain.com/privkey.pem;
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
```

## Skaalaus

Gunicorn-workerien määrä (session-manager):
```
workers = (2 × CPU-ytimet) + 1
```

## Varmuuskopiot

```bash
# PostgreSQL-varmuuskopio
docker-compose exec postgres pg_dump -U mcpuser mcpuniverse > backup_$(date +%Y%m%d).sql

# Palautus
docker-compose exec -T postgres psql -U mcpuser mcpuniverse < backup_20250101.sql
```

## Monitorointi

Suositellaan lisättäväksi:
- **Prometheus + Grafana** metriikalle
- **Loki** lokien keräämiseen
- **Uptime Kuma** health check -valvontaan
