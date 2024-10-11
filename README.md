# Generate-HTML5GatewayCSR

This PowerShell script automates the creation of a certificate signing request (CSR) for an HTML 5 Gateway Docker certificate.

## Description

This script simplifies the process of generating a CSR for securing your HTML 5 Gateway Docker deployment. 
It prompts you for the necessary information (FQDN, IP address, and certificate template name) and then uses `certreq.exe` to create the CSR file. 
The script also conveniently saves the generated files (certreq.inf and the CSR) to its own directory for easy retrieval.

## Prerequisites

* **PowerShell:** This script requires PowerShell to be executed.
* **certreq.exe:** This Windows utility is used to generate the CSR. It should be available by default on most Windows systems.
* **Certificate Authority:** You'll need access to a Certificate Authority (CA) to sign the generated CSR.  The specified certificate template must be configured in your CA.

## Usage

1. **Save the script:** Save the code as a `.ps1` file (e.g., `Generate-HTML5GatewayCSR.ps1`).
2. **Run the script:** Open a PowerShell prompt and execute the script:

   ```powershell
   .\Generate-HTML5GatewayCSR.ps1
