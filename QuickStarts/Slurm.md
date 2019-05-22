# Setting up Vanilla Slurm Cluster on Cycle Cloud

This quick start takes through setup and testing a CycleCloud cluster. 

Select the Slurm template and follow the setup instructions.  Choose instance types for the master node and exection nodes appropriate to your needs.

Test your cluster with a submission script `submit.sh` , change the `--ntasks=X` and `srun -nX` as appropriate to your slurm cluster:
```bash
#!/bin/bash
#
#SBATCH --job-name=test
#SBATCH --output=res.txt
#
#SBATCH --ntasks=2
#SBATCH --time=10:00
#SBATCH --mem-per-cpu=100

srun -n2 echo "Hello world!" > output.txt
```

Log-in to the master node and submit the job `sbatch submit.sh`.  With `squeue` you should see your job queued, and see and execute instance start up in the CycleCloud Web Portal.  Once the execute instance is up the job will run.  If you keep the defaults in the template when creating the cluster the execute will automatically shut down after a period (5 minutes?) of inactivity. 

## Pre-Requisites

This sample requires the following:

- CycleCloud must be installed and running.

## IMPORTANT

If your master/execution nodes do not start correctly you may be experiencing one of the following:

- Resource allocation quota exceeded, if you are on a free pass you may be requesting more resource than permiited.  Try using smaller instance types.
- Your subscription may have a limit on the size instances you can use. Try using smaller instances.
- The VM may not be available in your region/location. Create a CycleCloud cluster in a region with the instance type or choose a different instance type.

