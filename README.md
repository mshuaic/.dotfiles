# linux Notes

## zsh
  * Prompt only displays the basename of the current directory.  
    Change `%~` to `%1~`  
    [Reference](http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html) 
    
## raspberry pi
 * headless wifi  
 	**wpa_supplicant.conf**
	```
	country=US
	ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
	update_config=1

	network={
		ssid="your_real_wifi_ssid"
		scan_ssid=1
		psk="your_real_password"
		key_mgmt=WPA-PSK
	}
	```
* headless ip address setup  
add a line in **cmdline.txt**  
`ip=192.168.0.10`
