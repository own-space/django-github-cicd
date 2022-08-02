#!/bin/bash

count=`cat /root/.ssh/id_rsa | wc -l`
if [[ $count -lt 1 ]]
then
cat <<EOT >> /root/.ssh/id_rsa
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
QyNTUxOQAAACAM/NfASBQk5d78xQYwKvb0HZJAR7HpTemEh3IRjL85jQAAAJi2f/YXtn/2
FwAAAAtzc2gtZWQyNTUxOQAAACAM/NfASBQk5d78xQYwKvb0HZJAR7HpTemEh3IRjL85jQ
AAAEDGz6p/AEUi1e51EETL8GAoszFtcJX1DdLUo1R+BrAg5Qz818BIFCTl3vzFBjAq9vQd
kkBHselN6YSHchGMvzmNAAAADsKgwqBnaXRodWIuY29tAQIDBAUGBw==
-----END OPENSSH PRIVATE KEY-----
EOT
else
echo 'cp worked' >> /tmp/provision.log
fi
