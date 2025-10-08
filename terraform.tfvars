# --- General ---
region  = "eu-north-1"
profile = "default"

# --- Networking ---
vpc_name            = "devopsshack-vpc"
vpc_cidr            = "10.0.0.0/16"
subnet_count        = 2
availability_zones  = ["eu-north-1a", "eu-north-1b"]
map_public_ip       = true
subnet_name_prefix  = "devopsshack-subnet"
igw_name            = "devopsshack-igw"
route_table_name    = "devopsshack-rt"
route_cidr          = "0.0.0.0/0"

# --- EKS Cluster ---
cluster_name        = "devopsshack-cluster"
cluster_role_name   = "devopsshack-cluster-role"

# --- Node Group ---
node_group_name     = "devopsshack-node-group"
node_role_name      = "devopsshack-node-role"
instance_type       = "t3.medium"

# ✅ Scaling Config — 3 Nodes
desired_size        = 3
max_size            = 3
min_size            = 3

# --- Key Pair ---
key_pair_name       = "devops-intern"

