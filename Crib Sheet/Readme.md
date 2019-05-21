# Azure Crib Sheet for Central IT

A set of instructions for Research Software Engineers to provide to central IT around the permissions required to deploy CycleCloud.

## Context

In order to be able deploy clusters, the CycleCloud server needs to be given appropriate permissions.
The simplest way to do this is to assign a role to the CycleCloud VM and use [managed identities](https://docs.microsoft.com/en-us/azure/cyclecloud/managed-identities).
Alternatively to the Custom Role defined in the documentation, we can use the standard Contributor Role.
However this requires the user deploying CycleCloud to thenselves be an *Owner* in order to assign roles.

## Contributor

If you are a *Contributor* on an institution tenant then you will not be able to complete the deployment as you are unable to assign the role to the CycleCloud VM.
If you experience this then you have two options:

1.  Ask your Azure admins to make you an *Owner* of the Subscription.
2.  Ask your Azure admins to assign the role to the CycleCloud VM directly.

**NB By granting Contributor role to the VM, users accounts created on the CycleCloud server will be able to launch clusters.** 


## Owner

If you are an *Owner* on an institution tenant then you should be able to use the template without issue.  

## Free Account

If you have a Asure Educate Free Account you should be able to you the template without issue.

