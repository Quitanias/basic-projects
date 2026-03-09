# Ansible Layout

This Ansible directory manages the post-provisioning configuration of the EC2 instances.

The directory layout follows best practices for Collections and Roles:

- `collections/ansible_collections/quit/core/` - Our custom collection housing the infrastructure roles (`docker`, `nginx`, `firewalld`, etc.)
- `inventory/` - Hosts files and environment inventories.
- `playbooks/` - Top-level playbooks integrating different roles (`app.yml`, `docker.yml`, `nginx.yml`).
- `molecule/` - Isolated testing environment using Docker to validate role idempotency.
- `requirements.txt` / `requirements.yml` - Dependencies for Ansible execution and Molecule testing.

## Usage

You can trigger the main application playbook simply using the Makefile from the root directory:

```bash
cd ..
make test-ansible
# or to run manually against a host
ansible-playbook -i YOUR_IP, playbooks/app.yml
```

### Molecule Testing

To test the `devops.core` roles locally using Docker:

```bash
pip install -r requirements.txt
molecule test
```
