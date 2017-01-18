# Demo Ansible Project

This is a simple project demonstrating Vagrant and Ansible usage

## Notes

I chose to create my own roles over ansible Galaxy. Using community roles is fine when trying to get a job done fast but you should really be building a role repository of your own, your business doesn't need the additional fluff.

Roles folder is used for packages to be installed and managed, and the site-roles folder is used for specific functions E.G (web application, load balancer, database server). This allows us to set sensible defaults at a role level, but then be able to do the same for the hosts function, then you can use group and host vars to override.

Roles should eventually be put into their own repos and managed by Galaxy as dependencies

There is some limited tag usage.

## usage

### Vagrant
To get everything running in Vagrant is very straight forward. We use the ansible_local provisioner to avoid on windows workstations.

```bash
vagrant up --provision
```

### Terraform

You will need the AWS client and terraform installed, and a working ssh key added to EC2.

If you're using windows, it's best to use the ctl-1 vagrant box to provision AWS with
Ansible.

```bash
# apply terraform and use your own ssh key_name so you can ssh into the hosts
terraform apply -var "key_name=$AWS_KEY"
# you will need to make you're inventory reflect the hosts, we can automate this
# with a script, though there's no time for that at the moment.
vi inventory/aws.ini
# provision the nodes
ansible-playbook -i inventory/aws.ini main.yml
```

## To do

- Add php composer
- Add MySQL or MariaDB so we have a backend database
- Add a CMS or a Framework such a Laravel
- Add application deployment
