# Demo Ansible Project

This is a simple project demonstrating Vagrant and Ansible usage

## Notes

I chose to create my own roles over ansible Galaxy. Using community roles is fine when trying to get a job done fast but you should really be building a role repository of your own, your business doesn't need the additional fluff.

Roles folder is used for packages to be installed and managed and the site-roles folder is used for specific functions E.G (web application, load balancer, database server). This allows use to set sensible defaults at a role level, but then be able to do the same for the hosts function. Then you can use group and host vars to override.

No tags have been added yet, this will need to be done otherwise the full playbook will always execute.

## usage

To get everything running in Vagrant is very straight forward

```bash
vagrant up --provision
```

## To do

- Add php composer
- Add MySQL or MariaDB so we have a backend database
- Add a CMS or a Framework such a laravel
- Add application deployment