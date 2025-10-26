---
name: sp-cli
description: SimplePractice Docker development CLI tool for managing local microservice environments. Use when working with the `sp` command, docker-compose services, app synchronization, or troubleshooting local development setup.
---

# SimplePractice CLI (sp)

Ruby-based CLI tool wrapping Docker Compose for managing SimplePractice's microservice development environment.

## Core Architecture

- **Tool name**: `sp` (bin/sp)

## Command Patterns

All commands follow: `sp <command> [args] [--help]`

### Essential Commands

**Environment lifecycle**:
- `sp start [app]` - Start all services (or specific app)
- `sp stop` - Stop all services and prune images
- `sp restart [app]` - Restart services
- `sp help` - Show commands, environment vars, and service status

**Service interaction**:
- `sp attach <app>` - Attach to running container's shell
- `sp exec <app> <command>` - Execute command in container
- `sp port <app>` - Show port mappings

**App management**:
- `sp apps:sync` - Clone missing repos from apps/*.yml
- `sp apps:sync-versions` - Sync package.json versions across apps

## Environment Configuration

**Environment sources** (in load order):
1. System environment
2. `.env` file (root directory)
3. Inline environment blocks in YAML
4. Volume-mounted env files (e.g., `.env.lake.local`)

**Common variables**:
- `AWS_PROFILE` - AWS credentials profile
- `AWS_SSO_SESSION` - AWS SSO session (typically "staging")
- `CONFIG__DEVELOPMENT_USER` - Override for development user
- `APPS` - Comma-separated list to limit running services

**Lake (production data) access**:
- Requires `.env.lake.local` and `.my.cnf` in tmp/
- Setup via `sp setup-lake` command
- Mounted read-only into containers needing prod access

## Service Dependencies

**Common infrastructure services**:
- `mysql` - Database with health checks
- `redis` - Cache/session store
- `cognito` - LocalStack mock for AWS Cognito
- `snowflake` - LocalStack mock for Snowflake

## Troubleshooting Workflows

### Service won't start

1. Check status: `sp help` (shows running services)
2. View logs: `docker compose logs <service>`
3. Check health: `docker compose ps` (shows health status)
4. Rebuild: `docker compose build <service> --no-cache`

### Port conflicts

1. Find port mapping: `sp port <app>`
2. Check what's using port: `lsof -i :<port>`
3. Kill process or change port in app YAML

### Volume issues

1. Prune volumes: `docker volume prune`
2. Recreate: `docker compose down -v && sp start`
3. For node_modules issues, delete named volume directly

### App sync failures

**Missing repos**:
- `sp apps:sync` clones from apps/*.yml build contexts
- Expects repos in sibling directories to dockerdev

**Version conflicts**:
- `sp apps:sync-versions` updates package.json dependencies
- Syncs ember-simplepractice and ember-messaging-client versions
- Skips unsupported apps (messaging-client, track-your-hours-rails)

## Advanced Patterns

### Selective service startup

Use `APPS` env var to limit services:
```bash
APPS=simplepractice,simplepractice-frontend sp start
```

### Custom compose files

Commands respect `COMPOSE_FILE` env var:
```bash
COMPOSE_FILE=docker-compose.yml:docker-compose.local.yml sp start
```

### Container debugging

**Interactive shell**:
```bash
sp attach <app>  # Gets bash/sh shell
```

**One-off commands**:
```bash
sp exec <app> rails console
sp exec <app> bundle install
```

### Database access

**From host**:
```bash
mysql -h 127.0.0.1 -P 3306 -u root
```

**From container**:
```bash
sp exec simplepractice mysql
```

## Common Issues

**Bundle/npm install fails**:
- Volume mounts may be stale
- Solution: Rebuild container, volumes recreate automatically

**Can't connect to service**:
- Check OrbStack domains in /etc/hosts
- Verify container is healthy: `docker compose ps`
- Check labels match access pattern

**Performance degradation**:
- Named volumes for node_modules prevent sync overhead
- Prune unused containers: `docker system prune`

**AWS/Lake credentials expired**:
- Refresh: `aws sso login --profile <profile>`
- Update .env.lake.local with new credentials
