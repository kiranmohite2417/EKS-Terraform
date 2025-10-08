# EKS-Terraform
Just need to update region and key pair is good to go to create eks cluster


---

## ⚙️ How It Works

This Terraform configuration uses the **AWS provider** to create all necessary networking and compute resources required for an EKS cluster.

### Workflow Summary
1. **VPC & Networking**  
   - Creates a new VPC with CIDR `10.0.0.0/16`  
   - Creates public subnets across multiple Availability Zones  
   - Configures an Internet Gateway and Route Table  

2. **IAM Roles**  
   - Creates IAM roles for the EKS cluster and node group with required permissions  

3. **EKS Cluster**  
   - Deploys an Amazon EKS cluster (`devopsshack-cluster`)  

4. **Node Group**  
   - Creates an EKS Node Group with **3 worker nodes** (`t3.medium`)  
   - Associates the `devops-intern` EC2 key pair for SSH access  

5. **Outputs**  
   - Displays EKS cluster name, endpoint, certificate data, and node group name  

---

## ☁️ AWS Resources Created

| Resource Type | Description | Example Name |
|----------------|-------------|---------------|
| **VPC** | Custom VPC for EKS | `devopsshack-vpc` |
| **Subnets** | Public subnets across AZs | `devopsshack-subnet-1`, `devopsshack-subnet-2` |
| **Internet Gateway** | Provides internet access | `devopsshack-igw` |
| **Route Table** | Routes internet traffic | `devopsshack-rt` |
| **EKS Cluster** | Managed Kubernetes control plane | `devopsshack-cluster` |
| **Node Group** | EC2 nodes in cluster | `devopsshack-node-group` |
| **IAM Roles** | Cluster and node permissions | `devopsshack-cluster-role`, `devopsshack-node-role` |

---

## 🧩 Variables

All input variables are defined in [`variables.tf`](./variables.tf) and their values are set in [`terraform.tfvars`](./terraform.tfvars).

| Variable | Description | Example |
|-----------|--------------|----------|
| `region` | AWS region for deployment | `eu-north-1` |
| `profile` | AWS CLI profile to use | `default` |
| `vpc_name` | Name of VPC | `devopsshack-vpc` |
| `vpc_cidr` | VPC CIDR block | `10.0.0.0/16` |
| `availability_zones` | AWS AZs for subnets | `["eu-north-1a", "eu-north-1b"]` |
| `cluster_name` | EKS cluster name | `devopsshack-cluster` |
| `node_group_name` | EKS node group name | `devopsshack-node-group` |
| `instance_type` | EC2 instance type for nodes | `t3.medium` |
| `desired_size` | Number of nodes | `3` |
| `key_pair_name` | EC2 key pair for SSH access | `devops-intern` |

---

## 🏗️ Steps to Create Resources

### 1️⃣ Clone the Repository
```bash
git clone https://github.com/kiranmohite2417/EKS-Terraform.git
cd EKS-Terraform

