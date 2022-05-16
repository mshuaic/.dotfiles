# Linux Notes

## Menu
- [shell](#shell)
- [raspberry pi](#raspberry-pi)
- [apt](#ap)
- [X11](#x11)

## shell
### bash
- remove double quotes.
	- all `"${opt//\"}"`
	- suffix `"${opt%\"}"`
	- prefix `"${opt#\"}"` 

### zsh
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
add a line in [**cmdline.txt**](https://elinux.org/RPi_cmdline.txt)  
`ip=192.168.0.10`

## apt
- sudo dpkg -i --force-overwrite /var/cache/apt/archives/apport_2.20.1-0ubuntu2.4_all.deb

## X11
### Solution for `Warning: No xauth data; using fake authentication data for X11 forwarding.`
  ```bash
  touch ~/.Xauthority
  xauth generate $DISPLAY .
  ```
