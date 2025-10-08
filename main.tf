terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  required_version = ">= 1.5.0"
}

# ✅ AWS Provider
provider "aws" {
  region  = var.region
  profile = var.profile
}

# --- VPC ---
resource "aws_vpc" "devopsshack" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.vpc_name
  }
}

# --- Subnets ---
resource "aws_subnet" "devopsshack" {
  count                   = var.subnet_count
  vpc_id                  = aws_vpc.devopsshack.id
  cidr_block              = cidrsubnet(aws_vpc.devopsshack.cidr_block, 8, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = var.map_public_ip

  tags = {
    Name = "${var.subnet_name_prefix}-${count.index}"
  }
}

# --- Internet Gateway ---
resource "aws_internet_gateway" "devopsshack" {
  vpc_id = aws_vpc.devopsshack.id

  tags = {
    Name = var.igw_name
  }
}

# --- Route Table ---
resource "aws_route_table" "devopsshack" {
  vpc_id = aws_vpc.devopsshack.id

  route {
    cidr_block = var.route_cidr
    gateway_id = aws_internet_gateway.devopsshack.id
  }

  tags = {
    Name = var.route_table_name
  }
}

# --- Route Table Associations ---
resource "aws_route_table_association" "devopsshack" {
  count          = length(aws_subnet.devopsshack)
  subnet_id      = element(aws_subnet.devopsshack[*].id, count.index)
  route_table_id = aws_route_table.devopsshack.id
}

# --- IAM Role for EKS Cluster ---
resource "aws_iam_role" "devopsshack_cluster_role" {
  name = var.cluster_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "devopsshack_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.devopsshack_cluster_role.name
}

# --- EKS Cluster ---
resource "aws_eks_cluster" "devopsshack" {
  name     = var.cluster_name
  role_arn = aws_iam_role.devopsshack_cluster_role.arn

  vpc_config {
    subnet_ids = aws_subnet.devopsshack[*].id
  }

  depends_on = [
    aws_iam_role_policy_attachment.devopsshack_cluster_policy
  ]
}

# --- IAM Role for EKS Node Group ---
resource "aws_iam_role" "devopsshack_node_role" {
  name = var.node_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# --- Attach Node Role Policies ---
resource "aws_iam_role_policy_attachment" "devopsshack_node_worker" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.devopsshack_node_role.name
}

resource "aws_iam_role_policy_attachment" "devopsshack_node_cni" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.devopsshack_node_role.name
}

resource "aws_iam_role_policy_attachment" "devopsshack_node_ecr" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.devopsshack_node_role.name
}

# --- EKS Node Group (3 Nodes) ---
resource "aws_eks_node_group" "devopsshack" {
  cluster_name    = aws_eks_cluster.devopsshack.name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.devopsshack_node_role.arn
  subnet_ids      = aws_subnet.devopsshack[*].id

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  instance_types = [var.instance_type]

  remote_access {
    ec2_ssh_key = var.key_pair_name
  }

  depends_on = [
    aws_iam_role_policy_attachment.devopsshack_node_worker,
    aws_iam_role_policy_attachment.devopsshack_node_cni,
    aws_iam_role_policy_attachment.devopsshack_node_ecr
  ]
}

