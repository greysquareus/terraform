#!/bin/bash
yum -y update
yum -y install httpd
myip=`curl -s https://api.ipify.org`
#myip=`hostname -I`
#myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
#echo "<h2>Webserver with IP: $myip</h2><br>Build by greysquare with file option!" > /var/www/html/index.html
sudo apt install -y  $list
cat <<EOF > /var/www/html/index.html
<html>
<h2>Build by Dynamic string Terraform <font color="red">  by greysquare </font></h2?<br>
Owner:  ${owner} <br>

# That`s how use cycle for doing something
%{ for x in names ~}
Hello to ${x} from ${owner}
%{ endfor ~}

service httpd start
chkconfig httpd on
