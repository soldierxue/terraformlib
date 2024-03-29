resource "aws_instance" "database" {
  ami           = "${data.aws_ami.amazonlinux_ami.id}"
  instance_type = "t2.micro"
  associate_public_ip_address = "false"
  subnet_id = "${var.private_subnet_id}"
  vpc_security_group_ids = ["${var.database_sgid}"]
  key_name = "${var.ec2keyname}"
  tags = {
        Name = "${format("mysql-%s-%s", var.name, var.environment)}"
  }
  user_data = <<HEREDOC
  #!/bin/bash
  # Wait for NAT to be ready, then it can access internet through NAT instance
  sleep 180
  ping -c 2 aws.amazon.com
  while ["$?" != "0"];do
    sleep 30
    ping -c 2 aws.amazon.com
  done    
  yum update -y
  yum install -y mysql55-server
  service mysqld start
  /usr/bin/mysqladmin -u root password 'secret'
  mysql -u root -psecret -e "create user 'root'@'%' identified by 'secret';" mysql
  mysql -u root -psecret -e 'CREATE TABLE mytable (mycol varchar(255));' test
  mysql -u root -psecret -e "INSERT INTO mytable (mycol) values ('terraform with aws great');" test
HEREDOC
}

resource "aws_instance" "phpapp" {
  ami           = "${data.aws_ami.amazonlinux_ami.id}"
  instance_type = "t2.micro"
  associate_public_ip_address = "true"
  subnet_id = "${var.public_subnet_id}"
  vpc_security_group_ids = ["${var.fronend_web_sgid}"]
  key_name = "${var.ec2keyname}"
  root_block_device  {
     volume_type ="gp2"
     volume_size ="20"
     delete_on_termination="true"
  }
  ebs_block_device {
     device_name = "/dev/sdg"
     volume_type ="gp2"
     volume_size ="10"
     delete_on_termination="true"  
  }
  
  tags = {
        Name = "${format("phpweb-%s-%s", var.name, var.environment)}"
  }
  user_data = <<HEREDOC
  #!/bin/bash
  # Wait for NAT to be ready, then it can access internet through NAT instance
  sleep 180
  ping -c 2 aws.amazon.com
  while ["$?" != "0"];do
    sleep 30
    ping -c 2 aws.amazon.com
  done  
  yum update -y
  yum install -y httpd24 php56 php56-mysqlnd
  service httpd start
  chkconfig httpd on
  echo "<?php" >> /var/www/html/calldb.php
  echo "\$conn = new mysqli('${aws_instance.database.private_ip}', 'root', 'secret', 'test');" >> /var/www/html/calldb.php
  echo "\$sql = 'SELECT * FROM mytable'; " >> /var/www/html/calldb.php
  echo "\$result = \$conn->query(\$sql); " >>  /var/www/html/calldb.php
  echo "while(\$row = \$result->fetch_assoc()) { echo 'the value is: ' . \$row['mycol'] ;} " >> /var/www/html/calldb.php
  echo "\$conn->close(); " >> /var/www/html/calldb.php
  echo "?>" >> /var/www/html/calldb.php
HEREDOC

  #depends_on = ["${aws_instance.database}"]
}

