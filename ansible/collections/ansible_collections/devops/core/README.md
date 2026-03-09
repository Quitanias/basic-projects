# devops.core Collection

This Ansible collection bundles several roles for managing basic infrastructure components on EL-based systems (Amazon Linux 2023). 

## Roles included:

- `docker` – installs and starts Docker.
- `firewalld` – installs and configures system firewall rules.
- `fluentbit` – installs Fluent Bit logging agent.
- `node_exporter` – installs Prometheus node exporter for monitoring.
- `nginx` – deploys Nginx web server and basic routing.
- `user` – creates a devops user and injects SSH keys.

## Usage

In playbooks, reference roles using their fully-qualified collection name (FQCN):

```yaml
- hosts: web
  roles:
    - role: devops.core.nginx
```

Collections are stored under `basic-projects/ansible/collections/ansible_collections/quit/core`. They are automatically loaded since they exist locally.
