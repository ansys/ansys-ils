## Could not connect to license server: 24110@<server name>. System error: 0 "".

With new version of Ansys Electronics Desktop 2022R1 you may see error messages when try to analyze across multiple products.
This is due to the change in the licensing methods in the product. To fix this issue, please manually set following environment variable:  
~~~
ANSYSCL_BIND_TO_LOOPBACK=1
~~~

Quick check in Windows Command Prompt, that solution helps:
~~~bash
set ANSYSCL_BIND_TO_LOOPBACK=1
"%ANSYSEM_ROOT221%\ansysedt.exe"
~~~

