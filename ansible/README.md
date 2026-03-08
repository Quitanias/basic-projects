Ansible layout and best practices (example)

- `inventory/` - hosts files and environment inventories (production, staging)
- `inventory/group_vars/` - group variables
- `inventory/host_vars/` - per-host variables
- `playbooks/` - top-level playbooks (site.yml, web.yml, db.yml)
- `roles/` - roles with standard layout (`tasks/`, `handlers/`, `defaults/`, `vars/`, `files/`, `templates/`, `meta/`)
- `ansible.cfg` - project-specific Ansible configuration
- `requirements.yml` - Ansible Galaxy role requirements

Usage

Start by running playbook against the inventory defined in `ansible.cfg`:

```bash
cd basic-projects/ansible
ansible-playbook playbooks/site.yml
```

To use a different inventory (e.g., staging):

```bash
ANSIBLE_INVENTORY=inventory/staging/hosts ansible-playbook playbooks/site.yml
```

Add Galaxy roles with:

```bash
ansible-galaxy install -r requirements.yml -p roles/
```
