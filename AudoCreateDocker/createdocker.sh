#!/bin/bash

# This script is maintenance by Shuanglong Li, lis8920@gmail.com

# Version 1.0

#apt-get install zip -y
#apt-get install pwgen -y
#apt-get install qrencode -y


#SS 服务器地址
#svrlist="hk01.slivps.xyz hk02.slivps.xyz jp01.slivps.xyz"

#配置完成后接收配置信息的用户邮箱地址
usermail="lis8920@gmail.com,lis8920@sina.com"

DATE=$(date +%r/%Y-%m-%d)

mkdir userprofile

#随机生成8位数密码

sspwd=$(pwgen -cs 12 1)
echo "Generated new ss password: Done"

#生成SS端口
ssport=$(shuf -i 2000-5000 -n 1)
echo "Generated a new ss port: Done"

mkdir ./userprofile/profile-$ssport

#生成SS-Windows配置文件和二维码

echo "
{
    \"configs\": [" >> ./userprofile/profile-$ssport/gui-config.json

for server in ./svrlist
do 
	url="aes-256-cfb:$sspwd@$server:$ssport"
	echo $url
	
	uri=$(echo $url | base64)
	echo $uri
	echo "Generated new SS configuration: "ss://"$uri. Done"
	
	qrencode -o ./userprofile/profile-$ssport/$server.png -s 10 ""ss://"$uri"
	echo "Generated new QR Code picture, name $server.png. Done"
	
	echo "
        {
            \"server\": \"$server\",
            \"server_port\": \"$ssport\",
            \"local_port\": 1080,
            \"password\": \"$sspwd\",
            \"method\": \"aes-256-cfb\"
        }," >> ./userprofile/profile-$ssport/gui-config.json
	ssh -p 24180 ubuntu@$server "docker run --name $ssport-port --restart always -d -p $ssport:$ssport lishuanglong/alpine-web -p $ssport -k $sspwd"

done

echo "
    ],
    "localPort": 1080,
    "index": 0,
    "global": false,
    "enabled": true,
    "isDefault": false
}" >> ./userprofile/profile-$ssport/gui-config.json

zip -r ./userprofile/profile-$ssport.zip ./userprofile/profile-$ssport/*

#创建Crontab并在指定日期关闭服务

	echo "exec ./deldocker.bash" | at now + 1 minutes
	echo "exec ./reminder-7days.bash" | at now + 1 minutes

#发送配置信息邮件给到用户, 请将需要接收邮件的用户邮箱添加到usermail中。
echo “Now send the configuration info to user...”

echo "

亲爱的顾客，您好！

	感谢您选择我们的服务，以下是我们提供的Sock5配置信息，请参考指南完成您客户端的配置，请勿将以下信息泄露给他人。

声明：请遵守当地的法律法规，本服务禁止用于非法途径。一旦发现任何违反，我们有权在任何时候停止该服务，感谢您的配合！

服务发布日期：$DATE

可用服务器信息：

########################################################
香港：hk01.slivps.xyz
日本：jp01.slivps.xyz
台湾-美国: tw01.slivps.xyz
########################################################

您的访问密码和配置信息：

########################################################
 * 服务器:                  # 请在“可用服务器信息”中选填
 * 端口: $ssport     
 * 密码: $sspwd
 * 加密方式: aes-256-cfb 
########################################################


任何问题，您随时可以联系我们！lis8920@gmail.com

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Dear Customers,

Thanks for you choise our services, below is your sock5 configuration info, please DO NOT share these private information to other people. 

Also do not use for illegal purposes and to comply with local laws, if we found any violation, we have the right to terminate the service at any time, thank you for your cooperation!

Service Released Date: $DATE 


The available server list：

########################################################
Hongkong：hk01.slivps.xyz
Japan：jp01.slivps.xyz
Taiwan-US: tw01.slivps.xyz
########################################################

Your password and configuration：

########################################################
 * Server Address:         # You can choise from svrlist
 * Server Port: $ssport     
 * Password: $sspwd
 * Encryption: aes-256-cfb 
########################################################


Any question feel free to contact us: lis8920@gmail.com
Thank You！
" > /tmp/mailbody

mutt -s "这是您申请的Sock5服务信息! / This is your Sock5 configuration info!" -b $usermail -a ./userprofile/profile-$ssport.zip < /tmp/mailbody

rm -f /tmp/mailbody
rm -f ./userprofile/profile-$ssport.zip
echo "Done, everything is ready now!"

exit 0
