provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.aws_region}"
}

resource "aws_instance" "server" {
  # Resource settings
  count = "${var.servers}"
  ami = "${lookup(var.ami, var.aws_region)}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_name}"
  security_groups = ["${aws_security_group.consul-server.name}"]

  #Instance tags
  tags {
    Name = "${var.tagServerName}-${count.index}"
  }

  # Connection settings
  connection {
    user = "${var.user}"
    key_file = "${var.key_path}"
  }

  # Add config to /tmp/config on remote
  provisioner "file" {
    source = "${path.module}/config"
    destination = "/tmp"
  }

  # Install docker
  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y docker",
      "sudo service docker start",
      "sudo usermod -a -G docker ec2-user",
    ]
  }

  # Run docker container
  provisioner "remote-exec" {
    inline = [
      "docker run -d --restart always --net host --name consul-server -v /tmp/config:/etc/consul.d \\",
      " -p ${self.private_ip}:8300:8300 \\",
      " -p ${self.private_ip}:8301:8301 \\",
      " -p ${self.private_ip}:8301:8301/udp \\",
      " -p ${self.private_ip}:8302:8302 \\",
      " -p ${self.private_ip}:8302:8302/udp \\",
      " -p ${self.private_ip}:8400:8400 \\",
      " -p ${self.private_ip}:8500:8500 \\",
      " -p 172.17.42.1:53:8600/udp \\",
      " ${var.consul_docker_image} agent -config-dir /etc/consul.d \\",
      " -advertise ${self.private_ip} -retry-join ${aws_instance.server.0.private_ip}",
    ]
  }
}

resource "aws_security_group" "consul-server" {
  name_prefix = "consul-server-"
  description = "Consul internal traffic + maintenance."

  # Internal traffic
  ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    self = true
  }

  ingress {
    from_port = 0
    to_port = 65535
    protocol = "udp"
    self = true
  }

  # SSH
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound internet connection
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
