# """
#
# このスクリプトはPowerShellで実行することを想定しています。
#
# """

$directory = "$(Get-Location)\live"

echo $directory

Get-ChildItem -Path $directory -Recurse -Filter "provider.tf" | Remove-Item -Force
Get-ChildItem -Path $directory -Recurse -Filter "backend.tf" | Remove-Item -Force
# Get-ChildItem -Path $directory -Recurse -Filter ".terraform.lock.hcl" | Remove-Item -Force
Get-ChildItem -Path $directory -Recurse -Directory -Filter ".terraform" | Remove-Item -Recurse -Force
