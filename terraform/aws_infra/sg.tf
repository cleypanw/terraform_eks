#########
# Security group configuration

resource "aws_security_group" "ec2-bastion" {

  description = "SG for ec2-bastion"
  name        = local.sg_name
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "ssh access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound access"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = local.sg_name
    nils = "custom"
  }
}

## Add EC2 security Group to EKS cluster security Group
resource "aws_security_group_rule" "ec2_to_eks" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ec2-bastion.id
  security_group_id        = module.eks.cluster_security_group_id
  description              = "Add ec2-bastion security group to allow to connect to EKS cluster control plane"
}