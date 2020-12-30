# 例子 tcp--ping www.baidu.com 80
param
(
	$MyComputerName = 'www.baidu.com',
	[uint16]$port = '80',
	[switch]$Quiet = $false
)

#Write-Verbose "$MyComputerName $port $Quiet"

if ( ($MyComputerName -eq 'www.baidu.com') -and ($port -eq '80') )
{
	Write-Host "命令格式： tcp--ping 域名 端口" -ForegroundColor Yellow
}

try
{
	[array]$ip地址组 = [System.Net.Dns]::GetHostAddresses($MyComputerName) | Where-Object { $_.AddressFamily -eq 'InterNetwork' }
}
catch
{
	if ($Quiet -eq $true)
	{
		return $false
	}
	else
	{
		Write-Host  -NoNewline  '【'
		Write-Host  -NoNewline  $mycomputerName  -ForegroundColor  Red
		Write-Host  -NoNewline  "】DNS解析失败!`n"
	}
}
finally
{

}

#问：这个脚本谁写的？有问题找谁技术支持？
#答：QQ群号=183173532
#名称=powershell交流群
#华之夏，脚之巅，有我ps1片天！
#专门教学win，linux通用的ps1脚本。不想学也可以，入群用红包求写脚本。

foreach ($单个ip in $ip地址组)
{
	$tcp对象 = New-Object System.Net.Sockets.TCPClient
	$connect = $tcp对象.BeginConnect($单个ip, $port, $null, $null)
	$wait = $Connect.AsyncWaitHandle.WaitOne(2000, $false)
	if ($Quiet -eq $true)
	{
		if ($tcp对象.Connected -eq $true)
		{
			return $true
		}
		else
		{
			return $false
		}
	}
	else
	{
		if ($tcp对象.Connected -eq $true)
		{
			Write-Host  -NoNewline  "【$单个ip】【"
			Write-Host  -NoNewline  "$port"  -ForegroundColor  Green
			Write-Host  -NoNewline  "】"
			Write-Host  -NoNewline  " 通了`n"   -ForegroundColor  Green
		}
		else
		{
			Write-Host  -NoNewline  "【$单个ip】【"
			Write-Host  -NoNewline  "$port"  -ForegroundColor Red
			Write-Host  -NoNewline  "】"
			Write-Host  -NoNewline  " 不通`n"   -ForegroundColor Red
		}
	}
	$tcp对象.Close()
	$tcp对象.Dispose()
}

Write-Host    -ForegroundColor   Yellow  "`n大网站现在全都学坏了：`n每个域名每次解析出至少2个ip，每隔几分钟就换2个ip。`n所以你的【端口测试程序】也应该升级了"



exit 0
