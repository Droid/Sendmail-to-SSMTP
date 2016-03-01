#!/bin/bash
# https://github.com/KuJoe/Sendmail-to-SSMTP

# !!!!IMPORTANT!!!! One of the following sets needs to be uncommented for this script to work.

# Uncomment these two lines if you are running CentOS/Fedora/RHEL based distros.
#yum remove sendmail mailx nail bsd-mailx heirloom-mailx -y
#yum install mailx ssmtp -y

# Uncomment these two lines if you are running Debian/Ubuntu based distros.
#apt-get remove sendmail mailx nail bsd-mailx heirloom-mailx -y
#apt-get install heirloom-mailx ssmtp -y

# Remove sendmail and symlink to ssmtp
rm -rf /usr/sbin/sendmail
ln -s /usr/sbin/ssmtp /usr/sbin/sendmail

# Write config file for ssmtp
# Change "mydomain.com", "user@mydomain.com", and "API_KEY_OR_PASSWORD"
# Replace "smtp.mandrillapp.com" with "smtp.sendgrid.net" to use SendGrid, you can specify any other SMTP server also
# Where mail will come from
echo "rewriteDomain=mydomain.com" > /etc/ssmtp/ssmtp.conf
# Server hostname
echo "hostname=mydomain.com" >> /etc/ssmtp/ssmtp.conf
# Where mail will be routed from
echo "mailhub=smtp.mandrillapp.com:587" >> /etc/ssmtp/ssmtp.conf
# Use TLS 
echo "UseSTARTTLS=YES" >> /etc/ssmtp/ssmtp.conf
# Authenticate username with mail server
echo "AuthUser=user@mydomain.com" >> /etc/ssmtp/ssmtp.conf
# Authenticate Password or API key with mail server
echo "AuthPass=API_KEY_OR_PASSWORD" >> /etc/ssmtp/ssmtp.conf
# Will other users be able to change the "FROM" field
echo "FromLineOverride=YES" >> /etc/ssmtp/ssmtp.conf
# SSL certificates
echo "TLS_CA_File=/etc/pki/tls/certs/ca-bundle.crt" >> /etc/ssmtp/ssmtp.conf
echo "" > /etc/ssmtp/revaliases

# Uncomment these lines if you're running VestaCP with the default firewall (otherwise the firewall will block ssmtp)
#echo "/sbin/iptables -A OUTPUT -p udp --dport 587 -m state --state NEW,ESTABLISHED -j ACCEPT" >> /usr/local/vesta/data/firewall/custom.sh
#echo "/sbin/iptables -A INPUT  -p udp --sport 587 -m state --state ESTABLISHED     -j ACCEPT" >> /usr/local/vesta/data/firewall/custom.sh
#echo "/sbin/iptables -A OUTPUT -p tcp --dport 587 -m state --state NEW,ESTABLISHED -j ACCEPT" >> /usr/local/vesta/data/firewall/custom.sh
#echo "/sbin/iptables -A INPUT  -p tcp --sport 587 -m state --state ESTABLISHED     -j ACCEPT" >> /usr/local/vesta/data/firewall/custom.sh
#chmod 0755 /usr/local/vesta/data/firewall/custom.sh
#/usr/local/vesta/bin/v-update-firewall

# Uncomment these lines if you are not running VestaCP and you receive an error like "send-mail: Cannot open smtp.host.com:587", you'll need to save the iptables rules also but this is different based on your distro so you can do that yourself.
#/sbin/iptables -A OUTPUT -p udp --dport 587 -m state --state NEW,ESTABLISHED -j ACCEPT
#/sbin/iptables -A INPUT  -p udp --sport 587 -m state --state ESTABLISHED     -j ACCEPT
#/sbin/iptables -A OUTPUT -p tcp --dport 587 -m state --state NEW,ESTABLISHED -j ACCEPT
#/sbin/iptables -A INPUT  -p tcp --sport 587 -m state --state ESTABLISHED     -j ACCEPT

# Sends you a test e-mail to make sure things are working correctly, check the header and make sure it came from Mandrill.
# Change my@email.com
uptime | mail -s "MAIL TEST" my@email.com
