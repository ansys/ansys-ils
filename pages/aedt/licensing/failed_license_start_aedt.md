### Failed to check out license (HFSS, Maxwell, Simplorer, etc) when starting Electronics Desktop

If you launch Electronics Desktop and see a message containing multiple license errors like:

Failed to check out license 'hfss_desktop'.
License server does not support this license (FLEXlm Error -18)

Failed to check out license 'designer_desktop'.
License server does not support this license (FLEXlm Error -18)

Failed to check out license 'q3d_desktop'.
License server does not support this license (FLEXlm Error -18)

Failed to check out license 'maxwell_desktop'.
License server does not support this version of this license (FLEXlm Error -25)

Failed to check out license 'simplorer_desktop'.
License server does not support this license (FLEXlm Error -18)

Failed to check out license 'electronics_desktop'.
License server does not support this version of this license (FLEXlm Error -25)

In most of cases that means that you could not get any GUI license file for some of following reasons:

1) You do not have any available license in the license pool.
Open ANSYS License Management Center on the license server and go to View FlexNet Licenses to check your license expiration date.
If you have new license click on "Add a License File" and browse button, then select new license file

2. You did not specify license server address.

   Please verify that in 
   `C:\Program Files\AnsysEM\Shared Files\Licensing\ansyslmd.ini`
   file you have specified the IP of the server and the port respecting the format:

   ~~~bash
   SERVER=1055@127.0.0.1
   SERVER=1055@LICENSE5
   SERVER=1055@LICSRV1
   ~~~

   or if you prefer to use environment variables, then set:

   ~~~bash
   set ANSYSLMD_LICENSE_FILE=1055@127.0.0.1;1055@LICENSE5;1024@LICSRV1
   set ANS_FLEXLM_DISABLE_DEFLICPATH=1
   ~~~

3. License Manager is not running.
  Open  ANSYS License Management Center  and on the tab "View Status/Start/Stop License Manager" check that all services are running [3/3]. If not, click Stop and then Start button

4. Firewall/antivirus/(local IT opened ports) are blocking connection between your machine and license server.

   Things To check:

   a) Open the Run command: (go to your Start button and issue the 'Run' command (no quotes) or click `Windows button + R`

   b) Type in `cmd` and press `Ctrl+Shift+Enter` (command prompt should be Run As Administrator).

   c) Enter the following line to turn on the telnet client:

   ~~~bash
   dism /online /Enable-Feature /FeatureName:TelnetClient
   ~~~

   d) When telnet is activated type in the Command prompt `telnet IP-address_server port_server`. If you get a blank screen that means that the IP address and the port are opened. If you get a message connection failed please check the gate between machine and server

   Command example: 

   ~~~bash
   telnet 127.0.0.1 1055
   ~~~

   
