<#
.SYNOPSIS
Parse a URL from user input.

.DESCRIPTION
Parse a URL and return information regarding the URL & parameters. Will also decode the URL if specified.

.PARAMETER URI
Enter a URL to parse.

.PARAMETER Decode
Switch to activate URL decoding.

.OUTPUTS
Returns a object containing the results to the console.

.EXAMPLE
$urlParseObj = Invoke-URLParse -URL 'https://subdomain.domain.com/test.php?param1=testValue&param2=test%2BValue1&param3=%4D%53%44%4E' -Decode

.NOTES
Contact information:
https://github.com/bradydonovan
@b_radmn
#>
function Invoke-URLParse {
    param (
        [parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [URI]$URL,
        [parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [switch]$Decode
    )
    process {
        #URL Decode
        IF ($Decode) {
            [URI]$decodedURL = [System.Web.HttpUtility]::UrlDecode($URL.OriginalString)
            $URL = $decodedURL
        }

        #grab obj w/o HTTP/HTTPS
        $baseDomain = $URL.Host

        #split the query out, grab params
        $newURL = $URL.Query.Split("?")
        $urlParameters = $newURL.Split("&")

        #parse params to PSCustomObj
        $parameterTable =
        Foreach ($param in $urlParameters) {
            [PSCustomObject]@{
                Name  = ($param | Select-String -Pattern '[^=]+').Matches.Value 
                Value = ($param | Select-String -Pattern '(?<=\=).*').Matches.Value
            }
        }

        Return [PSCustomObject]@{
            decodedURL     = $decodedURL
            strippedDomain = $baseDomain
            Parameters     = $parameterTable
        }
    }
}