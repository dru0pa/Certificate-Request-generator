<#
.SYNOPSIS
    Generates a certificate signing request (CSR) for an HTML 5 Gateway Docker certificate.

.DESCRIPTION
    This PowerShell script automates the process of creating a certificate signing request (CSR) for an HTML 5 Gateway Docker certificate. It prompts the user for the FQDN, IP address, and certificate template name, then generates the CSR file using `certreq.exe`. The script also copies the generated files (certreq.inf and the CSR) to the script's directory for easy access.

.PARAMETER None
    This script does not accept any parameters.

.NOTES
    Author: Isaac and Andrew
    From TRINEXIA Africa
    Created: 2024-10-10

.EXAMPLE
    To run the script, save it as a .ps1 file (e.g., Generate-HTML5GatewayCSR.ps1) and execute it from a PowerShell prompt:
    .\Generate-HTML5GatewayCSR.ps1

    The script will prompt you for the following information:
    * FQDN (e.g., html5gw-2.cyberark.lab).
    * IP address (e.g., 192.168.10.49).
    * Certificate template name (e.g., html5gw). This certificate must be listed in the CA templates.

    After providing the information, the script will generate the CSR file and open it in Notepad.
#>

# Prompt for the FQDN
$fqdn = Read-Host "Enter the FQDN (e.g., html5gw-2.cyberark.lab)"

# Prompt for the IP address
$ip = Read-Host "Enter the IP address (e.g., 192.168.10.49)"

# Prompt for the certificate template name
$templateName = Read-Host "Enter the certificate template name (e.g., html5gw)"

# Extract the short name from the FQDN
$shortName = ($fqdn -split "\.")[0]

# Construct the certificate request
$request = @"
[NewRequest]
Subject="CN=$fqdn"
Exportable=TRUE
KeyLength=2048
MachineKeySet=TRUE
FriendlyName="HTML 5 Gateway Docker Certificate"
KeySpec=1
KeyUsage=0xA0
ProviderName="Microsoft RSA SChannel Cryptographic Provider"
[EnhancedKeyUsageExtension]
OID=1.3.6.1.5.5.7.3.1
[RequestAttributes]
CertificateTemplate="$templateName"
[Extensions]
2.5.29.17 = "{text}"
_continue_ = "DNS=$fqdn&"
_continue_ = "DNS=$shortName"
_continue_ = "DNS=$ip"
"@

# Get the current script directory
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Create a temporary folder in the script directory
$tempFolder = Join-Path $scriptDir "Temp"
New-Item -ItemType Directory -Path $tempFolder -Force

# Remove old certreq files if they exist
$oldCertreqInf = Join-Path $tempFolder  "$fqdn.inf"
$oldCertreqReq = Join-Path $tempFolder "$fqdn.req"

if (Test-Path $oldCertreqInf) {
    Remove-Item -Path $oldCertreqInf -Force
}

if (Test-Path $oldCertreqReq) {
    Remove-Item -Path $oldCertreqReq -Force
}


del "$env:TEMP\certreq.inf"
del "$env:TEMP\cacert.req"
New-Item -Path "$env:TEMP\certreq.inf" -Value $request -ItemType File -Force
certreq.exe -new "$env:TEMP\certreq.inf" "$env:TEMP\cacert.req"

# Open the files to check if the generated request is correct
notepad "$env:TEMP\cacert.req"
notepad "$env:TEMP\certreq.inf"
