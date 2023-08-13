$workloadName = "mrapimGW"
$location = "westus2"
$environment = "dev"

$resourceSuffix = "$($workloadName)-$($environment)-$($location)-001"
$networkingResourceGroupName = "rg-networking-$($resourceSuffix)"
$sharedResourceGroupName = "rg-shared-$($resourceSuffix)"
$apimResourceGroupName = "rg-apim-$($resourceSuffix)"

az group delete --name $networkingResourceGroupName --yes
az group delete --name $sharedResourceGroupName --yes
az group delete --name $apimResourceGroupName --yes


az keyvault purge --name $resourceSuffix --location $location
