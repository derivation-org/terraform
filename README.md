# Terraform-Automated AKS Deployment with Advanced DevOps Integration

## Description

Streamlined AKS deployment using Terraform, integrating advanced networking, security, and monitoring. Implements CI/CD for efficient cloud-native operations.

## Details

1. Employed Terraform for Infrastructure as Code (IaC) to provision and manage Azure Kubernetes Service (AKS) and associated resources, ensuring reusable infrastructure and adherence to best practices.

2. Configured Terraform Cloud to manage and synchronize infrastructure with the Github repository, along with enabling Single Sign-On (SSO) via Azure.

3. Deployed Cilium as the Container Network Interface (CNI) for AKS to enforce fine-grained networking policies, enhancing security.

4. Configured essential Kubernetes services including CertManager for automatic HTTPS certificates, External-DNS for dynamic DNS updates, and Ingress-Nginx for traffic routing management.

5. Implemented External Secrets Operator for external secret management configured with Azure Key Vault.

6. Integrated Kyverno to enforce cluster policies and best practices.

7. Configured ArgoCD to manage and synchronize application status from Git, enabling automatic deployments and enabled ArgoCD login for Github Organization mememebers.

8. Configured Azure Container Registry as the image repository.

9. Established a CI/CD pipeline using GitHub Actions to build and push images to Azure Container Registry upon code changes, then automatically updating Kubernetes manifests for automated deployment by ArgoCD.

10. Implemented comprehensive Role-Based Access Control (RBAC) and security policies to control deployment processes and access permissions within both Kubernetes and Azure.

11. Configured Azure Managed Prometheus for metric collection and Azure Managed Grafana for visualization, integrated with Azure Monitor workspace for AKS monitoring.

12. Ensured high availability and scalability of the Kubernetes cluster to prevent downtime, enabling the system to efficiently manage varying workloads and maintain continuous availability.

13. Optimized processes for rapid provisioning of the entire stack—AKS, supporting services, and applications—ensuring full operation within 10 minutes of initiation.

## Application Repository

For the application code and CI/CD pipeline implementation, please refer to the dedicated repository:

[App and CI/CD Repository](https://github.com/derivation-org/custom-app)

This repository contains our application code and CI/CD pipeline. GitHub Actions automate building and pushing Docker images to Azure Container Registry, and updating Kubernetes manifests. ArgoCD monitors these changes, automatically deploying updates to our AKS cluster for swift and consistent deployments.
