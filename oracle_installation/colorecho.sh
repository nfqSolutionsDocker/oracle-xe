#!/bin/bash

cctitle='\e[30;46m'
cctitle2='\e[30;42m'
cctitle3='\e[30;43m'

cccommand='\e[36m'
cccommand2='\e[32m'
cccommand3='\e[33m'

ccred='\e[31m'
ccgreen='\e[32m'
ccyellow='\e[33m'

ccend='\e[0m'

echo_title() {
	echo -e "${cctitle}$@${ccend}"
}

echo_title2() {
	echo -e "${cctitle2}$@${ccend}"
}

echo_title3() {
	echo -e "${cctitle3}$@${ccend}"
}

echo_command() {
	echo -e "${cccommand}$@${ccend}"
}

echo_command2() {
	echo -e "${cccommand2}$@${ccend}"
}

echo_command3() {
	echo -e "${cccommand3}$@${ccend}"
}

echo_red() {
    echo -e "${ccred}$@${ccend}"
}

echo_green() {
    echo -e "${ccgreen}$@${ccend}"
}

echo_yellow() {
    echo -e "${ccyellow}$@${ccend}"
}

