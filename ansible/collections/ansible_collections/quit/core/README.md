# quit.core Collection

This Ansible collection bundles several roles for managing basic infrastructure components on EL-based systems. Roles included:

- `docker` – install and start Docker
- `firewalld` – install and configure firewall
- `fluentbit` – install Fluent Bit logging agent
- `node_exporter` – install Prometheus node exporter
- `nginx` – deploy Nginx web server and website
- `user` – create a devops user and add SSH key

## Usage

In playbooks reference roles using their fully-qualified collection name (FQCN):

```yaml
- hosts: web
  roles:
    - name: quit.core.nginx
```

Collections are stored under `basic-projects/ansible/collections/ansible_collections/quit/core` and can be built with `ansible-galaxy collection build`.
