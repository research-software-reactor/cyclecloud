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

The ideal scenario would be to store this information in an Azure Key Vault such that the secrets could be programmatically added to the relevant files and then locally deleted as necessary. However, this falls out of the scope of a BinderHub workshop.

You can access Key Vault Quickstarts and Tutorials here.


