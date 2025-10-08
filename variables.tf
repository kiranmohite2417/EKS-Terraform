# --- General ---
variable "region" {
  description = "AWS region for all resources"
  type        = string
}

variable "profile" {
  description = "AWS CLI profile to use"
  type        = string
}

# --- Networking ---
variable "vpc_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "subnet_count" {
  type = number
}

variable "availability_zones" {
  type = list(string)
}

variable "map_public_ip" {
  type = bool
}

variable "subnet_name_prefix" {
  type = string
}

variable "igw_name" {
  type = string
}

variable "route_table_name" {
  type = string
}

variable "route_cidr" {
  type = string
}

# --- EKS Cluster ---
variable "cluster_name" {
  type = string
}

variable "cluster_role_name" {
  type = string
}

# --- Node Group ---
variable "node_group_name" {
  type = string
}

variable "node_role_name" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "desired_size" {
  type = number
}

variable "max_size" {
  type = number
}

variable "min_size" {
  type = number
}

# --- Key Pair ---
variable "key_pair_name" {
  type = string
}

