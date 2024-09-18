#########
# EC2 configuration

resource "aws_key_pair" "ssh_key" {
  key_name   = local.sshkey_name
  public_key = "${var.public_ssh_key}"
  tags = {
    yor_trace = "a93f9a32-7951-48ad-abf9-5cf7b011cd4a"
  }
}

resource "aws_instance" "ec2instance" {

  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.medium"
  subnet_id              = module.vpc.public_subnets[0]
  private_ip             = "10.0.4.10"
  vpc_security_group_ids = ["${aws_security_group.ec2-bastion.id}"]

  #checkov:skip=CKV_AWS_88
  associate_public_ip_address = true

  key_name = "${aws_key_pair.ssh_key.key_name}"

  root_block_device {
    delete_on_termination = true
    volume_size           = 20
    volume_type           = "gp2"
    encrypted             = true
  }

  # https://docs.bridgecrew.io/docs/bc_aws_general_31
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  depends_on = [
    aws_key_pair.ssh_key
  ]

  tags = {
    Name      = local.ec2_bastion_name
    yor_trace = "1bd2ac10-155c-4b76-8faf-6e0c7e0d5bb0"
  }
}