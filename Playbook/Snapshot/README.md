# VM Snapshot Ansible Playbooks

This directory contains Ansible playbooks to create and delete virtual machine snapshots on VMware vSphere and OpenShift Virtualization platforms.

## Structure

```
.
├── create_snapshot.yml
├── delete_snapshot.yml
├── README.md
├── tasks
│   ├── create_openshift_snapshot.yml
│   ├── create_vmware_snapshot.yml
│   ├── delete_openshift_snapshot.yml
│   └── delete_vmware_snapshot.yml
└── vars
    └── main.yml
```

- **`create_snapshot.yml`**: Main playbook to create a VM snapshot.
- **`delete_snapshot.yml`**: Main playbook to delete a VM snapshot.
- **`vars/main.yml`**: Contains default variables. You should override these values.
- **`tasks/`**: Contains the platform-specific logic, included by the main playbooks.

## Prerequisites

- Ansible 2.10+
- For VMware: `community.vmware` collection (`ansible-galaxy collection install community.vmware`)
- For OpenShift: `kubevirt.core` collection (`ansible-galaxy collection install kubevirt.core`)
- Access to either a VMware vCenter or an OpenShift cluster with KubeVirt installed.

## Variables

The playbooks use variables defined in `vars/main.yml`. These should be overridden at runtime using `--extra-vars` or through an Ansible Automation Platform (AAP) survey.

### Common Variables

| Variable                  | Required | Description                                                  | Example                               |
| ------------------------- | -------- | ------------------------------------------------------------ | ------------------------------------- |
| `virtualization_platform` | Yes      | Target platform. Must be `vmware` or `openshift`.            | `vmware`                              |
| `vm_name`                 | Yes      | The name of the virtual machine.                             | `my-web-server`                       |
| `snapshot_name`           | Yes      | The name for the snapshot to be created or deleted.          | `pre-patch-snapshot-20231027`         |

### VMware-specific Variables

These are required when `virtualization_platform` is `vmware`.

| Variable               | Required | Description                                                  | Example                 |
| ---------------------- | -------- | ------------------------------------------------------------ | ----------------------- |
| `vcenter_hostname`     | Yes      | Hostname or IP of the vCenter server. (Best passed via credential) | `vcenter.mycorp.com`    |
| `vcenter_username`     | Yes      | Username for vCenter. (Best passed via credential)           | `administrator@vsphere.local` |
| `vcenter_password`     | Yes      | Password for vCenter. (Best passed via credential)           | `MySecretPassword`      |
| `vcenter_datacenter`   | Yes      | The name of the vCenter Datacenter containing the VM.        | `MyDatacenter`          |
| `snapshot_description` | No       | A description for the snapshot.                              | `Snapshot before patching` |

### OpenShift-specific Variables

These are required when `virtualization_platform` is `openshift`.

| Variable       | Required | Description                                             | Example         |
| -------------- | -------- | ------------------------------------------------------- | --------------- |
| `vm_namespace` | Yes      | The OpenShift project/namespace where the VM is located. | `my-vm-project` |

## Usage

### Command Line (with extra-vars)

#### Create a VMware Snapshot

```bash
ansible-playbook create_snapshot.yml --extra-vars "virtualization_platform=vmware vcenter_hostname=... vcenter_username=... vcenter_password=... vcenter_datacenter=... vm_name=my-vm snapshot_name=my-snapshot"
```

### Ansible Automation Platform (AAP)

1.  Create a new Project pointing to this Git repository.
2.  Create Machine credentials for vCenter and Kubernetes API.
3.  Create a Job Template for `create_snapshot.yml` or `delete_snapshot.yml`.
4.  Attach the appropriate credentials to the Job Template.
5.  Enable and configure a Survey to prompt for variables like `virtualization_platform`, `vm_name`, `snapshot_name`, etc. This makes the playbook self-service.