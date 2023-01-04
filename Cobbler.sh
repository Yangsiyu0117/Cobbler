#!/bin/bash
# date : 2022.11.22
# Use：Centos 7
# Install Cobbler

#骚气颜色
show_str_Black() {
        echo -e "\033[30m $1 \033[0m"
}
show_str_Red() {
        echo -e "\033[31m $1 \033[0m"
}
show_str_Green() {
        echo -e "\033[32m $1 \033[0m"
}
show_str_Yellow() {
        echo -e "\033[33m $1 \033[0m"
}
show_str_Blue() {
        echo -e "\033[34m $1 \033[0m"
}
show_str_Purple() {
        echo -e "\033[35m $1 \033[0m"
}
show_str_SkyBlue() {
        echo -e "\033[36m $1 \033[0m"
}
show_str_White() {
        echo -e "\033[37m $1 \033[0m"
}

###
### Install Cobbler
###
### Usage:
###   bash install.sh -h
###   logfile in /root/logfile_`date +"%Y-%m-%d-%H%M%S"`.log
###          日志文件可以帮助你快速排错
###   checkfile in /root/check_file_`date +"%Y-%m-%d-%H%M%S"
###          检查文件可以帮你确认配置是否修改正确
### Options:
###   -h --help    Show this message.

help() {
        sed -rn 's/^### ?//;T;p' "$0"
}

if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
        help
        exit 1
fi

#获取当前时间
DATE=$(date +"%Y-%m-%d %H:%M:%S")
#获取当前主机名
HOSTNAME=$(hostname -s)
#获取当前用户
USER=$(whoami)
#获取当前内核版本参数
KERNEL=$(uname -r | cut -f 1-3 -d.)
#获取当前系统版本
SYSTEM=$(cat /etc/redhat-release)

web_ip=$(ifconfig | grep inet | grep netmask | awk '{print $2}' | head -n 1)
ip=$(ifconfig | grep inet | grep netmask | awk '{print $2}' | grep -v 127.0.0.1)
log_file="logfile_$(date +"%Y-%m-%d-%H%M%S").log"

#log_correct函数打印正常的输出到日志文件
function log_correct() {
        DATE=$(date "+%Y-%m-%d %H:%M:%S")
        USER=$(whoami) ####那个用户在操作
        show_str_Green "${DATE} ${USER} $0 [INFO] $@" >>/root/$log_file
}

#log_error函数打印错误的输出到日志文件
function log_error() {
        DATE=$(date "+%Y-%m-%d %H:%M:%S")
        USER=$(whoami)
        show_str_Red "${DATE} ${USER} $0 [ERROR] $@" >>/root/$log_file
}

cobbler_info() {
        show_str_Green "配置文件目录：/etc/cobbler"
        show_str_Green "cobbler主配置文件：/etc/cobbler/settings"
        show_str_Green "DHCP服务的配置模板：/etc/cobbler/dhcp.template"
        show_str_Green "存放kickstart文件目录：/var/lib/cobbler/kickstarts "
        show_str_Green "登录网址：https://$web_ip/cobbler_web"
        show_str_Green "默认用户名：cobbler   默认密码：cobbler"
        log_correct "配置文件目录：/etc/cobbler"
        log_correct "cobbler主配置文件：/etc/cobbler/settings"
        log_correct "DHCP服务的配置模板：/etc/cobbler/dhcp.template"
        log_correct "存放kickstart文件目录：/var/lib/cobbler/kickstarts "
        log_correct "登录网址：https://$web_ip/cobbler_web"
        log_correct "默认用户名：cobbler   默认密码：cobbler"
}

input_ip() {
        echo -e "$ip"
        read -p "请选择以上IP地址作为配置地址：" network_ip
        config_ip=$(echo $network_ip | cut -f 1-3 -d .)
        log_correct "服务器可选IP：$ip"
        log_correct "检测当前输出IP为：$network_ip"

}



close_software() {
        # selinux
        sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config >>/root/$log_file 2>&1
        # 防火墙
        systemctl stop firewalld >>/root/$log_file 2>&1
}

install_software() {
        if [ $(ps -ef | grep httpd | grep -v grep | wc -l) -eq 0 ] && [ $(ps -ef | grep cobblerd | grep -v grep | wc -l) -eq 0 ] && [ $(ps -ef | grep rsync | grep -v grep | wc -l) -eq 0 ] && [ $(ps -ef | grep xinetd | grep -v grep | wc -l) -eq 0 ]; then
                input_ip
                show_str_Yellow "========================================"
                show_str_Yellow "  安装cobbler相关包（时间较长，请稍等）。。。"
                show_str_Yellow "========================================"
                log_correct "###########################################################Yum安装cobbler\httpd\dhcp\xinetd###################################################"
                yum -y install wget >>/root/$log_file 2>&1
                wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo >>/root/$log_file 2>&1
                yum -y install cobbler cobbler-web pykickstart httpd dhcp tftp xinetd debmirror cman fence-agents >>/root/$log_file 2>&1
                if [ $(echo $?) -eq 0 ]; then
                        show_str_Green "========================================"
                        show_str_Green "            cobbler安装成功。。。"
                        show_str_Green "========================================"
                        log_correct "########################################################安装成功######################################################"
                else
                        show_str_Red "========================================"
                        show_str_Red "       cobbler安装失败，请查看日志。。。"
                        show_str_Red "========================================"
                        log_error "########################################################安装失败######################################################"
                        exit 0
                fi

        else
                show_str_Red "-------------------------------------------------------------"
                show_str_Red "|                        警告！！！                          |"
                show_str_Red "|    Cobbler has running already exists! please check!       |"
                show_str_Red "-------------------------------------------------------------"
                printinput
        fi

}

start_software() {
        systemctl start httpd && systemctl enable httpd >>/root/$log_file 2>&1
        systemctl start cobblerd && systemctl enable cobblerd >>/root/$log_file 2>&1
        systemctl start rsyncd && systemctl enable rsyncd >>/root/$log_file 2>&1
        systemctl start xinetd && systemctl enable xinetd >>/root/$log_file 2>&1
        if [ $(systemctl status dhcpd | grep running | wc -l) -eq 0 ]; then
                cobbler sync >>/root/$log_file 2>&1
                systemctl start dhcpd >>/root/$log_file 2>&1
        fi
        if [ $(echo $?) -eq 0 ]; then
                log_correct "########################################################服务启动成功######################################################"
                cobbler_info
        else
                log_error "########################################################服务启动失败######################################################"
        fi
}

configure() {
        log_correct "########################################################修改配置文件######################################################"
        cp /etc/cobbler/settings{,_$(date +%F).bak} >>/root/$log_file 2>&1
        sed -i 's#server: 127.0.0.1#server: '$network_ip'#g' /etc/cobbler/settings >>/root/$log_file 2>&1
        sed -i 's/pxe_just_once: 0/pxe_just_once: 1/g' /etc/cobbler/settings >>/root/$log_file 2>&1
        sed -i 's#next_server: 127.0.0.1#next_server: '$network_ip'#g' /etc/cobbler/settings >>/root/$log_file 2>&1
        sed -i '14s/yes/no/' /etc/xinetd.d/tftp >>/root/$log_file 2>&1
        sed -i 's/^default_password_crypted: "$1$mF86\/UHC$WvcIcX2t6crBz2onWxyac."/default_password_crypted: "$1$$(openss$WY5YH1ywIESp6xA\/dotYu\/"/g' /etc/cobbler/settings
        sed -i -e '28 s/^/#/' /etc/debmirror.conf >>/root/$log_file 2>&1
        sed -i -e '30 s/^/#/' /etc/debmirror.conf >>/root/$log_file 2>&1
        sed -i 's/manage_dhcp: 0/manage_dhcp: 1/g' /etc/cobbler/settings >>/root/$log_file 2>&1
        sed -i 's/192.168.1.5/'$network_ip'/g' /etc/cobbler/dhcp.template >>/root/$log_file 2>&1
        sed -i '23s/192.168.1.1/114.114.114.114/g' /etc/cobbler/dhcp.template >>/root/$log_file 2>&1
        cat /etc/cobbler/dhcp.template | grep 192.168.1 | sed -i 's/192.168.1/'$config_ip'/g' /etc/cobbler/dhcp.template >>/root/$log_file 2>&1
        show_str_Green "========================================"
        show_str_Green "            配置文件修改成功。。。"
        show_str_Green "========================================"
        systemctl restart cobblerd >>/root/$log_file 2>&1
        cobbler sync >>/root/$log_file 2>&1
        log_correct "########################################################修改完毕#####################################################"

}

cobbler_config() {
        show_str_Yellow "========================================"
        show_str_Yellow "  倒入Centos镜像（时间较长，请稍等）。。。"
        show_str_Yellow "========================================"
        systemctl restart cobblerd >>/root/$log_file 2>&1
        systemctl restart xinetd >>/root/$log_file 2>&1
        cobbler sync >>/root/$log_file 2>&1
        mount -o loop /dev/cdrom /mnt/ >>/root/$log_file 2>&1
        log_correct "########################################################倒入Centos镜像（时间较长，请稍等）。。。#####################################################"
        cobbler import --path=/mnt/ --name=CentOS-7.9-x86_64 --arch=x86_64 >>/root/$log_file 2>&1
        if [ $(echo $?) -eq 0 ]; then
                log_correct "########################################################倒入Centos镜像成功#####################################################"
                show_str_Green "========================================"
                show_str_Green "            配置文件修改成功。。。"
                show_str_Green "========================================"
        else
                log_error "########################################################倒入Centos镜像失败#####################################################"
                show_str_Red "========================================"
                show_str_Red "       倒入Centos镜像失败，请检查日志"
                show_str_Red "========================================"
                exit 0
        fi
        cp /root/CentOS-7.9-x86_64_cobbler.cfg /var/lib/cobbler/kickstarts/ >>/root/$log_file 2>&1
        cobbler profile edit --name=CentOS-7.9-x86_64 --kickstart=/var/lib/cobbler/kickstarts/CentOS-7.9-x86_64_cobbler.cfg >>/root/$log_file 2>&1
        cobbler profile report | grep Kickstart >>/root/$log_file 2>&1
        cp  /root/set_ip.sh /var/www/cobbler/links/CentOS-7.9-x86_64/
        if [ $(systemctl status dhcpd | grep running | wc -l) -eq 0 ]; then
                log_error "-------------------------------------------------------------"
                log_error "|                        警告！！！                          |"
                log_error "|                 dhcpd 服务未启动，请检查!                  |"
                log_error "-------------------------------------------------------------"
                cobbler sync >>/root/$log_file 2>&1
                systemctl start dhcpd >>/root/$log_file 2>&1

        fi

        show_str_Green "========================================"
        show_str_Green "       Centos7.9自动部署配置成功。。。"
        show_str_Green " Centos7.9 user:root  password:centos"
        show_str_Green "========================================"

}

uninstall_cobbler() {
        uninstall_date=$(date +"%Y-%m-%d-%H%M%S")
        trash=/tmp/trash/$uninstall_date
        mkdir -p $trash
        log_correct "########################################################卸载Cobbler#####################################################"
        systemctl stop httpd && systemctl disable httpd >>/root/$log_file 2>&1
        systemctl stop cobblerd && systemctl disable cobblerd >>/root/$log_file 2>&1
        systemctl stop rsyncd && systemctl disable rsyncd >>/root/$log_file 2>&1
        systemctl stop xinetd && systemctl disable xinetd >>/root/$log_file 2>&1
        yum -y remove cobbler cobbler-web pykickstart httpd dhcp tftp xinetd debmirror cman fence-agents >>/root/$log_file 2>&1
        mv /var/www $trash >>/root/$log_file 2>&1
        # mv /etc/xinetd.d/tftp $trash >>/root/$log_file 2>&1
        umount /mnt/ >>/root/$log_file 2>&1
        log_correct "########################################################卸载Cobbler成功#####################################################"
        show_str_Green "========================================"
        show_str_Green "            Cobbler卸载完成。。。"
        show_str_Green "========================================"
}

check_cobbler() {
        if [ $(ps -ef | grep httpd | grep -v grep | wc -l) -eq 0 ] && [ $(ps -ef | grep cobblerd | grep -v grep | wc -l) -eq 0 ] && [ $(ps -ef | grep rsync | grep -v grep | wc -l) -eq 0 ] && [ $(ps -ef | grep xinetd | grep -v grep | wc -l) -eq 0 ]; then
                show_str_Green "-------------------------------------------"
                show_str_Green "|                提醒！！！                |"
                show_str_Green "|       检测当前服务器未安装Cobbler        |"
                show_str_Green "-------------------------------------------"
                log_correct "检测当前服务器未安装Cobbler"
        else
                show_str_Red "-------------------------------------------------------------"
                show_str_Red "|                        警告！！！                          |"
                show_str_Red "|    Cobbler has running already exists! please check!       |"
                show_str_Red "-------------------------------------------------------------"
                log_error "Cobbler has running already exists! please check! "
        fi

}

check_conf() {
        check_file=/root/check_file_$(date +"%Y-%m-%d-%H%M%S")
        touch $check_file
        cobbler check >>$check_file 2>&1
        grep '^server' /etc/cobbler/settings >>$check_file 2>&1
        grep '^next_server' /etc/cobbler/settings >>$check_file 2>&1
        grep '^pxe_just_once' /etc/cobbler/settings >>$check_file 2>&1
        grep 'disable' /etc/xinetd.d/tftp >>$check_file 2>&1
        grep '^default_password_crypted' /etc/cobbler/settings >>$check_file 2>&1
        grep '@dists' /etc/debmirror.conf >>$check_file 2>&1
        grep '@arches' /etc/debmirror.conf >>$check_file 2>&1
        grep '^manage_dhcp' /etc/cobbler/settings >>$check_file 2>&1
        sed -n '21,28p' /etc/cobbler/dhcp.template >>$check_file 2>&1
        cat /etc/dhcp/dhcpd.conf >>$check_file 2>&1
        # df -Th
        # ll /var/www/cobbler/ks_mirror/
        # ll /var/www/cobbler/ks_mirror/CentOS-7.9-x86_64/
        cobbler distro list >>$check_file 2>&1
        cobbler profile list >>$check_file 2>&1
        show_str_Purple "========================================"
        show_str_Purple "     检查配置文件输出至：$check_file"
        show_str_Purple "========================================"
}

function printinput() {
        echo "========================================"
        cat <<EOF
|-------------系-统-信-息--------------
|  时间            :$DATE                                        
|  主机名称        :$HOSTNAME
|  当前用户        :$USER                                        
|  内核版本        :$KERNEL
|  系统版本        :$SYSTEM  
----------------------------------------
----------------------------------------
|****请选择你要操作的项目:[0-3]****|
----------------------------------------
(1) 检查当前环境
(2) 安装Cobbler
(3) 检查配置文件（运维专用）
(4) 配置自动化安装Centos7.9
(5) 卸载Cobbler
(0) 退出
EOF

        read -p "请选择[0-5]: " input
        case $input in
        1)
                check_cobbler
                printinput
                ;;
        2)
                # close_software
                install_software
                configure
                start_software
                printinput
                ;;
        3)
                check_conf
                printinput
                ;;
        4)
                cobbler_config
                printinput
                ;;
        5)
                uninstall_cobbler
                printinput
                ;;
        0)
                clear
                exit 0
                ;;
        *)
                show_str_Red "----------------------------------"
                show_str_Red "|            警告！！！            |"
                show_str_Red "|    请 输 入 正 确 的 选 项       |"
                show_str_Red "----------------------------------"
                for i in $(seq -w 3 -1 1); do
                        echo -ne "\b\b$i"
                        sleep 1
                done
                printinput
                ;;
        esac
}

printinput
