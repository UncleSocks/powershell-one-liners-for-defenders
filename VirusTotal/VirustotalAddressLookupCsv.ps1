
<#
    Automate bulk IP address VirusTotal lookup from a text file and export the output to a CSV file.
    Either replace $TxtFilePath with the actual file path of the .txt file and $ApiKey with your virusTotal V3 API key, or define them as variables prior to running the one-liner.
#>

Get-Content -Path $TxtFilePath | ForEach-Object { $lookup=Invoke-RestMethod -Uri "https://www.virustotal.com/api/v3/ip_addresses/$_" -Method "GET" -Headers @{"accept"="application/json";"x-apikey"="$ApiKey"} -ErrorAction SilentlyContinue; [PSCustomObject]@{IpAddress=$_;AsOwner=$lookup.data.attributes.as_owner;Malicious=$lookup.data.attributes.last_analysis_stats.malicious;Suspicious=$lookup.data.attributes.last_analysis_stats.suspicious;Undetected=$lookup.data.attributes.last_analysis_stats.undetected;Harmless=$lookup.data.attributes.last_analysis_stats.harmless;Timeout=$lookup.data.attributes.last_analysis_stats.timeout}} | Export-Csv -Path "output.csv" -NoTypeInformation