# Cobbler

[TOC]



## <u>文档标识</u>

| 文档名称 | cobbler  |
| -------- | -------- |
| 版本号   | <V1.0.0> |

## <u>文档修订历史</u>

| 版本   | 日期       | 描述   | 文档所有者 |
| ------ | ---------- | ------ | ---------- |
| V1.0.0 | 2022.11.23 | create | 杨丝雨     |
|        |            |        |            |
|        |            |        |            |

## <u>相关目录</u>

| 路径                          | 描述                        | remarks |
| ----------------------------- | --------------------------- | ------- |
| /var/www/cobbler/ks_mirror/   | 镜像存放目录                |         |
| /var/www/cobbler/repo_mirror/ | 存放仓库镜像                |         |
| /var/lib/cobbler/kickstarts/  | kickstarts配置文件存放路径  |         |
| /var/lib/cobbler/loaders/     | 存放启动引导程序的目录      |         |
| /var/lib/cobbler/snippets/    | cobbler安装系统相关配置脚本 |         |
| /etc/cobbler/                 | cobbler配置文件存放目录     |         |
| /etc/cobbler/settings/        | cobbler主配置文件           |         |



## <u>相关文档参考</u>

[Cobbler官网]: https://www.cobblerd.org/
[Kickstart]: https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Installation_Guide/index.html
[PXE]: https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Installation_Guide/index.html
[Kickstart脚本文件]: https://github.com/CentOS/Community-Kickstarts



## Cobbler简介

`Cobbler` 可以用来快速建立 `Linux` 网络安装环境，它已将`Linux`网络安装的技术门槛，从大专以上文化水平，成功降低到了初中水平，连补鞋匠都能学会。
网络安装服务器套件`Cobbler`（补鞋匠）从前，我们一直在装机民工这份很有前途的职业。自打若干年前`Red Hat`推出了 `Kickstart`，此后我们顿觉身价增倍。不再需要刻了光盘一台一台的安装`Linux`，只要搞定`PXE`、`DHCP`、`TFTP`，还有那满屏眼花缭乱不知所云的`Kickstart`脚本，我们就可以像哈利波特一样，轻点魔棒，瞬间安装上百台服务器。这一堆花里胡哨的东西可不是一般人能够整明白的，没有大专以上的学历，通不过英语四级，根本别想玩转。总而言之，这是一份多么有前途，多么有技术含量的工作啊。很不幸，`Red Ha`t 最新（`Cobbler`项目最初在`2008`年左右发布）发布了网络安装服务器套件`Cobbler`（补鞋匠），它已将`Linux`网络安装的技术门槛，从大专以上文化水平，成功降低到初中以下水平，连补鞋匠都能学会。

1、`Cobbler`是一个`Linux`服务器安装的服务，可以通过网络启动（`PXE`）的方式来快速安装、重装物理服务器和虚拟机，同时还可以管理`DHCP`，`DNS`等。
2、`Cobbler`可以使用命令行方式管理，也提供了基于Web的界面管理工具（`cobbler-web`），还提供了`API`接口，可以方便二次开发使用。
3、`Cobbler`是较早前的`kickstart`的升级版，优点是比较容易配置，还自带web界面比较易于管理。
4、`Cobbler`内置了一个轻量级配置管理系统，但它也支持和其它配置管理系统集成，如`Puppet`。

## Cobbler功能

使用Cobbler，您无需进行人工干预即可安装机器。Cobbler 设置一个 PXE 引导环境（它还可使用 yaboot 支持 PowerPC），并控制与安装相关的所有方面，比如网络引导服务（DHCP 和 TFTP）与存储库镜像。当希望安装一台新机器时，Cobbler 可以：使用一个以前定义的模板来配置 DHCP 服务（如果启用了管理 DHCP）将一个存储库（yum或 rsync）建立镜像或解压缩一个媒介，以注册一个新操作系统，在 DHCP 配置文件中为需要安装的机器创建一个条目，并使用您指定的参数（IP 和 MAC 地址）在 TFTFP 服务目录下创建适当的 PXE 文件重新启动 DHCP服务以反映更改，重新启动机器以开始安装（如果电源管理已启用）

  Cobbler 支持众多的发行版：RedHat、Fedora、CentOS、Debian、Ubuntu 和 SuSE。当添加一个操作系统（通常通过使用 ISO 文件）时，Cobbler 知道如何解压缩合适的文件并调整网络服务，以正确引导机器。

  Cobbler 可使用kickstart 模板。基于 Red
Hat 或 Fedora 的系统使用 kickstart 文件来自动化安装流程。通过使用模板，您就会拥有基本的kickstart 模板，然后定义如何针对一种配置文件或机器配置而替换其中的变量。例如，一个模板可能包含两个变量 $domain和$machine_name。在 Cobbler 配置中，一个配置文件指定domain=mydomain.com，并且每台使用该配置文件的机器在machine_name变量中指定其名称。该配置文件中的所有机器都使用相同的 kickstart 安装且针对domain=mydomain.com 进行配置，但每台机器拥有其自己的机器名称。您仍然可以使用 kickstart 模板在不同的域中安装其他机器并使用不同的机器名称。为了协助管理系统，Cobbler可通过 fence scripts 连接到各种电源管理环境。Cobbler 支持 apc_snmp、bladecenter、bullpap、drac、ether_wake、ilo、integrity、ipmilan、ipmitool、lpar、rsa、virsh 和 wti。要重新安装一台机器，可运行 reboot system foo命令，而且 Cobbler 会使用必要的凭据和信息来为您运行恰当的 fence scripts（比如机器插槽数）。

  除了这些特性，还可使用一个配置管理系统 (CMS)。您有两种选择：该工具内的一个内部系统，或者集成一个现有的外部 CMS，比如 Chef 或Puppet。借助内部系统，您可以指定文件模板，这些模板会依据配置参数进行处理（与 kickstart 模板的处理方式一样），然后复制到您指定的位置。如果必须自动将配置文件部署到特定机器，那么此功能很有用。使用 koan 客户端，Cobbler 可从客户端配置虚拟机并重新安装系统。我不会讨论配置管理和koan 特性，因为它们不属于本文的介绍范畴。但是，它们是值得研究的有用特性

## Cobbler对应关系

![img](https://img2018.cnblogs.com/blog/1210730/201906/1210730-20190613151804685-1462836028.png)

`Cobbler`的配置结构基于一组注册的对象。每个对象表示一个与另一个实体相关联的实体。当一个对象指向另一个对象时，它就继承了被指向对象的数据，并可覆盖或添加更多特定信息。

- 发行版(`distros`)： 表示一个操作系统。它承载了内核和`initrd`的信息，以及内核参数等其他数据。
- 配置文件(`profiles`)：包含一个发行版、一个`kickstart`文件以及可能的存储库，还包括更多特定的内核参数等其他数据。
- 系统(`systems`)：表示要配给的机器。它包括一个配置文件或一个镜像、`IP`和`MAC`地址、电源管理（地址、凭据、类型）以及更为专业的数据等信息。
- 镜像(`images`)：可以替换一个保函不屑于此类别的文件的发行版对象（例如，无法分为内核和`initrd`的对象）。

## Cobbler集成的服务

- PXE服务支持
- DHCP服务管理
- DNS服务管理
- 电源管理
- Kickstart服务支持
- YUM仓库管理
- TFTP
- Apache

## Cobbler工作原理

![img](https://img2018.cnblogs.com/blog/1210730/201906/1210730-20190613151918261-1219085722.png)

**Server端**

- 启动`Cobbler`服务
- 进行`Cobbler`错误检查，执行`cobbler check`命令
- 进行配置同步，执行`cobbler sync`命令
- 复制相关启动文件到`TFTP`目录中
- 启动`DHCP`服务，提供地址分配
- `DHCP`服务分配IP地址
- `TFTP`传输启动文件
- `Server`端接收安装信息
- `Server`端发送`ISO`镜像与`Kickstart`文件

**Client端**

- 客户端以`PXE`模式启动
- 客户端获取`IP`地址
- 通过`TFTP`服务器获取启动文件
- 进入`Cobbler`安装选择界面
- 根据配置信息准备安装系统
- 加载`Kickstart`文件
- 传输系统安装的其它文件
- 进行安装系统

## Cobbler组件关系

![wKiom1Nw3UnBVNxHAAJgNktBY9o030.jpg](http://s3.51cto.com/wyfs02/M02/77/D7/wKiom1ZviFPQWVwzAAJgNktBY9o812.jpg)

## Cobbler相关配置文件

```shell
/etc/cobbler		#<== 配置文件目录
/etc/cobbler/settings	#<== cobbler主配置文件，这个文件是YAML格式，Cobbler是python写的程序。
/etc/cobbler/dhcp.template	#<== DHCP服务的配置模板
/etc/cobbler/tftpd.template	#<== tftp服务的配置模板
/etc/cobbler/rsync.template	#<== rsync服务的配置模板
/etc/cobbler/iso		#<== iso模板配置文件目录
/etc/cobbler/pxe		#<== pxe模板文件目录
/etc/cobbler/power		#<== 电源的配置文件目录
/etc/cobbler/users.conf 	#<== Web服务授权配置文件
/etc/cobbler/users.digest	#<== 用于web访问的用户名密码配置文件
/etc/cobbler/dnsmasq.template 	#<== DNS服务的配置模板
/etc/cobbler/modules.conf	#<== Cobbler模块配置文件
/var/lib/cobbler		#<== Cobbler数据目录
/var/lib/cobbler/config 	#<== 配置文件
/var/lib/cobbler/kickstarts   	#<== 默认存放kickstart文件
/var/lib/cobbler/loaders      	#<== 存放的各种引导程序
/var/www/cobbler		#<== 系统安装镜像目录
/var/www/cobbler/ks_mirror	#<== 导入的系统镜像列表
/var/www/cobbler/images		#<== 导入的系统镜像启动文件
/var/www/cobbler/repo_mirror	#<== yum源存储目录
/var/log/cobbler 		#<==日志目录
/var/log/cobbler/install.log	#<== 客户端系统安装日志
/var/log/cobbler/cobbler.log  	#<== cobbler日志
```

## Cobbler相关命令

| 命令             | 说明                                       |
| ---------------- | ------------------------------------------ |
| cobbler check    | 核对当前设置是否有问题                     |
| cobbler list     | 列出所有的cobbler元素                      |
| cobbler report   | 列出元素的详细信息                         |
| cobbler sync     | 同步配置到数据目录，更改配置最好都执行一下 |
| cobbler reposync | 同步yum仓库                                |
| cobbler distro   | 查看导入的发行版系统信息                   |
| cobbler system   | 查看添加的系统信息                         |
| cobbler profile  | 查看配置信息                               |

## Cobbler安装

1、配置epel源

```shell
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
```

2、安装cobbler相关包

```
yum -y install cobbler cobbler-web pykickstart httpd dhcp tftp xinetd #<== 一共7个包
```

### 配置文件修改

1、修改配置文件前需要先备份配置文件

```shell
cp /etc/cobbler/settings{,_`date +%F`.bak}   #<== 备份
ll /etc/cobbler/settings*         #<== 检查是否备份成功
-rw-r----- 1 root apache 19988 11月 25 18:23 /etc/cobbler/settings
-rw-r----- 1 root root   19918 11月 25 18:14 /etc/cobbler/settings_2022-11-25.bak
```

2、根据第一个提示，修改/etc/cobbler/settings配置文件的cobbler服务器IP

```shell
grep '^server' /etc/cobbler/settings  #<== 输出检查
sed -i 's#server: 127.0.0.1#server: 192.168.31.54#g' /etc/cobbler/settings  #<== 替换修改
```

3、根据第2个提示还需要修改文件中的next_server参数的值为提供PXE服务的主机相应的IP地址，如next_server: 192.168.56.11；

```shell
grep '^next_server' /etc/cobbler/settings                 
sed -i 's#next_server: 127.0.0.1#next_server: 192.168.3.54#g' /etc/cobbler/settings
```

4、这里还需要修改一个参数，防止循环装系统

```shell
# 快速修改如下：
grep '^pxe_just_once' /etc/cobbler/settings                 
sed -i 's# pxe_just_once: 0# pxe_just_once: 1#g' /etc/cobbler/settings
```

5、根据第3个提示修改/etc/xinetd.d/tftp文件配置

```shell
sed -i '14s/yes/no/' /etc/xinetd.d/tftp >>/root/$log_file 2>&1
# default: off
# description: The tftp server serves files using the trivial file transfer \
#       protocol.  The tftp protocol is often used to boot diskless \
#       workstations, download configuration files to network-aware printers, \
#       and to start the installation process for some operating systems.
service tftp
{
        socket_type             = dgram
        protocol                = udp
        wait                    = yes
        user                    = root
        server                  = /usr/sbin/in.tftpd
        server_args             = -s /var/lib/tftpboot
        disable                 = no      #<== 将这里的yes改为no
        per_source              = 11
        cps                     = 100 2
        flags                   = IPv4
}
```

6、继续根据提示为cobbler设置密码

```shell
openssl passwd -1 -salt '$(openssl rand -hex 4)' '123456'  #<== 生成密码
$1$$(openss$WY5YH1ywIESp6xA/dotYu/
```

> 说明：在生成密码命令中第一个单引号中是随机字符串，$(openssl rand -hex 4)是生成随机字符串，当然自己随便写也可以。在第二个单引号里面是是我们要设置的密码，这里设置为123456

```sh
sed -i 's/^default_password_crypted: "$1$mF86\/UHC$WvcIcX2t6crBz2onWxyac."/default_password_crypted: "$1$$(openss$WY5YH1ywIESp6xA\/dotYu\/"/g' /etc/cobbler/settings  #<== 修改配置文件中密码
default_password_crypted: "$1$$(openss$WY5YH1ywIESp6xA/dotYu/"
```

7、配置DHCP服务

```js
sed -i 's/manage_dhcp: 0/manage_dhcp: 1/g' /etc/cobbler/settings
manage_dhcp: 1		#<== 将这里的0改为1，表示cobbler管理dhcp
```

修改dhcp模板文件

```shell
vim /etc/cobbler/dhcp.template #<== 以下修改黄色部分配置即可
........
   ..........
subnet 192.168.3.0 netmask 255.255.255.0 {	#<== 网段
   option routers             	192.168.3.2;	#<== 网关
   option domain-name-servers	114.114.114.114;	#<== DNS
   option subnet-mask         255.255.255.0;  #<== 子网掩码
   range dynamic-bootp        192.168.3.100 192.168.3.254;#<== 允许DHCP服务分配的IP
   default-lease-time         	21600;	#<== 缺省租约时间
   max-lease-time            	43200;	#<== 最大租约时间
   next-server                $next_server;	#<== 指定引导服务器（PXE服务），该变量在cobbler配置文件中，我们前面修改过
    .........
........
```

### 启动程序并同步

```shell
systemctl start httpd && systemctl enable httpd
systemctl start cobblerd && systemctl enable cobblerd
systemctl start rsyncd && systemctl enable rsyncd
systemctl start xinetd && systemctl enable xinetd
```

使用cobbler sync 生成dhcp模板，自动帮我们重启dhcp

 cobbler sync 表示刷新，其实就是删除原来的文件，从新进行加载

```shell
[root@linux ~]# systemctl restart cobblerd
[root@linux ~]# cobbler sync	#<== 同步cobbler
task started: 2022-02-21_141338_sync
task started (id=Sync, time=Tue Feb 21 14:13:38 2022)
running pre-sync triggers
cleaning trees
removing: /var/lib/tftpboot/grub/images
copying bootloaders
trying hardlink /var/lib/cobbler/loaders/pxelinux.0 -> /var/lib/tftpboot/pxelinux.0
trying hardlink /var/lib/cobbler/loaders/menu.c32 -> /var/lib/tftpboot/menu.c32
trying hardlink /var/lib/cobbler/loaders/yaboot -> /var/lib/tftpboot/yaboot
trying hardlink /usr/share/syslinux/memdisk -> /var/lib/tftpboot/memdisk
trying hardlink /var/lib/cobbler/loaders/grub-x86.efi -> /var/lib/tftpboot/grub/grub-x86.efi
trying hardlink /var/lib/cobbler/loaders/grub-x86_64.efi -> /var/lib/tftpboot/grub/grub-x86_64.efi
copying distros to tftpboot
copying images
generating PXE configuration files
generating PXE menu structure
rendering DHCP files
generating /etc/dhcp/dhcpd.conf
rendering TFTPD files
generating /etc/xinetd.d/tftp
cleaning link caches
running post-sync triggers
running python triggers from /var/lib/cobbler/triggers/sync/post/*
running python trigger cobbler.modules.sync_post_restart_services
running: dhcpd -t -q
received on stdout: 
received on stderr: 
running: service dhcpd restart
received on stdout: 
received on stderr: Redirecting to /bin/systemctl restart  dhcpd.service

running shell triggers from /var/lib/cobbler/triggers/sync/post/*
running python triggers from /var/lib/cobbler/triggers/change/*
running python trigger cobbler.modules.scm_track
running shell triggers from /var/lib/cobbler/triggers/change/*
*** TASK COMPLETE ***     #<== 同步成功
```

查看dhcp文件

```shell
cat /etc/dhcp/dhcpd.conf   #<== 再次查看该文件，多了很多dhcp配置
# ******************************************************************
# Cobbler managed dhcpd.conf file
# generated from cobbler dhcp.conf template (Tue Feb 21 19:13:39 2017)
# Do NOT make changes to /etc/dhcpd.conf. Instead, make your changes
# in /etc/cobbler/dhcp.template, as /etc/dhcpd.conf will be
# overwritten.
# ******************************************************************
#说明：上述意思是 dhcp是由cobbler进行管理，如果想进行设置 请修
#改/etc/cobbler/dhcp.template 然后/etc/dhcp/dhcpd.conf会被覆盖
........
   .............
```

### 自动部署Centos7.9系统

1、上传CentOS7镜像并挂载

这里也可以不用上传镜像，直接在虚拟机里面挂载也是可以的（本文采取直接挂载方式）

```shell
mount -o loop /dev/cdrom /mnt/
df -Th
文件系统                类型      容量  已用  可用 已用% 挂载点
devtmpfs                devtmpfs  2.0G     0  2.0G    0% /dev
tmpfs                   tmpfs     2.0G   24K  2.0G    1% /dev/shm
tmpfs                   tmpfs     2.0G   12M  2.0G    1% /run
tmpfs                   tmpfs     2.0G     0  2.0G    0% /sys/fs/cgroup
/dev/mapper/centos-root xfs        50G  4.5G   46G    9% /
/dev/mapper/centos-home xfs        47G   41M   47G    1% /home
/dev/sda1               xfs      1014M  138M  877M   14% /boot
tmpfs                   tmpfs     394M     0  394M    0% /run/user/0
/dev/loop0              iso9660   4.3G  4.3G     0  100% /mnt
```

2、指定镜像为cobbler安装源（时间有点小长）

```shell
cobbler import --path=/mnt/ --name=CentOS-7.9-x86_64 --arch=x86_64

# - -path 镜像路径
# - -name 为安装源定义一个名字
# - -arch 指定安装源是32位、64位、ia64, 目前支持的选项有: x86│x86_64│ia64
# 安装源的唯一标示就是根据name参数来定义，本例导入成功后，安装源的唯一标示就是：CentOS-7.9-x86_64
#镜像存放目录，cobbler会将镜像中的所有安装文件拷贝到本地一份，放在/var/www/cobbler/ks_mirror下 \
# 的CentOS-7.9-x86_64目录下。因此/var/www/cobbler目录必须具有足够容纳安装文件的空间。
task started: 2017-02-21_143047_import
task started (id=Media import, time=Tue Feb 21 14:30:47 2017)
............
    .............省略输出............
*** TASK COMPLETE ***

ll /var/www/cobbler/ks_mirror/
总用量 0
drwxrwxr-x 8 root root 254 11月 26 2018 CentOS-7.9-x86_64
drwxr-xr-x 2 root root  36 11月 25 18:57 config

ll /var/www/cobbler/ks_mirror/CentOS-7.9-x86_64/
总用量 324
-rw-rw-r-- 1 root root     14 11月 26 2018 CentOS_BuildTag
drwxr-xr-x 3 root root     35 11月 26 2018 EFI
-rw-rw-r-- 1 root root    227 8月  30 2017 EULA
-rw-rw-r-- 1 root root  18009 12月 10 2015 GPL
drwxr-xr-x 3 root root     57 11月 26 2018 images
drwxr-xr-x 2 root root    198 11月 26 2018 isolinux
drwxr-xr-x 2 root root     43 11月 26 2018 LiveOS
drwxrwxr-x 2 root root 229376 11月 26 2018 Packages
drwxrwxr-x 2 root root   4096 11月 26 2018 repodata
-rw-rw-r-- 1 root root   1690 12月 10 2015 RPM-GPG-KEY-CentOS-7
-rw-rw-r-- 1 root root   1690 12月 10 2015 RPM-GPG-KEY-CentOS-Testing-7
-r--r--r-- 1 root root   2883 11月 26 2018 TRANS.TBL
```

查看镜像列表如下：

```shell
cobbler distro list
   CentOS-7.9-x86_64
cobbler profile list
   CentOS-7.9-x86_64
```

3、到指定路径下编写ks文件

```shell
cd /var/lib/cobbler/kickstarts/
vim CentOS-7.9-x86_64_cobbler.cfg

# Cobbler for Kickstart Configurator for CentOS 7.9
#platform=x86, AMD64, or Intel EM64T
#version=DEVEL
# Install OS instead of upgrade
install
# Keyboard layouts
keyboard 'us'
# Root password
rootpw --plaintext centos
# Use network installation
url --url=$tree
# System language
lang en_US
# System authorization information
auth  --useshadow  --passalgo=sha512
# Use text mode install
text
firstboot --disable
# SELinux configuration
selinux --disabled

# Firewall configuration
firewall --disabled
# Network information
$SNIPPET('network_config')
# Reboot after installation
reboot
# System timezone
timezone Asia/Shanghai
# System bootloader configuration
bootloader --append="net.ifnames=0" --location=mbr
# Clear the Master Boot Record
zerombr
# Partition clearing information
clearpart --all
# Disk partitioning information
part / --fstype="xfs" --size=30000
part /boot --fstype="xfs" --size=1024
part swap --fstype="swap" --size=2048

%packages
@^minimal
@core
kexec-tools

%end

%addon com_redhat_kdump --enable --reserve-mb='auto'

%end

%anaconda
pwpolicy root --minlen=6 --minquality=1 --notstrict --nochanges --notempty
pwpolicy user --minlen=6 --minquality=1 --notstrict --nochanges --emptyok
pwpolicy luks --minlen=6 --minquality=1 --notstrict --nochanges --notempty
%end
```

4、自定义修改默认kickstarts文件路径

```shell
# 查看ks文件默认路径
cobbler profile report|grep Kickstart
cobbler profile edit --name=CentOS-7.9-x86_64 \
--kickstart=/var/lib/cobbler/kickstarts/CentOS-7.9-x86_64_cobbler.cfg
```

## Cobbler web界面的安装与配置

1、登录cobbler-web界面

在开始时已经安装了cobbler-web组件

登录网址：https://192.168.3.10/cobbler_web

默认用户名：cobbler

默认密码：cobbler

2、修改cobbler默认密码及登录cobblerweb界面

```shell
[root@linux-node1 ~]# cat /etc/cobbler/users.conf 
........
   .........
[admins]
admin = ""
cobbler = ""
```

3、以下为修改web界面密码的命令，无需重启cobbler，该命令中双引号内容是描述，任意字符串即可。

```shell
[root@linux-node1 ~]# htdigest /etc/cobbler/users.digest "mima" cobbler      

Adding user cobbler in realm mima

New password: 123123

Re-type new password: 123123
```

> **提示：**所有在命令行操作的**cobbler**，都可以在**web**界面上实现

## <u>附录：kickstart文件结构介绍</u>

 1.  命令部分：配置系统的属性及安装中的各种必要设置信息
  2.  %packages部分：设定需要安装的软件包及包组，Anaconda会自动解决依赖关系
  3.  脚本部分：用于定制系统，分为%pre部分在安装前运行，%post在安装后运行

%pre 部分脚本作为一个bash shell脚本执行，在Kickstart文件解析后执行；
%post 解析器默认为bash，可以自定义，缺省为chroot状态，也可指定非chroot状态；

-----------------------------------


## <u>附录：kickstart命令选项</u>

autopart(可选)

- 自动创建分区,大于1GB的根分区(/),交换分区和适合于不同体系结构的引导分区.一个或多个缺省分区的大小可以用part指令重新定义.

ignoredisk(可选)

- 导致安装程序忽略指定的磁盘.如果使用自动分区并希望忽略某些磁盘的话,这就很有用.
                          例如,没有ignoredisk,如要试图在SAN-cluster系统里部署,kickstart就会失败,因为安装程序检测到SAN不返回分区表的被动路径(passive path).

  如果有磁盘的多个路径时,ignoredisk选项也有用处.

- 语法：
  -  ignoredisk --drives=drive1,drive2,...
  - 这里driveN是sda,sdb... hda等等中的一个.

autostep(可选)

-  和interactive相似,除了它进入下一屏幕,它通常用于调试.
- --autoscreenshot,安装过程中的每一步都截屏并在安装完成后把图片复制到/root/anaconda-screenshots.这对于制作文档很有用.

 auth或authconfig(必需)

- 为系统设置验证选项.这和在安装后运行的authconfig命令相似.在缺省情况下,密码通常被加密但不使用影子文件(shadowed).

​            --enablemd5,每个用户口令都使用md5加密.
​            --enablenis,启用NIS支持.在缺省情况下,--enablenis使用在网络上找到的域.域应该总是用--nisdomain=选项手工设置.
​            --nisdomain=,用在NIS服务的NIS域名.
​            --nisserver=,用来提供NIS服务的服务器(默认通过广播).
​            --useshadow或--enableshadow,使用屏蔽口令.
​            --enableldap,在/etc/nsswitch.conf启用LDAP支持,允许系统从LDAP目录获取用户的信息(UIDs,主目录,shell 等等).要使用这个选项,必须安装nss_ldap软件包.也必须用--ldapserver=和--ldapbasedn=指定服务器和base DN(distinguished name).
​            --enableldapauth,把LDAP作为一个验证方法使用.这启用了用于验证和更改密码的使用LDAP目录的pam_ldap模块.要使用这个选项,必须安装nss_ldap软件包.也必须用--ldapserver=和--ldapbasedn=指定服务器和base DN.
​            --ldapserver=,如果指定了--enableldap或--enableldapauth,使用这个选项来指定所使用的LDAP服务器的名字.这个选项在/etc/ldap.conf文件里设定.
​            --ldapbasedn=,如果指定了--enableldap或--enableldapauth,使用这个选项来指定用户信息存放的LDAP目录树里的DN.这个选项在/etc/ldap.conf文件里设置.
​            --enableldaptls,使用TLS(传输层安全)查寻.该选项允许LDAP在验证前向LDAP服务器发送加密的用户名和口令.
​            --enablekrb5,使用Kerberos 5验证用户.Kerberos自己不知道主目录,UID或shell.如果启用了Kerberos,必须启用LDAP,NIS,Hesiod或者使用/usr/sbin/useradd命令来使这个工作站获知用户的帐号.如果使用这个选项,必须安装pam_krb5软件包.
​            --krb5realm=,工作站所属的Kerberos 5领域.
​            --krb5kdc=,为领域请求提供服务的KDC.如果的领域内有多个KDC,使用逗号(,)来分隔它们.
​            --krb5adminserver=,领域内还运行kadmind的KDC.该服务器处理改变口令以及其它管理请求.如果有不止一个KDC,该服务器必须是主KDC.
​            --enablehesiod,启用Hesiod支持来查找用户主目录,UID 和 shell.在网络中设置和使用 Hesiod 的更多信息,可以在 glibc 软件包里包括的 /usr/share/doc/glibc-2.x.x/README.hesiod里找到.Hesiod是使用DNS记录来存储用户,组和其他信息的 DNS 的扩展.
​            --hesiodlhs,Hesiod LHS("left-hand side")选项在/etc/hesiod.conf里设置.Hesiod 库使用这个选项来决定查找信息时搜索DNS的名字,类似于LDAP对 base DN的使用.
​            --hesiodrhs,Hesiod RHS("right-hand side")选项在/etc/hesiod.conf里设置.Hesiod 库使用这个选项来决定查找信息时搜索DNS的名字,类似于LDAP对base DN的使用.
​            --enablesmbauth,启用对SMB服务器(典型的是Samba或Windows服务器)的用户验证.SMB验证支持不知道主目录,UID 或 shell.如果启用SMB,必须通过启用LDAP,NIS,Hesiod或者用/usr/sbin/useradd命令来使用户帐号为工作站所知.要使用这个选项,必须安装pam_smb软件包.
​            --smbservers=,用来做SMB验证的服务器名称.要指定不止一个服务器,用逗号(,)来分隔它们.
​            --smbworkgroup=,SMB服务器的工作组名称.
​            --enablecache,启用nscd服务.nscd服务缓存用户,组和其他类型的信息.如果选择在网络上用NIS,LDAP或hesiod分发用户和组的信息,缓存就尤其有用.

bootloader(必需)
                指定引导装载程序怎样被安装.对于安装和升级,这个选项都是必需的.
                --append=,指定内核参数.要指定多个参数,使用空格分隔它们.
                        例如:bootloader --location=mbr --append="hdd=ide-scsi ide=nodma"
                --driveorder,指定在BIOS引导顺序中居首的驱动器.
                        例如:bootloader --driveorder=sda,hda
                --location=,指定引导记录被写入的位置.有效的值如下:mbr(缺省),partition(在包含内核的分区的第一个扇区安装引导装载程序)或none(不安装引导装载程序).
                --password=,如果使用GRUB,把GRUB引导装载程序的密码设置到这个选项指定的位置.这应该被用来限制对可以传入任意内核参数的GRUB shell的访问.
                --md5pass=,如果使用GRUB,这和--password=类似,只是密码已经被加密.

​                --upgrade,升级现存的引导装载程序配置,保留其中原有的项目.该选项仅可用于升级.

clearpart(可选)
                在创建新分区之前,从系统上删除分区.默认不会删除任何分区.
                注:如果使用了clearpart命令,--onpart命令就不能够用在逻辑分区上.
                --all,删除系统上所有分区.
                --drives=,指定从哪个驱动器上清除分区.
                        例如,下面的命令清除了主IDE控制器上的前两个驱动器上所有分区
                        clearpart --drives=hda,hdb --all
                --initlabel,根据不同体系结构把磁盘标签初始化为缺省设置(例如,msdos用于x86而gpt用于Itanium).当安装到一个崭新的硬盘时,这很有用,安装程序不会询问是否应该初始化磁盘标签.
                --linux,删除所有Linux分区.

​				--none(缺省),不要删除任何分区.

cmdline(可选)

- 

- 在完全的非交互式的命令行模式下进行安装.任何交互式的提示都会终止安装.这个模式对于有x3270控制台的IBM System z系统很有用.

device(可选)

- 在多数的PCI系统里,安装程序会正确地自动探测以太网卡和SCSI卡.然而,在老的系统和某些PCI系统里,kickstart需要提示来找到正确的设备.device命令用来告诉安装程序安装额外的模块,它有着这样的格式:

​            device <type><moduleName> --opts=<options>
​            <type>,用scsi或eth代替
​            <moduleName>,使用应该被安装的内核模块的名称来替换.
​            --opts=,传递给内核模块的选项.注意,如果把选项放在引号里,可以传递多个选项.
​                    例如:--opts="aic152x=0x340 io=11"

driverdisk(可选)

- 可以在kickstart安装过程中使用驱动软盘.必须把驱动软盘的内容复制到系统的硬盘分区的根目录下.然后必须使用driverdisk 命令来告诉安装程序到哪去寻找驱动磁盘.

​            driverdisk <partition> [--type=<fstype>]
​            另外,也可以为驱动程序盘指定一个网络位置:
​            driverdisk --source=ftp://path/to/dd.img
​            driverdisk --source=http://path/to/dd.img
​            driverdisk --source=nfs:host:/path/to/img
​                    <partition>,包含驱动程序盘的分区.
​                    --type=,文件系统类型(如:vfat,ext2,ext3)

  firewall(可选)

- 这个选项对应安装程序里的「防火墙配置」屏幕:

​		firewall --enabled|--disabled [--trust=] <device> [--port=]

​            --enabled或者--enable,拒绝不是答复输出请求如DNS答复或DHCP请求的进入连接.如果需要使用在这个机器上运行的服务,可以选择允许指定的服务穿过防火墙.
​            --disabled或--disable,不要配置任何iptables规则.
​            --trust=,在此列出设备,如eth0,这允许所有经由这个设备的数据包通过防火墙.如果需要列出多个设备,使用--trust eth0 --trust eth1.不要使用以逗号分隔的格式,如--trust eth0, eth1.
​            <incoming>,使用以下服务中的一个或多个来替换,从而允许指定的服务穿过防火墙.
​                    --ssh
​                    --telnet
​                    --smtp
​                    --http
​                    --ftp
​            --port=,可以用端口:协议(port:protocal)格式指定允许通过防火墙的端口.
​                    例如,如果想允许IMAP通过的防火墙,可以指定imap:tcp.还可以具体指定端口号码,要允许UDP分组在端口1234通过防火墙,输入1234:udp.要指定多个端口,用逗号将它们隔开.

halt(可选)

- 在成功地完成安装后关闭系统.这和手工安装相似,手工安装的anaconda会显示一条信息并等待用户按任意键来重启系统.在kickstart安装过程中,如果没有指定完成方法(completion method),将缺省使用reboot选项.
- halt选项基本和shutdown -h命令相同.
- 关于其他的完成方法,请参考kickstart的poweroff,reboot和shutdown选项.

graphical(可选)

- 在图形模式下执行kickstart安装.kickstart安装默认在图形模式下安装.

install(可选)

- 告诉系统来安装全新的系统而不是在现有系统上升级.这是缺省的模式.必须指定安装的类型,如cdrom,harddrive,nfs或url(FTP 或HTTP安装).install命令和安装方法命令必须处于不同的行上.

cdrom

- 从系统上的第一个光盘驱动器中安装.

harddrive

​            从本地驱动器的vfat或ext2格式的红帽安装树来安装.
​            --biospart=,从BIOS分区来安装(如82).
​            --partition=,从分区安装(如sdb2).
​            --dir=,包含安装树的variant目录的目录.
​                    例如:harddrive --partition=hdb2 --dir=/tmp/install-tree

nfs

- 从指定的NFS服务器安装.

​                    --server=,要从中安装的服务器(主机名或IP).
​                    --dir=,包含安装树的variant目录的目录.
​                    --opts=,用于挂载NFS输出的Mount选项(可选).
​                            例如:nfs --server=nfsserver.example.com --dir=/tmp/install-tree

 url

- 通过FTP或HTTP从远程服务器上的安装树中安装.

​		例如:url --url  http://<server>/<dir>
​        或:url --url ftp://<username>:<password>@<server>/<dir>

ignore disk(可选)

- 用来指定在分区,格式化和清除时anaconda不应该访问的磁盘.这个命令有一个必需的参数,就是用逗号隔开的需要忽略的驱动器列表.

​			例如:ignoredisk --drives=[disk1,disk2,...]

 interactive(可选)

- 在安装过程中使用kickstart文件里提供的信息,但允许检查和修改给定的值.将遇到安装程序的每个屏幕以及kickstart文件里给出的值.通过点击"下一步"接受给定的值或是改变值后点击"下一步"继续.请参考autostep命令.

iscsi(可选)

​				issci --ipaddr= [options].
​                --target
​                --port=
​                --user=
​                --password=

 iscsiname(可选)

key(可选)

- 指定安装密钥,它在软件包选择和获取支持时设别系统的时候是必需的.这个命令是红帽企业Linux-specific,它对Fedora来说没有意义并且会被忽略.
  --skip,跳过输入密钥.通常,如果没有key命令,anaconda将暂停并提示输入密钥.如果没有密钥或不想提供它,这个选项允许继续自动化安装.

keyboard(必需)

- 设置系统键盘类型.这里是 i386,Itanium,和 Alpha 机器上可用键盘的列表:

​            be-latin1, bg, br-abnt2, cf, cz-lat2, cz-us-qwertz, de, de-latin1,
​            de-latin1-nodeadkeys, dk, dk-latin1, dvorak, es, et, fi, fi-latin1,
​            fr, fr-latin0, fr-latin1, fr-pc, fr_CH, fr_CH-latin1, gr, hu, hu101,
​            is-latin1, it, it-ibm, it2, jp106, la-latin1, mk-utf, no, no-latin1,
​            pl, pt-latin1, ro_win, ru, ru-cp1251, ru-ms, ru1, ru2,  ru_win, 
​            se-latin1, sg, sg-latin1, sk-qwerty, slovene, speakup,  speakup-lt,
​            sv-latin1, sg, sg-latin1, sk-querty, slovene, trq, ua,  uk, us, us-acentos

- 文件/usr/lib/python2.2/site-packages/rhpl/keyboard_models.py 也包含这个列表而且是 rhpl 软件包的一部分.

lang(必需)

- 设置在安装过程中使用的语言以及系统的缺省语言.例如,要把语言设置为英语,kickstart文件应该包含下面的一行:

  lang en_US

- 文件/usr/share/system-config-language/locale-list里每一行的第一个字段提供了一个有效语言代码的列表,它是system-config-language软件包的一部分.

- 文本模式的安装过程不支持某些语言(主要是中文,日语,韩文和印度的语言).如果用lang命令指定这些语言中的一种,安装过程仍然会使用英语,但是系统会缺省使用指定的语言.

langsupport(不赞成)

- langsupport关键字已经被取消而且使用它将导致屏幕出现错误信息及终止安装.作为代替,应该在kickstart文件里的%packages 部分列出所支持的语言的支持软件包组.例如,要支持法语,应该把下面的语句加入到

​            %packages:
​            @french-support

logvol(可选)

- 使用以下语法来为逻辑卷管理(LVM)创建逻辑卷:

​            logvol <mntpoint> --vgname=<name> --size=<size> --name=<name><options>
​            这些选项如下所示:
​            --noformat,使用一个现存的逻辑卷,不进行格式化.
​            --useexisting,使用一个现存的逻辑卷,重新格式化它.
​            --fstype=,为逻辑卷设置文件系统类型.合法值有:ext2,ext3,swap和vfat.
​            --fsoptions=,为逻辑卷设置文件系统类型.合法值有:ext2,ext3,swap和vfat.
​            --bytes-per-inode=,指定在逻辑卷上创建的文件系统的节点的大小.因为并不是所有的文件系统都支持这个选项,所以在其他情况下它都被忽略.
​            --grow=,告诉逻辑卷使用所有可用空间(若有),或使用设置的最大值.
​            --maxsize=,当逻辑卷被设置为可扩充时,以MB为单位的分区最大值.在这里指定一个整数值,不要在数字后加MB.
​            --recommended=,自动决定逻辑卷的大小.
​            --percent=,用卷组里可用空间的百分比来指定逻辑卷的大小.
​            首先创建分区,然后创建逻辑卷组,再创建逻辑卷.
​                    例如:
​                    part pv.01 --size 3000 
​                    volgroup myvg pv.01
​                    logvol / --vgname=myvg --size=2000 --name=rootvol

logging(可选)

- 这个命令控制安装过程中anaconda的错误日志.它对安装好的系统没有影响.

​            --host=,发送日志信息到给定的远程主机,这个主机必须运行配置为可接受远程日志的syslogd进程.
​     --port=,如果远程的syslogd进程没有使用缺省端口,这个选项必须被指定.
​            --level=,debug,info,warning,error或critical中的一个.
​            指定tty3上显示的信息的最小级别.然而,无论这个级别怎么设置,所有的信息仍将发送到日志文件.

​    mediacheck(可选)
​            如果指定的话,anaconda将在安装介质上运行mediacheck.这个命令只适用于交互式的安装,所以缺省是禁用的.

​    monitor(可选)
​            如果monitor命令没有指定,anaconda将使用X来自动检测的显示器设置.请在手工配置显示器之前尝试这个命令.
​            --hsync=,指定显示器的水平频率.
​            --vsync=,指定显示器的垂直频率.
​            --monitor=,使用指定的显示器；显示器的名字应该在hwdata软件包里的/usr/share/hwdata/MonitorsDB列表上.这个显示器的列表也可以在Kickstart Configurator的X配置屏幕上找到.如果提供了--hsync或--vsync,它将被忽略.如果没有提供显示器信息,安装程序将自动探测显示器.
​            --noprobe=,不要试图探测显示器.

mouse(已取消)

- mouse 关键字已经被取消,使用它将导致屏幕出现错误信息并终止安装.

network(可选)

- 为系统配置网络信息.如果 kickstart安装不要求联网(换句话说,不从NFS,HTTP或FTP安装),就不需要为系统配置网络.如果安装要求联网而kickstart文件里没有提供网络信息,安装程序会假定从eth0通过动态IP地址(BOOTP/DHCP)来安装,并配置安装完的系统动态决定IP地址.network选项为通过网络的kickstart安装以及所安装的系统配置联网信息.

​            --bootproto=,dhcp,bootp或static中的一种,缺省值是dhcp.bootp和dhcp被认为是相同的.
​                    static方法要求在kickstart文件里输入所有的网络信息.顾名思义,这些信息是静态的且在安装过程中和安装后所有.静态网络的设置行更为复杂,因为必须包括所有的网络配置信息.必须指定IP地址,网络,网关和命名服务器.
​                    例如("\"表示连续的行):
​                    network --bootproto=static --ip=10.0.2.15 --netmask=255.255.255.0 \
​                    --gateway=10.0.2.254 --nameserver=10.0.2.1
​                    如果使用静态方法,请注意以下两个限制:
​                            所有静态联网配置信息都必须在一行上指定,不能使用反斜线来换行.
​                            在这里只能够指定一个命名服务器.然而,如果需要的话,可以使用kickstart文件的%post段落来添加更多的命名服务器.
​            --device=,用来选择用于安装的特定的以太设备.注意,除非kickstart文件是一个本地文件(如ks=floppy),否则--device=的使用是无效的.这是因为安装程序会配置网络来寻找kickstart文件.
​                    例如: network --bootproto=dhcp --device=eth0
​            --ip=,要安装的机器的IP地址.
​            --gateway=,IP地址格式的默认网关.
​            --nameserver=,主名称服务器,IP地址格式.
​            --nodns,不要配置任何 DNS 服务器.
​            --netmask=,安装的系统的子网掩码.
​            --hostname=,安装的系统的主机名.
​            --ethtool=,指定传给ethtool程序的网络设备的其他底层设置.
​            --essid=,无线网络的网络ID.
​            --wepkey=,无线网络的加密密钥.
​            --onboot=,是否在引导时启用该设备.
​            --class=,DHCP类型.
​            --mtu=,该设备的MTU.
​            --noipv4=,禁用此设备的IPv4.
​            --noipv6=,禁用此设备的IPv6.

multipath(可选)

- multipath --name= --device= --rule=

part或partition(对于安装是必需的,升级可忽略).

- 在系统上创建分区.

- 如果不同分区里有多个红帽企业Linux系统,安装程序会提示用户升级哪个系统.

- 警告:作为安装过程的一部分,所有被创建的分区都会被格式化,除非使用了--noformat和--onpart.

​            在系统上创建分区.
​            如果不同分区里有多个红帽企业Linux系统,安装程序会提示用户升级哪个系统.
​            警告:作为安装过程的一部分,所有被创建的分区都会被格式化,除非使用了--noformat和--onpart.
​            <mntpoint>,<mntpoint>是分区的挂载点,它必须是下列形式中的一种:
​                    /<path>,例如,/,/usr,/home
​                    swap,该分区被用作交换空间,要自动决定交换分区的大小,使用--recommended选项.
​                            swap --recommended
​                            自动生成的交换分区的最小值大于系统内存的数量,但小于系统内存的两倍.
​                    raid.<id>,该分区用于 software RAID(参考 raid).
​                    pv.<id>,该分区用于 LVM(参考 logvol).
​            --size=,以MB为单位的分区最小值.在此处指定一个整数值,如500.不要在数字后面加MB.
​            --grow,告诉分区使用所有可用空间(若有),或使用设置的最大值.
​            --maxsize=,当分区被设置为可扩充时,以MB为单位的分区最大值.在这里指定一个整数值,不要在数字后加MB.
​            --noformat,用--onpart命令来告诉安装程序不要格式化分区.
​            --onpart=或--usepart=,把分区放在已存在的设备上.
​                    例如:partition /home --onpart=hda1,把/home置于必须已经存在的/dev/hda1上.
​            --ondisk=或--ondrive=,强迫分区在指定磁盘上创建.
​                    例如:--ondisk=sdb把分区置于系统的第二个SCSI磁盘上.
​            --asprimary,强迫把分区分配为主分区,否则提示分区失败.
​            --type=(用fstype代替),这个选项不再可用了.应该使用fstype.
​            --fstype=,为分区设置文件系统类型.有效的类型为ext2,ext3,swap和vfat.
​            --start=,指定分区的起始柱面,它要求用--ondisk=或ondrive=指定驱动器.它也要求用--end=指定结束柱面或用--size=指定分区大小.
​            --end=,指定分区的结束柱面.它要求用--start=指定起始柱面.
​            --bytes-per-inode=,指定此分区上创建的文件系统的节点大小.不是所有的文件系统都支持这个选项,所以在其他情况下它都被忽略.
​            --recommended,自动决定分区的大小.
​            --onbiosdisk,强迫在 BIOS 找到的特定磁盘上创建分区.
​            注:如果因为某种原因分区失败了,虚拟终端3上会显示诊断信息.

poweroff(可选)

- 在安装成功后关闭系统并断电.通常,在手工安装过程中,anaconda会显示一条信息并等待用户按任意键来重新启动系统.在kickstart的安装过程中,如果没有指定完成方法,将使用缺省的reboot选项.

raid(可选)

- 组成软件RAID设备.该命令的格式是:

  raid <mntpoint> --level=<level> --device=<mddevice><partitions*>

​            <mntpoint>,RAID文件系统被挂载的位置.如果是/,除非已经有引导分区存在(/boot),RAID级别必须是1.如果已经有引导分区,/boot分区必须是级别1且根分区(/)可以是任何可用的类型.<partitions*>(这表示可以有多个分区)列出了加入到RAID阵列的RAID标识符.
​            --level=,要使用的RAID级别(0,1,或5).
​            --device=,要使用的RAID设备的名称(如md0或md1).RAID设备的范围从md0直到md7,每个设备只能被使用一次.
​            --bytes-per-inode=,指定RAID设备上创建的文件系统的节点大小.不是所有的文件系统都支持这个选项,所以对于那些文件系统它都会被忽略.
​            --spares=,指定RAID阵列应该被指派N个备用驱动器.备用驱动器可以被用来在驱动器失败时重建阵列.
​            --fstype=,为RAID阵列设置文件系统类型.合法值有:ext2,ext3,swap和vfat.
​            --fsoptions=,指定当挂载文件系统时使用的free form字符串.这个字符串将被复制到系统的/etc/fstab文件里且应该用引号括起来.
​            --noformat,使用现存的RAID设备,不要格式化RAID阵列.
​            --useexisting,使用现存的RAID设备,重新格式化它.

reboot(可选)

- 在成功完成安装(没有参数)后重新启动.通常,kickstart会显示信息并等待用户按任意键来重新启动系统.

repo(可选)

​            配置用于软件包安装来源的额外的yum库.可以指定多个repo行.
​            repo --name=<repoid> [--baseline=<url>| --mirrorlist=<url>]
​            --name=,repo id.这个选项是必需的.
​            --baseurl=,库的URL.这里不支持yum repo配置文件里使用的变量.可以使用它或者--mirrorlist,亦或两者都不使用.
​            --mirrorlist=,指向库镜像的列表的URL.这里不支持yum repo配置文件里可能使用的变量.可以使用它或者--baseurl,亦或两者都不使用.

rootpw(必需)

​            把系统的根口令设置为<password>参数.
​            rootpw [--iscrypted] <password>
​            --iscrypted,如果该选项存在,口令就会假定已被加密.

selinux(可选)

​            在系统里设置SELinux状态.在anaconda里,SELinux缺省为enforcing.
​            selinux [--disabled|--enforcing|--permissive]
​            --enforcing,启用SELinux,实施缺省的targeted policy.
​                    注:如果kickstart文件里没有selinux选项,SELinux将被启用并缺省设置为--enforcing.
​            --permissive,输出基于SELinux策略的警告,但实际上不执行这个策略.
​            --disabled,在系统里完全地禁用 SELinux.

services(可选)

​            修改运行在缺省运行级别下的缺省的服务集.在disabled列表里列出的服务将在enabled列表里的服务启用之前被禁用.
​            --disabled,禁用用逗号隔开的列表里的服务.
​            --enabled,启用用逗号隔开的列表里的服务.

shutdown(可选)

- 在成功完成安装后关闭系统.在kickstart安装过程中,如果没有指定完成方法,将使用缺省的reboot选项.

skipx(可选)

- 如果存在,安装的系统上就不会配置X.

text(可选)

- 在文本模式下执行kickstart安装. kickstart安装默认在图形模式下安装.

timezone(可选)

- 把系统时区设置为<timezone>,它可以是timeconfig列出的任何时区.

​            timezone [--utc] <timezone>
​            --utc,如果存在,系统就会假定硬件时钟被设置为UTC(格林威治标准)时间.

upgrade(可选)

- 告诉系统升级现有的系统而不是安装一个全新的系统.必须指定 cdrom,harddrive,nfs或url(对于FTP和HTTP而言)中的一个作为安装树的位置.详情请参考 install.

user(可选)

​            在系统上创建新用户.
​            user --name=<username> [--groups=<list>] [--homedir=<homedir>] [--password=<password>] [--iscrypted] [--shell=<shell>] [--uid=<uid>]
​            --name=,提供用户的名字.这个选项是必需的.
​            --groups=,除了缺省的组以外,用户应该属于的用逗号隔开的组的列表.
​            --homedir=,用户的主目录.如果没有指定,缺省为/home/<username>.
​            --password=,新用户的密码.如果没有指定,这个帐号将缺省被锁住.
​            --iscrypted=,所提供的密码是否已经加密？
​            --shell=,用户的登录shell.如果不提供,缺省为系统的缺省设置.
​            --uid=,用户的UID.如果未提供,缺省为下一个可用的非系统 UID.

vnc(可选)

​            允许通过VNC远程地查看图形化的安装.文本模式的安装通常更喜欢使用这个方法,因为在文本模式下有某些大小和语言的限制.如果为no,这个命令将启动不需要密码的VNC服务器并打印出需要用来连接远程机器的命令.
​            vnc [--host=<hostname>] [--port=<port>] [--password=<password>]
​            --host=,不启动VNC服务器,而是连接至给定主机上的VNC viewer进程.
​            --port=,提供远程VNC viewer进程侦听的端口.如果不提供,anaconda将使用VNC的缺省端口.
​            --password=,设置连接VNC会话必需的密码.这是可选的,但却是我们所推荐的选项.

volgroup(可选)

​            用来创建逻辑卷管理(LVM)组,其语法格式为:
​            volgroup <name><partition><options>
​            这些选项如下所示:
​            --noformat,使用一个现存的卷组,不要格式化它.
​            --useexisting,使用一个现存的卷组,重新格式化它.
​            --pesize=,设置物理分区(physical extent)的大小.
​            首先创建分区,然后创建逻辑卷组,再创建逻辑卷.

xconfig(可选)

​            配置X Window 系统.如果没有指定这个选项且安装了X,用户必须在安装过程中手工配置X；如果最终系统里没有安装X,这个选项不应该被使用.
​            --driver,指定用于视频硬件的 X 驱动.
​            --videoram=,指定显卡的显存数量.
​            --defaultdesktop=,指定GNOME或KDE作为缺省的桌面(假设已经通过%packages安装了GNOME或KDE桌面环境).
​            --startxonboot,在安装的系统上使用图形化登录.
​            --resolution=,指定安装的系统上X窗口系统的默认分辨率.有效值有:640x480,800x600,1024x768,1152x864, 1280x1024,1400x1050,1600x1200.请确定指定与视频卡和显示器兼容的分辨率.
​            --depth=,指定安装的系统上的 X 窗口系统的默认色彩深度.有效值有:8,16,24,和 32.请确定指定与视频卡和显示器兼容的色彩深度.

zerombr(可选)

​            如果指定了zerombr且yes是它的唯一参数,任何磁盘上的无效分区表都将被初始化.这会毁坏有无效分区表的磁盘上的所有内容.这个命令的格式应该如下:
​            zerombr yes
​            其它格式均无效.

zfcp(可选)

​                zfcp [--devnum=<devnum>] [--fcplun=<fcplun>] [--scsiid=<scsiid>] [--scsilun=<scsilun>] [--wwpn=<wwpn>]

%include

- 使用 %include/path/to/file命令可以把其他文件的内容包含在kickstart文件里,就好像这些内容出现在kickstart文件的%include命令后一样.

## <u>附录：kickstart的软件包选择</u>

在kickstart文件里使用%packages命令来列出想安装的软件包(仅用于全新安装,升级安装时不支持软件包指令).
        可以指定单独的软件包名或是组,以及使用星号通配符.安装程序可以定义包含相 关软件包的组.关于组的列表,请参考第一张红帽企业 Linux光盘里的 variant/repodata/comps-*.xml. 每个组都有一个编号,用户可见性的值,名字,描述和软件包列表.在软件包列表里,如果这个组被选择的话,组里的标记为"mandatory"的软件包就必须被安装；标记为"default"的软件包缺省被选择；而标记为"optional"的软件包必须被明确地选定才会被安装.
        多数情况下,只需要列出想安装的组而不是单个的软件包.注意Core和Base组总是缺省被选择,所以并不需要在%packages部分指定它们.
        这里是一个 %packages 选择的示例:
        %packages 
        @ X Window System 
        @ GNOME Desktop Environment 
        @ Graphical Internet 
        @ Sound and Video dhcp
        如所看到的,组被指定了,每个占用一行,用@符号开头,后面是comps.xml文件里给出的组全名.组也可以用组的id指定,如gnome-desktop.不需要额外字符就可以指定单独的软件包(上例里的dhcp行就是一个单独的软件包).
        %packages 指令也支持下面的选项:
                --nobase,不要安装@Base 组.如果想创建一个很小的系统,可以使用这个选项.
                --resolvedeps,选项已经被取消了.目前依赖关系可以自动地被解析.
                --ignoredeps,选项已经被取消了.目前依赖关系可以自动地被解析.
                --ignoremissing,忽略缺少的软件包或软件包组,而不是暂停安装来向用户询问是中止还是继续安装.  例如:%packages --ignoremissing

