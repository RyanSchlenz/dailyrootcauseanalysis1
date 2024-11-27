# Define your variables
$resourceGroupName = "rg-servers-infra-westus3-001"
$functionAppName = "DailyRootCauseAnalysis"

# Define the access restriction IP ranges
$ipRanges = @(
    "192.30.252.0/22",
    "185.199.108.0/22",
    "140.82.112.0/20",
    "143.55.64.0/20",
    "140.82.121.33/32",
    "140.82.121.34/32",
    "140.82.113.33/32",
    "140.82.113.34/32",
    "192.30.252.153/32",
    "192.30.252.154/32",
    "185.199.108.153/32",
    "185.199.109.153/32",
    "52.23.85.212/32",
    "52.0.228.224/32",
    "52.22.155.48/32",
    "20.75.217.40/29",
    "4.148.0.0/16",
    "4.149.0.0/18",
    "4.149.64.0/19",
    "4.149.96.0/19",
    "13.105.117.0/31",
    "13.105.117.10/31",
    "13.105.117.100/31",
    "13.105.117.102/31",
    "20.42.11.16/28",
    "172.191.151.48/28",
    "172.203.190.240/28",
    "172.203.190.64/28",
    "18.213.123.130/32",
    "3.217.79.163/32",
    "3.217.93.44/32"
)

# Add each IP range as an access restriction
$priority = 100  # Starting priority
foreach ($ip in $ipRanges) {
    # Create a rule name that is unique
    $ruleName = "Allow-" + ($ip -replace '\.', '_')  # Replace dots with underscores for the rule name
    az functionapp config access-restriction add --resource-group $resourceGroupName `
                                                 --name $functionAppName `
                                                 --rule-name $ruleName `
                                                 --priority $priority `
                                                 --action Allow `
                                                 --ip-address $ip
    $priority += 1  # Increment priority for the next rule
}

# Add a final "Deny All" rule to block access from any other IPs
az functionapp config access-restriction add --resource-group $resourceGroupName `
                                             --name $functionAppName `
                                             --rule-name "Deny-All" `
                                             --priority $priority `
                                             --action Deny `
                                             --ip-address "0.0.0.0/0"
