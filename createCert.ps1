
function New-SelfSignedCert {
    <#
        .SYNOPSIS
        Create a new, self-signed signing cert
    
        .DESCRIPTION

        .PARAMETER CN
        The common name of the certificate

        .PARAMETER validityMonths
        Cert validity in month (from start of validity - see below)
    
        .EXAMPLE
            PS C:\> New-SelfSignedCert xyz.com
       
    #>
        [CmdletBinding()]
        param(
            [Parameter(Mandatory)]            
            [ValidateNotNullOrEmpty()]
            [string]$CN,

            [ValidateNotNullOrEmpty()]
            [string]$pfxPath,          
            
            [ValidateNotNullOrEmpty()]
            [string]$cerPath,          
            
            [ValidateNotNullOrEmpty()]
            [string]$password,
            
            [ValidateNotNullOrEmpty()]
            [int]$validityMonths = 12
            
        )
        $certSubject = ("CN={0}" -f $CN)
        Write-Host ("Creating X509 cert {0}" -f $certSubject)
        try {
            $cert = New-SelfSignedCertificate `
                -KeyExportPolicy Exportable `
                -Subject ($certSubject) `
                -KeyAlgorithm RSA `
                -KeyLength 2048 `
                -KeyUsage DigitalSignature `
                -NotBefore (Get-Date) `
                -NotAfter (Get-Date).AddMonths($validityMonths) `
                -CertStoreLocation "Cert:\CurrentUser\My"
            $pfxPwd = ConvertTo-SecureString -String $password -Force -AsPlainText
            $cert | Export-PfxCertificate -FilePath $pfxPath -Password $pfxPwd
            $pkcs12=[Convert]::ToBase64String([System.IO.File]::ReadAllBytes((get-childitem -path $pfxPath).FullName))
            $base64Cert = $([Convert]::ToBase64String($cert.Export('Cert'), [System.Base64FormattingOptions]::InsertLineBreaks))
            Set-Content -Path $cerPath -Value $base64Cert
            Write-Host "ClientCert.cer file created"
        } catch {
            Write-Error "Error creating/writing or reading an X509 certificate."
            Write-Error ("Please create it using other tools and store in B2C Policy Key storage with container name: {0}" -f $keyName)
            return
        }
        Write-Host ("Certificate created and uploaded" -f $certSubject)
        Write-Host ("Thumbprint: {0}" -f $cert.Thumbprint)
}


new-selfsignedcert -CN *.beitmerari.com `
   -pfxPath ".\gateway\certs\mrcert.pfx" `
   -cerPath ".\gateway\certs\mrcert.cer" `
   -password "Pass@word#1"

   # thumbprint: 1FFE3ECEB441445BE22E69D12DD8746673E7CB62
   