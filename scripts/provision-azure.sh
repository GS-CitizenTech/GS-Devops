#!/usr/bin/env bash
set -Eeuo pipefail

# Reuses the existing FIAP sprint resources when they exist. It creates only
# missing resources and uses the Free F1 plan by default.
RESOURCE_GROUP="${RESOURCE_GROUP:-rg-sprint4}"
LOCATION="${LOCATION:-brazilsouth}"
PLAN_NAME="${PLAN_NAME:-ASP-rgsprint4-92b1}"
PLAN_SKU="${PLAN_SKU:-F1}"
WEB_APP_NAME="${WEB_APP_NAME:-app-alertacidadao-rm563088}"
DOTNET_RUNTIME="${DOTNET_RUNTIME:-DOTNETCORE:10.0}"

command -v az >/dev/null 2>&1 || {
  echo "Azure CLI (az) não foi encontrado. Instale-o e tente novamente." >&2
  exit 1
}

az account show --output none

if [[ "$(az group exists --name "$RESOURCE_GROUP" --output tsv)" != "true" ]]; then
  az group create --name "$RESOURCE_GROUP" --location "$LOCATION" --output table
else
  echo "Resource group existente: $RESOURCE_GROUP"
fi

if az appservice plan show --resource-group "$RESOURCE_GROUP" --name "$PLAN_NAME" --output none 2>/dev/null; then
  echo "App Service Plan existente: $PLAN_NAME"
else
  az appservice plan create \
    --resource-group "$RESOURCE_GROUP" \
    --name "$PLAN_NAME" \
    --location "$LOCATION" \
    --sku "$PLAN_SKU" \
    --is-linux \
    --output table
fi

PLAN_IS_LINUX="$(az appservice plan show --resource-group "$RESOURCE_GROUP" --name "$PLAN_NAME" --query reserved --output tsv)"
if [[ "$PLAN_IS_LINUX" != "true" ]]; then
  echo "O plano $PLAN_NAME não é Linux; revise-o antes de criar o Web App." >&2
  exit 1
fi

if az webapp show --resource-group "$RESOURCE_GROUP" --name "$WEB_APP_NAME" --output none 2>/dev/null; then
  echo "Web App existente: $WEB_APP_NAME"
else
  az webapp create \
    --resource-group "$RESOURCE_GROUP" \
    --plan "$PLAN_NAME" \
    --name "$WEB_APP_NAME" \
    --runtime "$DOTNET_RUNTIME" \
    --output table
fi

az webapp show \
  --resource-group "$RESOURCE_GROUP" \
  --name "$WEB_APP_NAME" \
  --query '{name:name,host:defaultHostName,state:state,location:location}' \
  --output table
