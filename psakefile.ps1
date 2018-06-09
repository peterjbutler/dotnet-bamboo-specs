Task Default -depends Header, Clean, MavenDependencyCopy, IkvmcBuild, NugetPack

Task Clean -depends Clean-Java, Clean-DotNet, Clean-Nuget

Task IkvmcBuild -depends IkvmcBuild-bamboo-specs

####################################
# Common functions
####################################

FormatTaskName {
	param($taskName)
	if ($taskName -ne "Header") {
		write-host (("-"*28) + "[ $taskName ]" + ("-"*28)) -ForegroundColor Cyan
	}
}

function Done {
	Write-Host ""
	Write-Host "[DONE]" -ForegroundColor Green
}

Task Header {
	Write-Host "================================================================================="
	Write-Host ""
	Write-Host "    ooooooooo                o8                            o8" -ForegroundColor DarkGreen
	Write-Host "     888    88o   ooooooo  o888oo oo oooooo   ooooooooo8 o888oo" -ForegroundColor DarkGreen
	Write-Host "     888    888 888     888 888    888   888 888oooooo8   888" -ForegroundColor DarkGreen
	Write-Host "     888    888 888     888 888    888   888 888          888" -ForegroundColor DarkGreen
	Write-Host "    o888ooo88     88ooo88    888o o888o o888o  88oooo888   888o" -ForegroundColor DarkGreen
	Write-Host ""
	Write-Host "    oooooooooo                            oooo" -ForegroundColor DarkGreen
	Write-Host "     888    888   ooooooo   oo ooo oooo    888ooooo     ooooooo     ooooooo" -ForegroundColor DarkGreen
	Write-Host "     888oooo88    ooooo888   888 888 888   888    888 888     888 888     888" -ForegroundColor DarkGreen
	Write-Host "     888    888 888    888   888 888 888   888    888 888     888 888     888" -ForegroundColor DarkGreen
	Write-Host "    o888ooo888   88ooo88 8o o888o888o888o o888ooo88     88ooo88     88ooo88" -ForegroundColor DarkGreen
	Write-Host ""
	Write-Host "     oooooooo8" -ForegroundColor DarkGreen
	Write-Host "    888        ooooooooo    ooooooooo8  ooooooo    oooooooo8" -ForegroundColor DarkGreen
	Write-Host "     888oooooo  888    888 888oooooo8 888     888 888ooooooo" -ForegroundColor DarkGreen
	Write-Host "            888 888    888 888        888                 888" -ForegroundColor DarkGreen
	Write-Host "    o88oooo888  888ooo88     88oooo888  88ooo888  88oooooo88" -ForegroundColor DarkGreen
	Write-Host "               o888" -ForegroundColor DarkGreen
	Write-Host ""
	Write-Host "    Author: Peter John Butler"
	Write-Host "    Link: https://github.com/peterjbutler/dotnet-bamboo-specs.git"
	Write-Host ""
	Write-Host "================================= Version 6.4.0 ================================="
	Write-Host ""
	Write-Host ""
}

####################################
# Clean tasks
####################################

Task Clean-Java {
	if (Test-Path .\java) 
	{	
		rd .\java -rec -force
	}
	mkdir .\java | out-null
	Done
}

Task Clean-DotNet {
	if (Test-Path .\dotnet) 
	{	
		rd .\dotnet -rec -force
	}
	mkdir .\dotnet | out-null
	Done
}

Task Clean-Nuget {
	if (Test-Path .\nuget) 
	{	
		rd .\nuget -rec -force
	}
	mkdir .\nuget | out-null
	Done
}

####################################
# Maven tasks
####################################

Task MavenDependencyCopy {
	mvn dependency:copy-dependencies -DoutputDirectory=java
	if ($lastexitcode -ne 0)
	{
		Write-Host "[ERROR]" -ForegroundColor Red
		throw "MavenDependencyCopy Task Failed!"
	}
	Done
}

####################################
# Ikvmc tasks
####################################

Task IkvmcBuild-commons-codec {
	ikvmc .\java\commons-codec-1.9.jar -target:library -out:.\dotnet\commons-codec-1.9.dll
	if ($lastexitcode -ne 0)
	{
		Write-Host "[ERROR]" -ForegroundColor Red
		throw "IkvmcBuild-commons-codec Task Failed!"
	}
	Done
}

Task IkvmcBuild-commons-collections {
	ikvmc .\java\commons-collections-3.2.2.jar -target:library -out:.\dotnet\commons-collections-3.2.2.dll
	if ($lastexitcode -ne 0)
	{
		Write-Host "[ERROR]" -ForegroundColor Red
		throw "IkvmcBuild-commons-collections Task Failed!"
	}
	Done
}

Task IkvmcBuild-commons-lang {
	ikvmc .\java\commons-lang3-3.4.jar -target:library -out:.\dotnet\commons-lang3-3.4.dll
	if ($lastexitcode -ne 0)
	{
		Write-Host "[ERROR]" -ForegroundColor Red
		throw "IkvmcBuild-gson Task Failed!"
	}
	Done
}

Task IkvmcBuild-commons-logging {
	ikvmc .\java\commons-logging-1.2.jar -target:library -out:.\dotnet\commons-logging-1.2.dll
	if ($lastexitcode -ne 0)
	{
		Write-Host "[ERROR]" -ForegroundColor Red
		throw "IkvmcBuild-commons-logging Task Failed!"
	}
	Write-Host "Please note: These warnings can be ignored." -ForegroundColor Yellow
	Done
}

Task IkvmcBuild-gson {
	ikvmc .\java\gson-2.8.0.jar -target:library -out:.\dotnet\gson-2.8.0.dll
	if ($lastexitcode -ne 0)
	{
		Write-Host "[ERROR]" -ForegroundColor Red
		throw "IkvmcBuild-gson Task Failed!"
	}
	Done
}

Task IkvmcBuild-httpcore {
	ikvmc .\java\httpcore-4.4.4.jar -target:library -out:.\dotnet\httpcore-4.4.4.dll
	if ($lastexitcode -ne 0)
	{
		Write-Host "[ERROR]" -ForegroundColor Red
		throw "IkvmcBuild-httpcore Task Failed!"
	}
	Done
}

Task IkvmcBuild-snakeyaml {
	ikvmc .\java\snakeyaml-1.18.jar -target:library -out:.\dotnet\snakeyaml-1.18.dll
	if ($lastexitcode -ne 0)
	{
		Write-Host "[ERROR]" -ForegroundColor Red
		throw "IkvmcBuild-snakeyaml Task Failed!"
	}
}

Task IkvmcBuild-bamboo-specs-api -depends IkvmcBuild-commons-lang {
	ikvmc .\java\bamboo-specs-api-6.4.0.jar -target:library -r:.\dotnet\commons-lang3-3.4.dll -out:.\dotnet\bamboo-specs-api-6.4.0.dll
	if ($lastexitcode -ne 0)
	{
		Write-Host "[ERROR]" -ForegroundColor Red
		throw "IkvmcBuild-bamboo-specs-api Task Failed!"
	}
	Done
}

Task IkvmcBuild-commons-beanutils -depends IkvmcBuild-commons-collections, IkvmcBuild-commons-logging {
	ikvmc .\java\commons-beanutils-1.9.2.jar -target:library -r:.\dotnet\commons-collections-3.2.2.dll -r:.\dotnet\commons-logging-1.2.dll -out:.\dotnet\commons-beanutils-1.9.2.dll
	if ($lastexitcode -ne 0)
	{
		Write-Host "[ERROR]" -ForegroundColor Red
		throw "IkvmcBuild-commons-beanutils Task Failed!"
	}
	Done
}

Task IkvmcBuild-httpclient -depends IkvmcBuild-commons-codec, IkvmcBuild-commons-logging, IkvmcBuild-httpcore {
	ikvmc .\java\httpclient-4.5.2.jar -target:library -r:.\dotnet\httpcore-4.4.4.dll -r:.\dotnet\commons-codec-1.9.dll -r:.\dotnet\commons-logging-1.2.dll -out:.\dotnet\httpclient-4.5.2.dll
	if ($lastexitcode -ne 0)
	{
		Write-Host "[ERROR]" -ForegroundColor Red
		throw "IkvmcBuild-httpclient Task Failed!"
	}
	Done
}

Task IkvmcBuild-commons-digester -depends IkvmcBuild-commons-beanutils, IkvmcBuild-commons-collections, IkvmcBuild-commons-logging {
	ikvmc .\java\commons-digester-1.8.1.jar -target:library -r:.\dotnet\commons-collections-3.2.2.dll -r:.\dotnet\commons-beanutils-1.9.2.dll -r:.\dotnet\commons-logging-1.2.dll -out:.\dotnet\commons-digester-1.8.1.dll
	if ($lastexitcode -ne 0)
	{
		Write-Host "[ERROR]" -ForegroundColor Red
		throw "IkvmcBuild-commons-digester Task Failed!"
	}
	Done
}

Task IkvmcBuild-commons-validator -depends IkvmcBuild-commons-beanutils, IkvmcBuild-commons-collections, IkvmcBuild-commons-digester, IkvmcBuild-commons-logging {
	ikvmc .\java\commons-validator-1.5.1.jar -target:library -r:.\dotnet\commons-digester-1.8.1.dll -r:.\dotnet\commons-collections-3.2.2.dll -r:.\dotnet\commons-beanutils-1.9.2.dll -r:.\dotnet\commons-logging-1.2.dll -out:.\dotnet\commons-validator-1.5.1.dll
	if ($lastexitcode -ne 0)
	{
		Write-Host "[ERROR]" -ForegroundColor Red
		throw "IkvmcBuild-commons-validator Task Failed!"
	}
	Done
}

Task IkvmcBuild-bamboo-specs -depends IkvmcBuild-commons-lang, IkvmcBuild-gson, IkvmcBuild-httpcore, IkvmcBuild-snakeyaml, IkvmcBuild-bamboo-specs-api, IkvmcBuild-httpclient, IkvmcBuild-commons-validator {
	ikvmc .\java\bamboo-specs-6.4.0.jar -target:library -r:.\dotnet\bamboo-specs-api-6.4.0.dll -r:.\dotnet\snakeyaml-1.18.dll -r:.\dotnet\commons-lang3-3.4.dll -r:.\dotnet\gson-2.8.0.dll -r:.\dotnet\commons-validator-1.5.1.dll -r:.\dotnet\httpcore-4.4.4.dll -r:.\dotnet\httpclient-4.5.2.dll -out:.\dotnet\bamboo-specs-6.4.0.dll
	if ($lastexitcode -ne 0)
	{
		Write-Host "[ERROR]" -ForegroundColor Red
		throw "IkvmcBuild-bamboo-specs Task Failed!"
	}
	Done
}

####################################
# Nuget tasks
####################################

Task NugetPack {
	nuget pack -OutputDirectory .\nuget\
	if ($lastexitcode -ne 0)
	{
		Write-Host "[ERROR]" -ForegroundColor Red
		throw "NugetDependencyRestore Task Failed!"
	}
	Done
}