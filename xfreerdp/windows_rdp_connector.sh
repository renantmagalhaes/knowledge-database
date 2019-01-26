#!/bin/bash
#
# windowsRDPconnector.sh - Scrip to connect  
#
#Site       :http://renantmagalhaes.com
#Autor      :Renan Toesqui Magalhães <renantmagalhaes@gmail.com>
#
# ---------------------------------------------------------------
#   
# Improved way to connect to windows servers in linux
#   
#
# --------------------------------------------------------------
#
# Changelog
#
#   V1.0 2016-05, RTM:
#       - Inicial Release
#       - Logic formation
#
#   TODO
#
#
#	- Improve design
#	- Add more functionalities 	
#
#
##
#RTM
# Menu loop
while : ; do

# Menu index
    user=$(
    dialog --stdout --inputbox 'Input your user name' 0 0 )

    answer=$(
      dialog --stdout  				    \
             --title 'WindowsRDP Connector' 	\
             --menu 'Choose a server' \
            0 0 0      					\
	    '==' '============ Structure One ============'     	\
	    01 'Server 1' 			                \
        02 'Server 2'  		        \
	    '==' '============ Structure Two ============' 	    \
	    03 'Server 1'  				                \
	    04 'Server 2' 		            \
	    '==' '============ Structure Three ============' 	    \
	    05 'Server 1' 			            \
	    '==' '============ Structure Four ============' 	    \
	    06 'Server 1' 				                    \
	    07 'Server 2' 				                \
	    08 'Structure 3' 		            \

        '==' '============ Extra  ============' 	    \
        99 'Manual'        				                \
            0 'Sair'
     		 )

# User Press CANCELAR or ESC - let's get it out
    [ $? -ne 0 ] && break

# Choose a option to start a action
# HERE is where you configure yours servers IP address
    case "$answer" in
	01) xfreerdp +drives +clipboard /size:1366x690 /u:$user /v:10.0.0.14:3389  ;;
        02) xfreerdp +drives +clipboard /size:1366x690 /u:$user /v:10.0.0.7:3389   ;;  
        03) xfreerdp +drives +clipboard /size:1366x690 /u:$user /v:10.0.0.13:3389  ;;
        04) xfreerdp +drives +clipboard /size:1366x690 /u:$user /v:10.0.0.5:3389   ;;  
        05) xfreerdp +drives +clipboard /size:1366x690 /u:$user /v:10.0.0.8:3389   ;;  
        06) xfreerdp +drives +clipboard /size:1366x690 /u:$user /v:10.0.0.7:3389  ;;
        07) xfreerdp +drives +clipboard /size:1366x690 /u:$user /v:10.0.0.9:3389   ;;  
        08) xfreerdp +drives +clipboard /size:1366x690 /u:$user /v:10.0.0.8:3389   ;;  
 
	 
     0) break ;;
	 99) ip=$(dialog --stdout --inputbox 'Input IP' 0 0 )
		 xfreerdp +drives /size:800x600 /u:$user /v:$ip:3389 

    esac

done

# End
echo 'Have a nice day'
#RTM
