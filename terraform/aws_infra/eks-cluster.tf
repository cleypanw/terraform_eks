module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.24.1"

  cluster_name    = local.cluster_name
  cluster_version = "1.30"

  vpc_id                                = module.vpc.vpc_id
  subnet_ids                            = module.vpc.private_subnets
  cluster_endpoint_private_access       = true
  cluster_endpoint_public_access        = false
  # Add ec2-bastion security group to allow to connect to the cluster control plane
  cluster_additional_security_group_ids = ["${aws_security_group.ec2-bastion.id}"]
  enable_cluster_creator_admin_permissions = true

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"

  }

  eks_managed_node_groups = {
    one = {
      name           = "eks-node-group-1"
      instance_types = ["${var.worker_nodes_type}"]
      min_size       = 1
      max_size       = 5
      desired_size   = var.worker_nodes_desired_size
      metadata_options = {
        http_endpoint          = "enabled"
        http_tokens            = "required"
        instance_metadata_tags = "enabled"
      }
    }

    #    two = {
    #      name = "eks-node-group-2"
    #
    #      instance_types = ["t3.medium"]
    #
    #      min_size     = 1
    #      max_size     = 3
    #      desired_size = 2
    #      metadata_options = {
    #       http_endpoint          = "enabled"
    #       http_tokens            = "required"
    #       instance_metadata_tags = "enabled"
    #      }
    #    }
  }
}