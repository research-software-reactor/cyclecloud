# Installing Dask using CycleCloud Projects

## Set Up a New Project

If you completed the tutorial on modifying cluster templates, you should already have a `cyclecloud_projects` sub-directory in your home directory. If not, create this directory now with the `mkdir` command. This directory can be used as the base directory for all projects. Go into the directory and initialize a new project named `dask`. Specify azure-storage as the default locker.

    cd cyclecloud_projects
    cyclecloud project init dask

Move into the new project directory. It will contain three sub-directories, one for each component of a CycleCloud project: `blobs`, `specs`, and `templates`. A `project.ini` file containing project properties is also created.


## Stage the Dask Installer

Set `V` to the appropriate value and download the Dask installation file:

    $ V=1.2.2; wget -O blobs/dask-${V}.tar.gz https://github.com/dask/dask/archive/${V}.tar.gz

Edit `projects.ini` to add the `dask` installer blob

    [project]
    version = 1.0.0
    type = application
    name = dask

    [blobs]
    files = dask-1.2.2.tar.gz

The addition to the `project.ini` file defined the project type as application and the location of the required installation file within the blobs directory. Save the file and exit the editor.

# Specs

The specs directory contains specifications of a project, and can contain one or more specs. For example, a project may have a default spec that contains configurations steps meant to be performed on every node of a cluster, and also a master spec that contains scripts meant to only be invoked on the cluster's headnode.

A default spec is automatically created in each new CycleCloud project. Within each spec are two sub-directories: chef and cluster-init

The `chef` directory holds Chef cookbooks and recipes that can be used in configuring nodes.

The `cluster-init` directory contains three sub-directories: `files`, `scripts`, and `tests`.

* **files** contains small files that are downloaded into every cluster node using this spec.
* **scripts** has collections of scripts that are executed on each node using this spec when the node boots.
* **tests** contains test scripts used to validate the successful deployment of a spec.

## Create new script

Create a new script named `10.install_pypkgs.sh` inside the `default/cluster-init/scripts` directory.

    cat << EOF > ./default/cluster-init/scripts/10.install_pypkgs.sh
    #!/bin/bash
    set -ex

    # Set here the pip installable package names
    PY_PACKAGES=dask

    # make a /mnt/resource/apps directory
    # Azure VMs that have ephemeral storage have that mounted at /mnt/resource. If that does not exist this command will create it.
    mkdir -p /mnt/resource/apps

    # Make sure pip is installed
    yum -y install python-pip

    # Install python packages

    # make sure we install on the system not inside the jetpack environment
    export PATH=/usr/bin:${PATH}

    pip install ${PY_PACKAGES}
    EOF

## Make sure CycleCloud Configuration exists

The following commands will ensure that `~/.cycle/config.ini` exists and it is properly configured:

    $ cyclecloud initialize --force
    CycleServer URL: [http://localhost:8080] https://localhost
    Detected untrusted certificate.  Allow?: [yes]
    CycleServer username: [paul]
    CycleServer password:
    
    Generating CycleServer key...
    Initial account already exists, skipping initial account creation.
    CycleCloud configuration stored in /home/paul/.cycle/config.ini

Use your `super-user` name instead of `paul` in the above.

## Upload the Project

First check your storage name:

    $ cyclecloud locker list
    azure-storage (az://cyclecloudjiitrabwsxjktm/cyclecloud)

then use it to upload your work

    $ cyclecloud project upload azure-storage
    Uploading to az://cyclecloudjiitrabwsxjktm/cyclecloud/projects/dask/1.0.0 (100%)
    Uploading to az://cyclecloudjiitrabwsxjktm/cyclecloud/projects/dask/blobs (100%)
    Upload complete!

Finally, make sure it is readable by others. You can change that in the GUI and test it with `pogo ls`:

   $ pogo ls -lR az://cyclecloudjiitrabwsxjktm/cyclecloud

you should see the contents of the `cyclecloud-dask` project in there.

## The Template

Start from an existing template like the NVidia `cyclecloud` [project](https://github.com/Azure/cyclecloud-nvidia-gpu-cloud/blob/master/templates/sge-nvidia-gpu-cloud.txt).

The key places to be careful about are

* definition

      [cluster DASK]
      FormLayout = selectionpanel
      IconUrl = http://docs.dask.org/en/latest/_images/dask_stacked.svg
      Category = Schedulers

* path to default, master, and execute initialziation

      [[node defaults]]
        [[[cluster-init dask:default]]]`
        ...
      [[node master]]
        [[[cluster-init dask:default]]]
        ...
       
      [[nodearray execute]]
        [[[cluster-init dask:execute]]]

* about

      [parameters About]
        Order = 1
        [[parameters About Dask]]
          [[[parameter dask]]]
          HideLabel = true
          Config.Plugin = pico.widget.HtmlTemplateWidget
          Config.Template := "<table><tr><td><img src='...' width='192' height='192'></td></tr><tr><td><p>Description.</p></td></tr></table>"

## Importing and Deleting the Template

In order to get the `dask` template in the `cyclecloud cluster` run the following command:

    cyclecloud import_template dask -c "DASK" -f templates/dask.txt

If later on you decide to remove it, just do:

    cyclecloud delete_template DASK

# See Also

The end result is available on [Github](https://github.com/pirofti/cyclecloud-dask).
