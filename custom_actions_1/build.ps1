# Set-ExecutionPolicy RemoteSigned

Set-PSDebug -Strict
Set-strictmode -version latest


$msbuild = "C:\Program Files (x86)\MSBuild\14.0\"    # Build tools 2015

function CheckExitCode($txt) {
    if ($LastExitCode -ne 0) {
        Write-Host -ForegroundColor Red "$txt failed"
        exit(1)
    }
}


Write-Host -ForegroundColor Yellow "Compiling cs into dll..."
# https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/compiler-options/filealign-compiler-option
Push-Location CA1
$releasedir = "obj\x86\Release"
cmd /r del /q $releasedir\*.dll
if (!(Test-Path -Path $releasedir)){New-Item -ItemType directory -Path $releasedir}
& "$($msbuild)bin\csc.exe" `
    /nologo /noconfig /nowarn:1701,1702 /nostdlib+ /errorreport:prompt /warn:4 /define:TRACE /highentropyva- `
    /reference:"$($ENV:WIX)SDK\Microsoft.Deployment.WindowsInstaller.dll" `
    /reference:"$($ENV:WIX)bin\wix.dll" `
    /reference:"C:\Windows\Microsoft.NET\Framework\v2.0.50727\mscorlib.dll" `
    /reference:"C:\Windows\Microsoft.NET\Framework\v2.0.50727\System.dll" `
    /reference:"C:\Windows\Microsoft.NET\Framework\v2.0.50727\System.Xml.dll" `
    /debug:pdbonly /filealign:512 /optimize+ `
    /out:$releasedir\CA1.dll `
    /target:library /utf8output `
    CA1.cs `
    Properties\AssemblyInfo.cs 
CheckExitCode "Compiling cs"
Pop-Location


# Usage: MakeSfxCA <outputca.dll> SfxCA.dll <inputca.dll> [support files ...]
# Makes a self-extracting managed MSI CA or UI DLL package.

Write-Host -ForegroundColor Yellow "Packing dll's into CA.dll..."
& "$($ENV:WIX)sdk\MakeSfxCA.exe" `
    "$pwd\CA1\obj\x86\Release\CA1.CA.dll" `
    "$($ENV:WIX)sdk\x86\SfxCA.dll" `
    "$pwd\CA1\obj\x86\Release\CA1.dll" `
    "$($ENV:WIX)SDK\Microsoft.Deployment.WindowsInstaller.dll" `
    "$($ENV:WIX)bin\wix.dll" `
    "$($ENV:WIX)bin\Microsoft.Deployment.Resources.dll" `
    "$pwd\CA1\CustomAction.config"
CheckExitCode "Packing dll's"


Write-Host -ForegroundColor Yellow "Collecting files... TODO"



Write-Host -ForegroundColor Yellow "(candle) wxs to wixobj..."

& "$($ENV:WIX)bin\candle.exe" `
    -nologo `
    -sw1150 `
    -ddist=".\" `
    -ext "$($ENV:WIX)bin\WixUtilExtension.dll" `
    Product.wxs `
    CA1CA.wxs  
CheckExitCode "candle"


Write-Host -ForegroundColor Yellow "(light) wixobj to msi..."
& "$($ENV:WIX)bin\light" -nologo `
    Product.wixobj `
    CA1CA.wixobj `
    -ext "$($ENV:WIX)bin\WixUtilExtension.dll" `
    -ext "$($ENV:WIX)bin\WixNetFxExtension.dll" `
    -out Product.msi

#  C:\Program Files (x86)\WiX Toolset v3.11\bin\Light.exe -out C:\git\salt-windows-msi\wix.d\MinionMSI\bin\Release\Salt-Minion-3000.1-Py3-64bit.msi -pdbout C:\git\salt-windows-msi\wix.d\MinionMSI\bin\Release\Salt-Minion-Setup.wixpdb -cultures:null -ext "C:\Program Files (x86)\WiX Toolset v3.11\bin\\WixUtilExtension.dll" -ext "C:\Program Files (x86)\WiX Toolset v3.11\bin\\WixUIExtension.dll" -ext "C:\Program Files (x86)\WiX Toolset v3.11\bin\\WixNetFxExtension.dll" -sice:ICE03 -contentsfile obj\Release\MinionMSI.wixproj.BindContentsFileListnull.txt -outputsfile obj\Release\MinionMSI.wixproj.BindOutputsFileListnull.txt -builtoutputsfile obj\Release\MinionMSI.wixproj.BindBuiltOutputsFileListnull.txt -wixprojectfile C:\git\salt-windows-msi\wix.d\MinionMSI\MinionMSI.wixproj -nologo obj\Release\service.wixobj obj\Release\servicePython.wixobj obj\Release\ProductUIsettings.wixobj obj\Release\MinionConfigurationExtensionCA.wixobj obj\Release\Product.wixobj obj\Release\ProductUI.wixobj obj\Release\dist-amd64.wixobj

CheckExitCode "light"


