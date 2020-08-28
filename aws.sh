ssh ubuntu@$ip '
sudo echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDhj3oGhTRtgz/nCmIX1IZPCfnoR/nbLfzrDMTgun+o/T9xUM3bUdqyLpKAn25NSvYrpoYkOzu51rOmUb1HGgd7TNEpAoVixskRiNeOv3iE1GDe3v0MuESGeeQuty9vNyLLVVrad56ZfNzyHdUoXBx1rkS6jFfbLeiAcDiBGojHsPsNoP7NNT4PYZaeLysvwdv7LWAUifR4fm5oC2O5ivk4E1YjZeCsDkFSQcCpI2YwFkAYCKMeY9xU+ll9SuMp8bMLo+GVMNeIFUlKzfMAqc/1255cgUPz+tDaF32Nl9PoiVJ5LhEGUyFXIsLH9qfxMHuVkXnapoQMzIQdD2+d9HZZ jenkins@jenkins-01
" >> /home/ubuntu/.ssh/authorized_keys 
sudo apt-get update
sudo apt-get install nagios-nrpe-server nagios-plugins -y
sudo chmod 777 -R /etc/nagios/
sudo echo " allowed_hosts=127.0.0.1,172.31.29.56" >> /etc/nagios/nrpe.cfg
sudo service nagios-nrpe-server restart '



ssh ubuntu@172.31.29.56 '
sudo chmod 777 -R /usr/local/nagios/
sudo echo " 
define host {
        use                          linux-server
        host_name                    nagios-slave4
        alias                        Ubuntu Host
        address                       $ip
        register                     1
}
define service{
     use                     generic-service
     host_name               nagios-slave4
     service_description     check-host-alive
      check_command          check-host-alive
}

define service {
      host_name                       nagios-slave4
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
      host_name                       nagios-slave4
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
      host_name                       nagios-slave4
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
      host_name                       nagios-slave4
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
" >> /usr/local/nagios/etc/services/slave.cfg
sudo systemctl restart nagios
'
