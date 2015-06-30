#coding=utf8
#region 关键代码：强迫以管理员权限运行
$currentWi = [Security.Principal.WindowsIdentity]::GetCurrent()
$currentWp = [Security.Principal.WindowsPrincipal]$currentWi
if( -not $currentWp.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
  $boundPara = ($MyInvocation.BoundParameters.Keys | foreach{
     '-{0} {1}' -f  $_ ,$MyInvocation.BoundParameters[$_]} ) -join ' '
  $currentFile = (Resolve-Path  $MyInvocation.InvocationName).Path
 
 $fullPara = $boundPara + ' ' + $args -join ' '
 Start-Process "$psHome\powershell.exe"   -ArgumentList "$currentFile $fullPara"   -verb runas
 return
}
#endregion
#region 测试脚本片段
function update()
{
    New-Item -Path C:/home/rzrk/backup -ItemType Directory –Force
	New-Item -Path C:/home/rzrk/db_bak -ItemType Directory –Force
	New-Item -Path C:/home/rzrk/db_bak/bak -ItemType Directory –Force
	New-Item -Path C:/home/rzrk/server/userdata -ItemType Directory –Force
	New-Item -Path C:/home/rzrk/server/userdata/pids -ItemType Directory –Force
	Remove-Item C:/home/rzrk/server/bin/core* 
	python Deploy.py 2 .
	#crontab /home/rzrk/crontab
	#ldconfig      [void][reflection.assembly]::LoadFile("D:/VS2008/VC/Math2.dll")(powershell)
	#/home/rzrk/server/monitor/dailyRestart.sh
	# Get-Location 
	Invoke-Item C:\Windows
	Write-Host "check update info"
	Deploy.py 1 update.json check.json
	if Test-Path check.json#check.json在哪{
		Write-Host "check error, please read check.json!"
		Write-Host 'cat check.json'}
	
	}
#endregion	

#下面还没怎么改
if [ "$1" = "0" ]
then
	Write-Host "back up"
	python Deploy.py 0 .
	Write-Host "check local is changed"
	python Deploy.py 1 lastUpdate.json changed.json
	if Test-Path check.json{
		python Deploy.py 4 changed.json modify.tar.gz
		Write-Host "file has changed, please submit to xt manager"}
	else{
		function update}
	
elif [ "$1" = "1" ]
then
	echo "direct"
	update
else
	rm -rf _update
	mkdir _update
	tar -xzvf $1 -C _update
	cd _update
	chmod +x update.sh
	./update.sh 0
	rm update.sh
	cp ../update.sh update.sh
	./update.sh 1
fi