<p align="center">
  <img src="assets/cleanplated-logo.svg" alt="Cleanplated Logo" width="200">
</p>

# Cleanplated

Cleanplated centralizes Southern California restaurant health inspection data and exposes normalized Trust Scores through a mobile-first directory.

## Structure

- `backend/`: Rust backend (clean architecture + ingestion scheduler)
- `frontend/`: Vue 3 mobile-first client with IBM Carbon Design System
- `infra/terraform/`: GCP bootstrap + deployment infrastructure
- `cloudbuild/`: CI/CD configs for backend and frontend on `main`
- `docs/research/socal-food-safety-data-strategy.md`: research blueprint and source references

## Quick start

### 1. Environment Setup

```bash
# Copy the environment template
cp .env.example .env

# Edit .env and add your Google Maps API key (required for map functionality)
# VITE_GOOGLE_MAPS_API_KEY=your_api_key_here
```

**Google Maps API Key Setup:**
1. Go to [Google Cloud Console](https://console.cloud.google.com/apis/credentials)
2. Create a new API key or use an existing one
3. Enable the "Maps JavaScript API" for your project
4. Configure API restrictions:
   - **Application restrictions**: HTTP referrers (websites)
   - **Website restrictions**: Add these URLs:
     - `localhost:15173` (local development)
     - `*.cleanplated.com/*` (production, if applicable)
5. Add the API key to your `.env` file

### 2. Start the Application

```bash
# Full stack with Docker Compose
docker compose up --build

# Seed the database with restaurant data (optional, for local development)
./scripts/seed-database.sh
```

Services:

- Frontend: `http://localhost:15173`
- Backend API: `http://localhost:18080`
- Backend repository: PostgreSQL when `DATABASE_URL` is set (falls back to in-memory only if missing)
- Postgres: internal compose service (`postgres:5432`) for local persistence
- Redis: internal compose service (`redis:6379`, provisioned for planned caching migration)

### Database Seeding

The local development environment starts with an empty database. To populate it with restaurant data for testing:

```bash
# After starting the main services
./scripts/seed-database.sh
```

This will fetch a subset of data from public health APIs to populate your local database. The process typically takes 2-5 minutes.

**Manual seeding** (alternative):
```bash
docker compose --profile seed run --rm seed
```

## Cloud Build (main triggers)

After completing GitHub OAuth for the Cloud Build connection, run:

```bash
./scripts/create_cloudbuild_triggers.sh
```
