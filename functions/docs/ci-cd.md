# CI/CD (API / Firebase Functions)

This repo deploys the API as **Firebase Cloud Functions** from `functions/`.

## Environments

- **Dev** → Firebase project `coffix-app-dev`
- **Prod** → Firebase project `coffix-app-prod`

The GitHub Actions workflow is in `.github/workflows/deploy-functions.yml`.

## Triggers

- Push to `dev` → deploy to **dev**
- Push to `main` → deploy to **prod**
- Manual run → select `dev` or `prod`

## Required GitHub secrets

Create these **repository secrets** (or environment-scoped secrets if you use GitHub Environments):

### Dev

- `FIREBASE_SERVICE_ACCOUNT_DEV`: JSON service account key for `coffix-app-dev`
- `FUNCTIONS_ENV_DEV`: the full contents of `functions/.env` for dev (multi-line)

### Prod

- `FIREBASE_SERVICE_ACCOUNT_PROD`: JSON service account key for `coffix-app-prod`
- `FUNCTIONS_ENV_PROD`: the full contents of `functions/.env` for prod (multi-line)

## Service account permissions

The service account used for deploy typically needs permissions to deploy Cloud Functions and update related GCP resources.
If deploy fails with a permissions error, grant the service account additional roles in the target project.

