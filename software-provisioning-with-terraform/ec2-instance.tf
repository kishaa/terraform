# Creation of AWS ec2 instance with key pairs which would be generated by terraform
resource "aws_instance" "exmaple" {
  
  ami = lookup(var.AWS-EC2-AMI, var.AWS-Resource-region)
  instance_type = "t2.micro"
  key_name = var.EC2-Key-Name

  # Provisioner to copy script file from local folder to remote machine
provisioner "file" {
  source = var.Source-To-Script
  destination = var.Destination-Of-Script
}

provisioner "remote-exec" {
  inline = [
      "chmod +x /tmp/script.sh",
      "sudo sed -i -e 's/\r$//' /tmp/script.sh",  # Remove the spurious CR characters.
      "sudo /tmp/script.sh",
    ]
}

connection {
  host        = coalesce(self.public_ip, self.private_ip)
  type        = "ssh"
  user = var.EC2-UserName
  private_key = file(var.EC2-Private-Key-Path)
}
}

# Creation of key pairs for ec2 instance
resource "aws_key_pair" "aws-key-pair" {
  key_name = var.EC2-Key-Name
  public_key = file(var.EC2-Public-Key-Path)
}