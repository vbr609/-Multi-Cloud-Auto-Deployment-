# **Multi-Cloud Deployment Project** 🚀

## **Introduction** 🌐
This project demonstrates the **automation of infrastructure provisioning** and **application deployment** across **AWS** and **Azure** using **Terraform** and **Ansible**. The goal is to enable seamless deployment of an **ASP.NET Core application** across multiple cloud platforms, leveraging robust **CI/CD pipelines** in **Azure DevOps**.

## **Problem Statement** 🤔
Organizations face several challenges when deploying applications across cloud providers like **AWS** and **Azure**:  
- Ensuring consistent infrastructure management.  
- Handling dynamic inventory updates for scaling and maintenance.  
- Implementing secure and automated deployment processes.

## **Solution** 💡
This project addresses these challenges by:  
1. **Using Terraform** for consistent and automated infrastructure provisioning.  
2. **Leveraging Ansible** to automate server configurations and application deployment.  
3. **Integrating CI/CD pipelines** with Azure DevOps for seamless workflows and deployments.

## **Features** ✨
- **Infrastructure-as-Code (IaC):** Automated provisioning of cloud resources using Terraform.  
- **Cross-Cloud Deployment:** Simultaneous deployment to AWS and Azure.  
- **Configuration Management:** Dynamic inventory creation and server configuration via Ansible.  
- **CI/CD Integration:** Automated end-to-end pipelines in Azure DevOps.  
- **Secure & Scalable:** Uses SSH for secure communication and enables effortless scalability.

## **Tools & Technologies Used** 🛠️

### **1. Terraform**
- **Purpose:** Provision infrastructure on AWS and Azure.  
- **Features:**  
  - State management using Azure Blob Storage.  
  - Automated creation of compute, network, and security resources.  
- **Highlights:**  
  - Provisions AWS EC2 instances and Azure VMs with required security rules.

### **2. Ansible**
- **Purpose:** Configuration management and application deployment.  
- **Features:**  
  - Automates secure SSH setup and `.NET` application deployment.  
  - Generates dynamic inventory to manage nodes across multiple clouds.

### **3. Azure DevOps**
- **Purpose:** Manage CI/CD pipelines.  
- **Features:**  
  - Multi-stage pipelines for building, provisioning, and deploying.  
  - Artifact management for `.NET` applications.  
  - Secure file handling to manage secrets, tokens, and SSH keys.  
  - Service connections to Azure and AWS for seamless authentication.

### **4. Azure Entra ID**  
- **Purpose:** Identity and access management.  
- **Features:**  
  - App registration for secure API communication.  
  - Role-based access control (RBAC) for managing infrastructure and pipelines.  
  - Authentication and authorization for CI/CD workflows.

### **5. ASP.NET Core**
- **Purpose:** Backend application for deployment.  
- **Features:**  
  - Runs on **port 5000** on AWS and Azure instances.  
  - Deployed as a Linux service for high availability.

## **Architecture Diagrams** 🖼️

### **High-Level Design**  
Illustrates CI/CD integration with multi-cloud infrastructure.  
<img width="653" alt="2024-12-31 20_51_25-Multi-cloud drawio (5)" src="https://github.com/user-attachments/assets/0dd73180-94ac-44d6-8300-236b4436b868" />


## **Prerequisites** ✅
- **Azure DevOps Account:** For managing CI/CD pipelines.  
- **AWS Account:** For provisioning AWS resources.  
- **Azure Subscription:** For deploying Azure resources.  
- **Terraform & Ansible:** Installed locally for testing.  
- **SSH Key Pair:** For secure remote connections.  
- **Azure DevOps Self-Hosted Agent:** To execute Ansible tasks on remote nodes.

## **Step-by-Step Guide** 🪜

### **1. Set Up Terraform Backend**
- Configure **Azure Blob Storage** as the backend to securely store the Terraform state file.

### **2. Build Application and Publish Artifact**
- Use the Azure DevOps pipeline to build and package the ASP.NET Core application.  
- Publish the build artifact to Azure Pipelines.

### **3. Provision Infrastructure**
- **AWS:**  
  - Launch EC2 instances.  
  - Configure security groups to open ports for SSH and application access.  
- **Azure:**  
  - Provision Virtual Machines.  
  - Associate Network Security Groups (NSGs) to open necessary ports.  

### **4. Configure CI/CD Pipelines**
- **Build Pipeline (Microsoft-hosted agent):** Builds the ASP.NET Core application.  
- **Terraform Pipeline (Microsoft-hosted agent):** Provisions infrastructure.  
- **Ansible Pipeline (Self-hosted agent):** Deploys the application.

### **5. Use Ansible for Configuration Management**
- Dynamically generate inventory using Python scripts.  
- Add VMs to the `known_hosts` file for secure SSH communication.  

### **6. Deploy the Application**
- Use Ansible playbooks to:  
  - Deploy the ASP.NET Core application.  
  - Configure it to run as a Linux service on **port 5000**.

## **How It Works** 🛠️
1. **CI/CD Pipelines:**  
   - Code is pushed to the `main` branch.  
   - Azure DevOps triggers build, provisioning, and deployment workflows.

2. **Terraform Scripts:**  
   - Provision AWS and Azure infrastructure.  
   - Configure security rules for application access.

3. **Ansible Playbooks:**  
   - Configure VMs, install dependencies, and deploy the application.  
   - Manage dynamic inventory using Python scripts.

4. **Dynamic Inventory:**  
   - Automates IP discovery and SSH key management for seamless scaling.

## **Challenges Faced** 💪
- Managing Terraform state files in a multi-cloud environment.  
- Debugging Ansible scripts for dynamic inventory creation.  
- Establishing passwordless SSH authentication on ephemeral agents.  
- Configuring the application to run as a background service for production readiness.  

## **Learnings** 🌿
- Importance of **secure secrets management** in CI/CD pipelines.  
- Using **Terraform** to manage multi-cloud infrastructure efficiently.  
- Leveraging **Azure Entra ID** for app registration and RBAC.  
- Benefits of self-hosted agents for running Ansible tasks.  

## **Potential Enhancements** 🚀
- Add Kubernetes support for containerized application deployment.  
- Implement monitoring with tools like **Prometheus** and **Grafana**.  
- Use a load balancer for efficient traffic distribution.  
- Explore cost optimization with **FinOps** practices.
---
