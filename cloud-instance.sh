aws ec2 run-instances \
	--image-id ami-0bbe28eb2173f6167 \
	--instance-type t2.micro \
	--subnet-id subnet-6fad9515 \
	--security-group-ids sg-0c1c2639e1545ee38 \
	--associate-public-ip-address \
	--key-name jenkins \
        --region us-east-2
    
    
ip=`aws ec2 describe-instances --region us-east-2 --query 'sort_by(Reservations[].Instances[], &LaunchTime)[].[InstanceId,PublicIpAddress,LaunchTime]' --output text | tail -1 | awk '{ print $2 }'`
ssh -i "/home/ubuntu/jenkins.pem" ubuntu@$ip '
sudo ufw allow 22
sudo echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDhj3oGhTRtgz/nCmIX1IZPCfnoR/nbLfzrDMTgun+o/T9xUM3bUdqyLpKAn25NSvYrpoYkOzu51rOmUb1HGgd7TNEpAoVixskRiNeOv3iE1GDe3v0MuESGeeQuty9vNyLLVVrad56ZfNzyHdUoXBx1rkS6jFfbLeiAcDiBGojHsPsNoP7NNT4PYZaeLysvwdv7LWAUifR4fm5oC2O5ivk4E1YjZeCsDkFSQcCpI2YwFkAYCKMeY9xU+ll9SuMp8bMLo+GVMNeIFUlKzfMAqc/1255cgUPz+tDaF32Nl9PoiVJ5LhEGUyFXIsLH9qfxMHuVkXnapoQMzIQdD2+d9HZZ jenkins@jenkins-01
" >> /home/ubuntu/.ssh/authorized_keys 
sudo hostname Nagios-slave2
sudo apt-get update
sudo apt-get install nagios-nrpe-server nagios-plugins -y
sudo chmod 777 -R /etc/nagios/
sudo echo " allowed_hosts=127.0.0.1,172.31.29.56" >> /etc/nagios/nrpe.cfg
sudo service nagios-nrpe-server restart 
'


ip=`aws ec2 describe-instances --region us-east-2 --query 'sort_by(Reservations[].Instances[], &LaunchTime)[].[InstanceId,PublicIpAddress,LaunchTime]' --output text | tail -1 | awk '{ print $2 }'`
ssh ubuntu@172.31.29.56 '
sudo chmod 777 -R /usr/local/nagios/
sudo echo " 
define host {
        use                          linux-server
        host_name                    nagios-slave2
        alias                        Ubuntu Host
        address                       '$ip'
        register                     1
}
define service {
       use                            generic-service
      host_name                       nagios-slave2
      service_description             Check SSH
      check_command                   check_ssh
      max_check_attempts              2
      check_interval                  2
      retry_interval                  2
      check_period                    24x7
      check_freshness                 1
      contact_groups                  admins
      notification_interval           2
      notification_period             24x7
      notifications_enabled           1
      register                        1
}
define service {
      host_name                       nagios-slave2
      service_description             PING
      check_command                   check_ping!100.0,20%!500.0,60%
      max_check_attempts              2
      check_interval                  2
      retry_interval                  2
      check_period                    24x7
      check_freshness                 1
      contact_groups                  admins
      notification_interval           2
      notification_period             24x7
      notifications_enabled           1
      register                        1
}
define service {
      host_name                       nagios-slave2
      service_description             Total Process
      check_command                   check_local_procs!250!400!RSZDT
      max_check_attempts              2
      check_interval                  2
      retry_interval                  2
      check_period                    24x7
      check_freshness                 1
      contact_groups                  admins
      notification_interval           2
      notification_period             24x7
      notifications_enabled           1
      register                        1
}
define service {
      host_name                       nagios-slave2
      service_description             Local Disk
      check_command                   check_local_disk!20%!10%!/
      max_check_attempts              2
      check_interval                  2
      retry_interval                  2
      check_period                    24x7
      check_freshness                 1
      contact_groups                  admins
      notification_interval           2
      notification_period             24x7
      notifications_enabled           1
      register                        1
}
define service {
host_name                   nagios-slave2
service_description        Check Users
check_command              check_local_users!20!50
max_check_attempts           2
check_interval               2
retry_interval                2
check_period                 24x7
check_freshness               1
contact_groups                admins
notification_interval             2
notification_period             24x7
notifications_enabled           1
register                        1
}
" >> /usr/local/nagios/etc/services/slave2.cfg
sudo systemctl restart nagios
'
