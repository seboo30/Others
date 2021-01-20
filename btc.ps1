$years = 3
$datenowclose = ([datetime]::UtcNow).tostring("yyyy-MM-dd")
$datenowopen = (get-date).AddDays(-1).tostring("yyyy-MM-dd")
$datepastclose = (get-date).AddDays($years * -365 - 1)
$datepastopen = $datepastclose.AddDays(-1).tostring("yyyy-MM-dd")
$datepastclose = $datepastclose.tostring("yyyy-MM-dd")
$Currency = "Eur"


$urlnow = "http://api.coindesk.com/v1/bpi/currentprice/Eur.json"
$urlpast = "https://api.coindesk.com/v1/bpi/historical/close.json?start=" + $datepastopen + "&end=" + $datepastclose


$btcnow = Invoke-WebRequest -Uri $urlnow  | 
            Select-Object -ExpandProperty Content | 
                ConvertFrom-Json | 
                    Foreach-Object { 
                        $_.bpi.$Currency | 
                            Add-Member -PassThru -Force -membertype Noteproperty -Name Time -Value $date }


$btcpast = Invoke-WebRequest -Uri $urlpast  | 
            Select-Object -ExpandProperty Content | 
                ConvertFrom-Json | 
                    Foreach-Object { 
                        $_.bpi | 
                            Add-Member -PassThru -Force -membertype Noteproperty -Name Time -Value $datepastclose }