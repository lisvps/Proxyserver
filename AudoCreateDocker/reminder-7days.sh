#!/bin/bash

# This script is maintenance by Shuanglong Li, lis8920@gmail.com

# Version 1.0

usermail="lis8920@gmail.com,lis8920@sina.com"

echo "

亲爱的顾客，您好！

	感谢您选择我们的服务，这封邮件是提醒您，您的服务即将在7天后到期。如果您仍然需要使用我们的服务，欢迎继续续费使用！
	
	请访问xxxx.xxxx.xxxx进行购买！
	
任何问题，您随时可以联系我们！lis8920@gmail.com

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Dear Customers,

Thanks for you choise our services, this mail is reminder you the service will expired after 7 days. If you still need our service, welcome go to renew your license!

Please access xxxx.xxxx.xxxx to purchase our services!

Any question feel free to contact us: lis8920@gmail.com

" > /tmp/mailbody

mutt -s "您的服务即将在7天后过期! / Your Service will Expired after 7 Days!" -b $usermail < /tmp/mailbody

rm -f /tmp/mailbody
