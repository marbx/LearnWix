### enjoy uninstall log with REMOVE_CONFIG

Action start 10:29:38: WixRemoveFoldersEx.
WixRemoveFoldersEx:  Recursing path: C:\Program Files (x86)\Acme\Foobar 1.0\ for row: wrfC080834F25891F84E6EEDCAECFC86E7A.
Action ended 10:29:38: WixRemoveFoldersEx. Return value 1.

### ignore ugly install log and uninstall log without REMOVE_CONFIG

Action start 10:04:58: WixRemoveFoldersEx.
WixRemoveFoldersEx:  Error 0x80070057: Missing folder property: INSTALLFOLDER for row: wrfC080834F25891F84E6EEDCAECFC86E7A
CustomAction WixRemoveFoldersEx returned actual error code 1603 but will be translated to success due to continue marking
Action ended 10:04:58: WixRemoveFoldersEx. Return value 1.


### links

https://www.hass.de/content/wix-how-use-removefolderex-your-xml-scripts

https://stackoverflow.com/questions/320921/how-to-add-a-wix-custom-action-that-happens-only-on-uninstall-via-msi


https://stackoverflow.com/questions/195919/removing-files-when-uninstalling-wix


https://wafoster.wordpress.com/2013/07/03/fun-with-wix-conditional-features/

