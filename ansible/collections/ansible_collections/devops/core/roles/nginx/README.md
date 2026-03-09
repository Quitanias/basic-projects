# devops.core.nginx

This role is responsible for installing and configuring the Nginx web server on Amazon Linux 2023 instances.

## Requirements

No special prerequisites are required outside of standard RedHat/AmazonLinux repositories.

## Role Variables

Currently, there are no mandatory variables for `devops.core.nginx`. Any future custom configurations (e.g., custom ports or server names) will be defined in `defaults/main.yml`.

## Dependencies

This role has no external dependencies.

## Example Playbook

```yaml
- hosts: web
  become: true
  roles:
     - role: devops.core.nginx
```

## License

MIT
