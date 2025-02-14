Yes! Here are examples of Terraform's three main provisioners:  

---

## **1. File Provisioner**  
The `file` provisioner copies files or directories from your local machine to a remote instance.  

### **Example: Copy a script to an EC2 instance**  
```hcl
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name      = "my-key"

  provisioner "file" {
    source      = "setup.sh"
    destination = "/home/ubuntu/setup.sh"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/my-key.pem")
    host        = self.public_ip
  }
}
```
**Explanation:**  
- Copies `setup.sh` from the local machine to `/home/ubuntu/` on the EC2 instance.  
- Uses SSH for authentication.  

---

## **2. Local-Exec Provisioner**  
The `local-exec` provisioner runs commands on the machine executing Terraform (your local machine).  

### **Example: Output the public IP of the instance to a file**  
```hcl
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > instance_ip.txt"
  }
}
```
**Explanation:**  
- Runs a command **on the local machine** after the instance is created.  
- Saves the instance's public IP in `instance_ip.txt`.  

---

## **3. Remote-Exec Provisioner**  
The `remote-exec` provisioner runs commands **inside** the created instance using SSH.  

### **Example: Install and start Apache on an EC2 instance**  
```hcl
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name      = "my-key"

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y apache2",
      "sudo systemctl start apache2",
      "sudo systemctl enable apache2"
    ]
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/my-key.pem")
    host        = self.public_ip
  }
}
```
**Explanation:**  
- Runs commands inside the remote instance via SSH.  
- Installs Apache and starts the service.  

---

### **Key Points**
- `file` → Transfers files from local to remote.  
- `local-exec` → Executes commands on the local machine.  
- `remote-exec` → Executes commands inside the remote instance.  

Let me know if you need modifications or further explanations! 🚀
