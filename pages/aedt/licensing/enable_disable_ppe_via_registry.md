### Enable/disable PPE license via registry (for admins)

Instruction is valid for versions 2020R2, 2021R2 and above

To set or unset PPE license you need to run following command for each user:

~~~bash
<path to ansys>/AnsysEM21.2/Linux64/UpdateRegistry -Set -ProductName ElectronicsDesktop2021.2 -RegistryKey  Desktop/Settings/ProjectOptions/UsePPELicensing -RegistryValue 1  -RegistryLevel user
~~~



> Note: registry value equal 1 enables PPE, 0 will disable

> Note2: ProductName you can parse from: `<path to ansys>/AnsysEM21.2/Linux64/config/ProductList.txt`



also you can modify `C:\Program Files\AnsysEM\AnsysEM21.2\Win64\config\default.cfg`

~~~
$begin 'Config'
tempdirectory='C:/Temp'
Desktop/Settings/ProjectOptions/UsePPELicensing=1 
$end 'Config'
~~~

> Note: config file will work only in case if user never opened this version of AEDT



