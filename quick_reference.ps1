# Azure Portal CLI Only
Get-CloudDrive
# Get Azure VMs
Get-AzureRmVM
# Start VM
Start-AzureRmVM -name VMName -ResourceGroupName rg -AsJob
# Stop VM
Stop-AzureRmVM -Name VMName -ResourceGroupName rg -AsJob
# Save VM to variable to do multiple operations
$vm = Get-AzureRmVM -Name VMname -ResourceGroupName rg
$vm | Stop-AzureRmVM -Force -AsJob
$vm | Start-AzureRmVM -Force -AsJob
# Linux which equivelent
$(get-command powershell.exe).path