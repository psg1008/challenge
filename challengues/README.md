# Challengue

This project contains all automations needed to perform the challenges

# How to build this project

To execute `terraform` commands successfully, you need to export the next Azure environment variables within your
terminal session with the correct values:

* ARM_CLIENT_ID
* ARM_TENANT_ID
* ARM_CLIENT_SECRET
* ARM_SUBSCRIPTION_ID

```text
# Linux
export ARM_CLIENT_ID=<arm_client_id>
export ARM_TENANT_ID=<arm_tenant_id>
export ARM_CLIENT_SECRET=<arm_client_id>
export ARM_SUBSCRIPTION_ID=<arm_subscription_id>
```

## Requirements

Please install the following requirements with the same version (without them, maybe the project does not work):

* terraform v1.4.3

## Project structure

```text
# challenges (root)
├── CHANGELOG.md
├── README.md
├───modules
│   └───script
└───.github
    └───workflows
```

The root folder (challenges) contains different folders and files needed to build the infrastructure.

The most important are:

* modules: It contains the terraform modules to perform Challenge 2
* script: It contains the script to execute in terraform

## Initializing terraform

```text
cd <terraform_module_folder_path>
terraform init
```

## Planning terraform changes

```text
cd <terraform_module_folder_path>
terraform plan
```

## Applying terraform

```text
cd <terraform_module_folder_path>
terraform apply
```