
# Architecture Overview

The solution follows the Hub-and-Spoke network model, commonly used in enterprise cloud environments.

Hub resources centralize security, monitoring, and connectivity while spoke networks host application workloads.

## 📊 Architecture Diagram
![ERP Azure Architecture](https://github.com/jkaljokey-hub/Hub-Spoke-Iac/blob/main/assert/bicep.jpeg?raw=true)

### Hub VNet

Azure Firewall for centralized traffic inspection

Azure Bastion for secure VM access

Log Analytics Workspace for monitoring and diagnostics

Route tables and user-defined routing

Spoke VNets

Application and staging networks

Virtual machines without public IPs

Network Security Groups (NSGs)

Route tables directing traffic through the firewall

### Key Features

✔ Fully automated infrastructure deployment using Bicep

✔ Hub-and-Spoke network architecture

✔ VNet Peering between hub and spokes

✔ Centralized security with Azure Firewall

✔ Secure VM access through Azure Bastion

✔ User Defined Routes (UDR) for traffic control

✔ Centralized monitoring using Log Analytics Workspace

✔ NSG Flow Logs and diagnostic settings

### Architecture Diagram

(Add your architecture diagram image here)

Example:

Hub VNet

 ├── Azure Firewall
 
 ├── Azure Bastion
 
 ├── Log Analytics Workspace
 
 │
 
 ├── VNet Peering
 
 │
 
 ├── Spoke VNet – Production
 
 │     ├── VM
 
 │     ├── NSG
 
 │     └── Route Table
 
 │
 
 └── Spoke VNet – Staging
   ├── VM       
   
   ├── NSG
   
   └── Route Table

### Technologies Used

Microsoft Azure

Bicep

Azure Firewall

Azure Bastion

Azure Monitor

Log Analytics

Visual Studio Code

### Deployment
1 Clone the repository 

git clone https://github.com/jkaljokey-hub/Hub-Spoke-Iac.git

cd your-repository-name

2 Login to Azure

az login

3 Deploy the infrastructure
az deployment group create \
--resource-group bk-group \
--template-file main.bicep
Monitoring Configuration

### The deployment enables diagnostics for:

Azure Firewall logs

Bastion audit logs

NSG flow logs (v2)

Route table diagnostics

All logs are sent to Log Analytics Workspace for centralized monitoring and analysis.

### Learning Objectives

This project demonstrates practical experience with:

Azure enterprise network design

Infrastructure as Code

Secure cloud architecture

Centralized network security

Cloud monitoring and diagnostics

### Author

Abubakar Alnour

Azure Administrator | AZ-104 Certified | Infrastructure as Code (Bicep)

LinkedIn
https://linkedin.com/in/abubakar-alnour

Portfolio
https://abubakar-portfilo.netlify.app

GitHub
https://github.com/jkaljokey-hub
