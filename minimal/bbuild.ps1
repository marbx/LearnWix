
$wixpath = 'C:\Program Files (x86)\WiX Toolset v3.11\bin'
$displayversion  = & ..\salt\pkg\windows\buildenv\bin\python.exe ..\salt\salt\version.py
$internalversion = & ..\salt\pkg\windows\buildenv\bin\python.exe ..\salt\salt\version.py msi

Write-Host -ForegroundColor Green "Found Salt   $displayversion (msi $internalversion)"


Write-Host -ForegroundColor Yellow "Compiling cs..."
# https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/compiler-options/filealign-compiler-option
Push-Location C:\dev\salt-windows-msi\wix.d\MinionConfigurationExtension
& "C:\Program Files (x86)\MSBuild\14.0\bin\csc.exe" `
 /nologo /noconfig /nowarn:1701,1702 /nostdlib+ /errorreport:prompt /warn:4 /define:TRACE /highentropyva- `
 /reference:"C:\Program Files (x86)\WiX Toolset v3.11\SDK\Microsoft.Deployment.WindowsInstaller.dll" `
 /reference:"C:\Windows\Microsoft.NET\Framework\v2.0.50727\mscorlib.dll" `
 /reference:"C:\Windows\Microsoft.NET\Framework\v2.0.50727\System.dll" `
 /reference:"C:\Windows\Microsoft.NET\Framework\v2.0.50727\System.Xml.dll" `
 /reference:"c:\Program Files (x86)\WiX Toolset v3.11\bin\wix.dll" `
 /debug:pdbonly /filealign:512 /optimize+ `
 /out:obj\x86\Release\MinionConfigurationExtension.dll `
 /ruleset:"C:\Program Files (x86)\Microsoft Visual Studio 14.0\Team Tools\Static Analysis Tools\\Rule Sets\MinimumRecommendedRules.ruleset" `
 /target:library /utf8output `
 MinionConfiguration.cs `
 MinionConfigurationUitilies.cs `
 Properties\AssemblyInfo.cs 
Pop-Location
cmd /r dir  /b wix.d\MinionConfigurationExtension\obj\x86\Release\*.dll
Write-Host -ForegroundColor Yellow "...done"


##################### PackCustomAction

Write-Host -ForegroundColor Yellow "Collecting files... TODO"



Write-Host -ForegroundColor Yellow "Compiling wxs..."
# Create Temporary folder
cmd /r rmdir /q /s bbuild
cmd /r mkdir       bbuild
#     supress warning CNDL1150  (Consider WixUtilExtension ServiceConfig) 
& "$wixpath\candle.exe" `
  -nologo `
  -sw1150 `
  -dDisplayVersion="$displayversion" `
  -dInternalVersion="$internalversion" `
  -d"MinionConfigurationExtension.TargetDir"="wix.d\MinionConfigurationExtension\bin\Release\" `
  -d"MinionConfigurationExtension.TargetName"="MinionConfigurationExtension" `
  -ddist="..\salt\pkg\windows\buildenv" `
  -ext "$wixpath\WixUtilExtension.dll" `
  -out "bbuild\" `
  wix.d\MinionMSI\Product.wxs `
  wix.d\MinionMSI\service.wxs `
  wix.d\MinionMSI\MinionConfigurationExtensionCA.wxs `
  wix.d\MinionMSI\SettingsCustomizationDlg.wxs `
  wix.d\MinionMSI\WixUI_Minion.wxs 
Write-Host -ForegroundColor Yellow "...done"
cmd /r dir /b bbuild


Write-Host -ForegroundColor Yellow "Linking... TODO"