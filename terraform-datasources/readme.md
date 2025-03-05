
This Terraform code automates the creation of a **cloud infrastructure setup on AWS**, including a **VPC**, **subnets**, **EC2 instances**, and **networking components**. 
---

### **What This Code Does**:
1. **Creates a VPC**:  
   - Sets up a virtual private cloud (VPC) with the CIDR block `10.0.0.0/16`.

2. **Creates Subnets**:  
   - **Public Subnet**: Hosts resources that need internet access (e.g., EC2 instances with public IPs).  
   - **Private Subnet**: Hosts resources that should not be directly accessible from the internet.

3. **Sets Up Networking**:  
   - Creates an **Internet Gateway** for public internet access.  
   - Configures **Route Tables** for public and private subnets to control traffic flow.  
   - Associates subnets with their respective route tables.

4. **Launches EC2 Instances**:  
   - Deploys EC2 instances in the **public subnet**.  
   - Assigns specific **private IPs** and **tags** (e.g., "master" or "worker") to each instance.  
   - Uses **user data** to configure instances (e.g., `master-user-data.sh` for master nodes and `worker-user-data.sh` for worker nodes).  

5. **Creates a Key Pair**:  
   - Generates an SSH key pair for secure access to the EC2 instances.

---

### **Key Features**:
- **Infrastructure as Code (IaC)**: The entire setup is defined in code, making it repeatable and scalable.  
- **Automation**: Automates the creation of VPC, subnets, EC2 instances, and networking components.  
- **Customization**: Allows for specific configurations like private IPs, instance types, and user data scripts.  
- **Security**: Uses security groups and private/public subnets to control access.  

---

### **Visual Flow**:
1. **VPC** → **Subnets** (Public & Private) → **Route Tables** → **Internet Gateway**.  
2. **EC2 Instances** → Deployed in the **Public Subnet** → Configured with **User Data**.  
3. **Key Pair** → Created for secure SSH access.  

---

### **Why It Matters**:
- **Efficiency**: Automates cloud infrastructure setup, saving time and reducing errors.  
- **Scalability**: Easily scale up or down by modifying the code.  
- **Consistency**: Ensures the same setup every time it’s deployed.  

This code is a great example of how **Terraform** can be used to manage **AWS infrastructure** in a structured and automated way! 🚀
