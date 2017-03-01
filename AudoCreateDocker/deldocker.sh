#!/bin/bash

# This script is maintenance by Shuanglong Li, lis8920@gmail.com

# Version 1.0

#SS 服务器地址
#svrlist="hk01.slivps.xyz hk02.slivps.xyz jp01.slivps.xyz"
usermail="lis8920@gmail.com,lis8920@sina.com"

for server in ./svrlist
do
	ssh -p 24180 ubuntu@$server "docker rm -f $ssport-port"
done

rm -f ./userprofile/profile-$ssport

echo "

亲爱的顾客，您好！

	感谢您选择我们的服务，这封邮件是提醒您，您的服务已经到期。如果您仍然需要使用我们的服务，欢迎继续续费使用！
	
	请访问xxxx.xxxx.xxxx进行购买！
	
任何问题，您随时可以联系我们！lis8920@gmail.com

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Dear Customers,

Thanks for you choise our services, this mail is notice you the service has been expired! If you still need our service, welcome go to renew your license!

Please access xxxx.xxxx.xxxx to purchase our services!

Any question feel free to contact us: lis8920@gmail.com

" > /tmp/mailbody

mutt -s "您的服务已经过期! / Your Service Has Been Expired!" -b $usermail < /tmp/mailbody

rm -f /tmp/mailbody
