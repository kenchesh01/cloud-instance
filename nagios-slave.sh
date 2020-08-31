ip=`aws ec2 describe-instances --region us-east-2 --query "Reservations[*].Instances[*].PublicIpAddress" --output=text | tail -1`
ssh -i "/home/ubuntu/jenkins.pem" ubuntu@$ip '
sudo echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDhj3oGhTRtgz/nCmIX1IZPCfnoR/nbLfzrDMTgun+o/T9xUM3bUdqyLpKAn25NSvYrpoYkOzu51rOmUb1HGgd7TNEpAoVixskRiNeOv3iE1GDe3v0MuESGeeQuty9vNyLLVVrad56ZfNzyHdUoXBx1rkS6jFfbLeiAcDiBGojHsPsNoP7NNT4PYZaeLysvwdv7LWAUifR4fm5oC2O5ivk4E1YjZeCsDkFSQcCpI2YwFkAYCKMeY9xU+ll9SuMp8bMLo+GVMNeIFUlKzfMAqc/1255cgUPz+tDaF32Nl9PoiVJ5LhEGUyFXIsLH9qfxMHuVkXnapoQMzIQdD2+d9HZZ jenkins@jenkins-01
" >> /home/ubuntu/.ssh/authorized_keys 
sudo hostname Nagios-slave2
sudo apt-get update
sudo ufw allow 22
sudo apt-get install nagios-nrpe-server nagios-plugins -y
sudo chmod 777 -R /etc/nagios/
sudo echo " allowed_hosts=127.0.0.1,172.31.29.56" >> /etc/nagios/nrpe.cfg
sudo service nagios-nrpe-server restart 
'