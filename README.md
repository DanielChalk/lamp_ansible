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

Alternatively you can use AWS with terraform, you will of course neen to make sure
you have access keys setup and a key to be used to provision the hosts. If you're
using windows, it's best to use the controller vagrant box to provision AWS with
Ansible.

```bash
# apply terraform and use your own ssh key_name so you can ssh into the hosts
terraform apply -var "key_name=$AWS_KEY"
# you will need to make you're inventory reflect the hosts, we can automate this
# no time for that at the moment though.
vi inventory/aws.ini
# provision the nodes
ansible-playbook -i inventory/aws.ini main.yml
```

## To do

- Add php composer
- Add MySQL or MariaDB so we have a backend database
- Add a CMS or a Framework such a Laravel
- Add application deployment
