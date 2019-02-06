set -x
az group create --name ScaledRiskARM --location "West Europe"
az group deployment create \
  --verbose \
  --name ScaledRiskDeployment \
  --resource-group ScaledRiskARM \
  --template-uri "https://raw.githubusercontent.com/pmillart/hdinsight/master/azuredeploy.json" \
  --parameters @azuredeploy.parameters.json
