# Invoke-URLParse
Description:

Parse a URL and return information regarding the URL &amp; parameters. Will also decode the URL if specified.

Usage: 
```powershell
$urlParseObj = Invoke-URLParse -URL 'https://subdomain.domain.com/test.php?param1=testValue&param2=test%2BValue1&param3=%4D%53%44%4E' -Decode
```

`$urlParseObj` is a hashtable containing fully decoded URL, base domain, and another hash table with URL parameter names and values.
