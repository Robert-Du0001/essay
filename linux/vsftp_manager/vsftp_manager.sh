comm1=add
comm2=rm
comm3=help
comm4=list
isInstall=0

# 输出一些帮助信息
if [ $1 = $comm3 ]; then
    echo '添加用户：'
    echo "add username [dir [password]]"
    echo '若没指定目录则默认为“/var/ftp/用户名”目录下'
    echo '若没指定密码则默认为：123456'
    echo ''
    echo '删除用户：'
    echo "rm username [del_dir]"
    echo 'del_dir若设置为true，则表示同时删除目录'
    echo ''
    echo '列出用户名、密码及其目录：'
    echo 'list'    
    exit

fi

# 判断传入参数是否正确
if [ $# -lt 1 ]; then
    echo "命令格式错误，可输入“help”查看帮助"
    exit
elif [ $1 != $comm1 -a $1 != $comm2 -a $1 != $comm4 ]; then
    echo "参数错误"
    exit
fi

# 判断ftp.server文件是否存在，存在就表示安装了
if [ -f /usr/lib/systemd/system/vsftpd.service ]; then
    isInstall=1
fi

# 如果之前没安装就安装下并初始化环境
if [ $isInstall -eq 0 ]; then
    # 安装vsftpd
    yum install -y vsftpd &> /dev/null    

    if [ -f /usr/lib/systemd/system/vsftpd.service ]; then
        echo "vsftpd install successful"
    else
        echo "vsftpd install failed"
    fi

    # 开启服务自启动
    systemctl enable vsftpd

    # 开启防火墙
    firewall-cmd --zone=public --add-service=ftp --permanent # 只开了21端口
    firewall-cmd --zone=public --add-port=30000-30080/tcp --permanent # 被动模式的数据传输端口
    systemctl restart firewalld

    # 覆盖vsftpd的配置文件
    echo "anonymous_enable=NO
local_enable=YES
local_umask=022
write_enable=YES
allow_writeable_chroot=YES
userlist_deny=NO
chroot_local_user=YES
listen=NO
listen_ipv6=YES
force_dot_files=YES
guest_enable=YES
guest_username=ftp
virtual_use_local_privs=YES
pam_service_name=vsftpd
user_config_dir=/etc/vsftpd/vconf
xferlog_enable=YES
xferlog_std_format=YES
xferlog_file=/var/log/xferlog
pasv_enable=YES
pasv_min_port=30000
pasv_max_port=30080" > /etc/vsftpd/vsftpd.conf

    # 重启ftp服务配置生效
    systemctl restart vsftpd

    # 创建虚拟账户数据库
    touch /etc/vsftpd/vuser.txt
    db_load -Tt hash -f /etc/vsftpd/vuser.txt /etc/vsftpd/vuser.db
    mkdir /etc/vsftpd/vconf
    
    # 修改PAM认证文件
    sed -i 's/^/#/g' /etc/pam.d/vsftpd # 注释原文件
    echo '' >> /etc/pam.d/vsftpd
    echo 'auth required /lib64/security/pam_userdb.so db=/etc/vsftpd/vuser' >> /etc/pam.d/vsftpd
    echo 'account required /lib64/security/pam_userdb.so db=/etc/vsftpd/vuser' >> /etc/pam.d/vsftpd
fi

if [ $1 = $comm1 ]; then
    if [ ! $2 ]; then echo "请指定用户名"; exit; fi

    password=123456
    local_root=/var/ftp/$2

    if [ $4 ]; then password=$4; fi
    echo -e "$2\n$password" >> /etc/vsftpd/vuser.txt
    rm -f /etc/vsftpd/vuser.db 
    db_load -Tt hash -f /etc/vsftpd/vuser.txt /etc/vsftpd/vuser.db
    
    if [ $3 ]; then local_root=$3; fi

    echo "local_root=$local_root" > /etc/vsftpd/vconf/$2
    
    if [ ! -d $local_root ]; then
        mkdir -p $local_root
        chown ftp:ftp $local_root
    fi
    
    systemctl restart vsftpd

    echo "已创建用户：$2，密码：$password"
elif [ $1 = $comm2 ]; then
    # 删除验证数据库中的字段
    sed -i "/^$2$/,+1d" /etc/vsftpd/vuser.txt    
    rm -f /etc/vsftpd/vuser.db # 必须先删除
    db_load -Tt hash -f /etc/vsftpd/vuser.txt /etc/vsftpd/vuser.db

    systemctl restart vsftpd

 
     # 获取用户配置的local_root，并删除相关目录
    if [ -f /etc/vsftpd/vconf/$2 ]; then
        local_root=`cut -d '=' -f 2 /etc/vsftpd/vconf/$2`
        rm -rf /etc/vsftpd/vconf/$2
           
        # 删除用户目录
        if [ $3 == true ]; then
            rm -rf $local_root
        fi
    fi
 
    
     
echo "已删除用户：$2"
elif [ $1 = $comm4 ]; then
    # 列出已经创建的用户、密码及其目录名称
    users=`awk 'NR%2' /etc/vsftpd/vuser.txt`
    passwords=`awk '!(NR%2)' /etc/vsftpd/vuser.txt`
    i=1
    
    echo -e '用户\t\t密码\t\t目录'
    for user in $users; do
        local_root=`cut -d '=' -f 2 /etc/vsftpd/vconf/${user}`
        password=`echo $passwords | cut -d ' ' -f $i`
            
        echo -e "${user}\t\t${password}\t\t${local_root}"
    
        let i=$i+1
    done

fi
