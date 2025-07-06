#!/bin/bash
apt -y update
#myip=`hostname -I`
#myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
#echo "<h2>Webserver with IP: $myip</h2><br>Build by greysquare with file option!" > /var/www/html/index.html
%{ for item in list ~}
apt -y install ${item}
%{ endfor ~}

myip=$(curl -s https://api.ipify.org)


cat <<EOF > /var/www/html/index.html
<html>
<h2>Build by Dynamic string Terraform <font color="red">  by greysquare </font></h2><br>
Owner:  ${owner} <br>
Your IP: $myip <br><br>
Version 2</br>


%{ for x in names ~}
Hello to ${x} from ${owner}
%{ endfor ~}

</html>
EOF

systemctl start apache2
systemctl enable apache2
