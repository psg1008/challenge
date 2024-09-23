<#
.DESCRIPTION
    This script gets the information from the reference registry and copies all the Helm charts to another cluster

.PARAMETER ServicePrincipalApplicationId
    Specifies the ServicePrincipalApplicationId to authenticate in Azure.

.PARAMETER ServicePrincipalSecret
    Specifies the ServicePrincipalSecret to authenticate in Azure.
#>

  [CmdletBinding()]
param(
  [string] $ServicePrincipalApplicationId,
  [string] $ServicePrincipalSecret
)
##Get the authentification and connect to Azure service principal
function Get-Authentication
{
  param (
    [string] $servicePrincipalApplicationId,
    [string] $servicePrincipalSecret,
    [string] $tenantId
  )
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $securePassword = ConvertTo-SecureString -String $servicePrincipalSecret -AsPlainText -Force
    $credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $servicePrincipalApplicationId, $SecurePassword
    Connect-AzAccount -ServicePrincipal -TenantId $tenantId -Credential $credential
}

############################### Main #############################################
$tenantId = "0000000-000000-0000000-000000"
$subscriptionId = "c9e7611c-d508-4-f-aede-0bedfabc1560"
$ACRReferenceRegistry = "reference.azurecr.io"
$ACRInstanceRegistry = "instance.azurecr.io"

try{
 Write-Output "Connecting using Service Principal credentials..."
 Get-Authentication -ServicePrincipalApplicationId $servicePrincipalApplicationId -ServicePrincipalSecret $servicePrincipalSecret -TenantId $tenantId

 az acr login --name $ACRReferenceRegistry --subscription $subscriptionId
 $referenceRepositories = az acr list --name $ACRReferenceRegistry --repository "helm_chart_repository" --output table |
    Select-String -Pattern '^\w+' |
    ForEach-Object { ($_ -split '\s+')[0] }

 ForEach ($referenceRepository in $referenceRepositories) {
 az acr login --name $ACRReferenceRegistry --subscription $subscriptionId
 $tagsReferenceRepository = az acr repository show-tags --name $ACRReferenceRegistry --repository $referenceRepository
    ForEach ($tagRepositoryRef in  $tagsReferenceRepository) {
        rm *.tgz
        helm pull oci://$ACRReferenceRegistry/helm/$referenceRepository --version $tagRepositoryRef
        az acr login --name $ACRInstanceRegistry --subscription $subscriptionId
        helm push *.tgz oci://$ACRInstanceRegistry/helm/$referenceRepository
    }
 }
catch{
}
finally{
    Disconnect-AzAccount
}
