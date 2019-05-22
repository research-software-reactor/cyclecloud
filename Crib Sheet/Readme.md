# Azure Crib Sheet for Central IT

A set of instructions for Research Software Engineers to provide to central IT around the permissions required to deploy CycleCloud.

## Context

In order to be able deploy clusters, the CycleCloud server needs to be given appropriate permissions.
This can be achieved using Azure Service Principals or Managed Identities.

## Managed Identities

To do this is we need to assign a role to the CycleCloud VM and use [managed identities](https://docs.microsoft.com/en-us/azure/cyclecloud/managed-identities).
Alternatively to the Custom Role defined in the documentation, we can use the standard Contributor Role.
However this requires the user deploying CycleCloud to themselves be an *Owner* in order to assign roles.
This is the approach taken in the ARM template.
Further information and learning resources for [managed identities](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/overview) on Azure.

If you are deploying the template through Azure portal, once the deployment is complete, you will need to assign the role.
Open the Reseource Group that the CycleCloud VM sits in, go to Access Control (IAM), and add *Contributor*, to a VM, and select the CycleCloud server VM.

### Owner

If you are an *Owner* on an institution tenant then you should be able to use the template without issue.  

## Service Principals

Pre-requisites if your owner of the subscription you have full permissions to create Service Principal

Azure CycleCloud requires a service principal with contributor access to your Azure subscription.

The simplest way to create one is using the Azure CLI in Cloud Shell, which is already configured with your Azure subscription:

```
$ az ad sp create-for-rbac --name CycleCloudApp --years 1
{
        "appId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
        "displayName": "CycleCloudApp",
        "name": "http://CycleCloudApp",
        "password": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
        "tenant": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}

```

Save the output -- you'll need the appId, password and tenant. 

### Free Account

If you have a Asure Educate Free Account you should be able to you the template without issue.


### Contributor

If you are a *Contributor* on an institution tenant then you will not be able to complete the deployment as you are unable to assign the role to the CycleCloud VM.
If you experience this then you have two options:

1.  Ask your Azure admins to make you an *Owner* of the Subscription.
2.  Ask your Azure admins to assign the role to the CycleCloud VM directly.

Example scripts for Azure admin to run ...

**NB By granting Contributor role to the VM, users accounts created on the CycleCloud server will be able to launch clusters.** 


## Azure Service Principal

An Azure service principal is a security identity used by user-created apps, services, and automation tools to access specific Azure resources. Think of it as a 'user identity' (username and password or certificate) with a specific role, and tightly controlled permissions. A service principal should only need to do specific things, unlike a general user identity. It improves security if you only grant it the minimum permissions level needed to perform its management tasks.

Service Principal - You may not have the necessary permissions to create a new service principal and need to request a service principal to be created by your IT Team.
The Service Principal Key is only shown at creation so this need to be transferred securely

How to create an Azure Service Principal

If you want to create a new service principal(sp) with Azure CLi 2.0. You could login with your Azure AD user. Then execute following command.

az ad sp create-for-rbac --name {appId} --password "{strong password}"

The result like below:

```
{
  "appId": "a487e0c1-82af-47d9-9a0b-af184eb87646d",
  "displayName": "MyDemoWebApp",
  "name": "http://MyDemoWebApp",
  "password": {strong password},
  "tenant": "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
}
```

appId is your login user, password is login password.

After the sp is created, you also need give it Contributor role, then you could manage your Azure resource.

```
az role assignment create --assignee <objectID> --role Contributor
```

Now, you could login in non interactive mode with following command.

```
az login --service-principal -u <appid> --password {password-or-path-to-cert} --tenant {tenant}
```

## Azure Key Vault

The ideal scenario would be to store this information in an Azure Key Vault such that the secrets could be programmatically added to the relevant files and then locally deleted as necessary.

You can access Key Vault Quickstarts and Tutorials here.https://docs.microsoft.com/en-us/azure/key-vault/

## Key Azure Terminology 

see https://docs.microsoft.com/en-us/azure/azure-glossary-cloud-terminology for a complete list

The following are the key terminology we think you need when discussing Azure with your Subscription Owners

Azure command-line interface (CLI)
- A command-line interface that can be used to manage Azure services from Windows, macOS, and Linux. Some services or service features can be managed only via PowerShell or the CLI. See Azure CLI

Azure PowerShell
- A command-line interface to manage Azure services via a command line from Windows PCs. Some services or service features can be managed only via PowerShell or the CLI. See How to install and configure Azure PowerShell

Azure Resource Manager deployment model
- One of two deployment models used to deploy resources in Microsoft Azure (the other is the classic deployment model). Some Azure services support only the Resource Manager deployment model, some support only the classic deployment model, and some support both. The documentation for each Azure service specifies which model(s) they support.

Geo
- A defined boundary for data residency that typically contains two or more regions. The boundaries may be within or beyond national borders and are influenced by tax regulation. Every geo has at least one region. Examples of geos are Asia Pacific and Japan. Also called geography.

Image
- A file that contains the operating system and application configuration that can be used to create any number of virtual machines. In Azure there are two types of images: VM image and OS image. A VM image includes an operating system and all disks attached to a virtual machine when the image is created. An OS image contains only a generalized operating system with no data disk configurations.

Azure Portal
- The secure web portal used to deploy and manage Azure services.

Region
- An area within a geo that does not cross national borders and contains one or more datacenters. Pricing, regional services, and offer types are exposed at the region level. A region is typically paired with another region, which can be up to several hundred miles away. Regional pairs can be used as a mechanism for disaster recovery and high availability scenarios. Also referred to as location.

Resource
- An item that is part of your Azure solution. Each Azure service enables you to deploy different types of resources, such as databases or virtual machines.

Resource group
- A container in Resource Manager that holds related resources for an application. The resource group can include all of the resources for an application, or only those resources that are logically grouped together. You can decide how you want to allocate resources to resource groups based on what makes the most sense for your organization.

Resource Manager template
- A JSON file that declaratively defines one or more Azure resources and that defines dependencies between the deployed resources. The template can be used to deploy the resources consistently and repeatedly.

- Resource provider
A service that supplies the resources you can deploy and manage through Resource Manager. Each resource provider offers operations for working with the resources that are deployed. Resource providers can be accessed through the Azure portal, Azure PowerShell, and several programming SDKs.

Role
- A means for controlling access that can be assigned to users, groups, and services. Roles are able to perform actions such as create, manage, and read on Azure resources.
See RBAC: Built-in roles

Storage account
- An account that gives you access to the Azure Blob, Queue, Table, and File services in Azure Storage. The storage account name defines the unique namespace for Azure Storage data objects.
See About Azure storage accounts

Subscription
- A customer's agreement with Microsoft that enables them to obtain Azure services. The subscription pricing and related terms are governed by the offer chosen for the subscription. See Microsoft Online Subscription Agreement and How Azure subscriptions are associated with Azure Active Directory

Tag
- An indexing term that enables you to categorize resources according to your requirements for managing or billing. When you have a complex collection of resources, you can use tags to visualize those assets in the way that makes the most sense. For example, you could tag resources that serve a similar role in your organization or belong to the same department.
See Using tags to organize your Azure resources

Virtual machine
- The software implementation of a physical computer that runs an operating system. Multiple virtual machines can run simultaneously on the same hardware. In Azure, virtual machines are available in a variety of sizes.
See Virtual Machines documentation

Virtual machine extension
- A resource that implements behaviors or features that either help other programs work or provide the ability for you to interact with a running computer. For example, you could use the VM Access extension to reset or modify remote access values on an Azure virtual machine.

Virtual network
- A network that provides connectivity between your Azure resources that is isolated from all other Azure tenants. An Azure VPN Gateway lets you establish connections between virtual networks and between a virtual network and an on-premises network. You can fully control the IP address blocks, DNS settings, security policies, and route tables within a virtual network.
See Virtual Network Overview

