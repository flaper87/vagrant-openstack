vagrant-openstack
=================

Vagrant [OpenStack](http://www.openstack.org) Provider

This is a [Vagrant](http://www.vagrantup.com) 1.1+ plugin that adds an [OpenStack](http://www.openstack.org) provider to Vagrant, allowing Vagrant to control and provision machines in OpenStack.

NOTE: This plugin requires Vagrant 1.1+, which is still unreleased. Vagrant 1.1 will be released soon. In the mean time, this repository is meant as an example of a high quality plugin using the new plugin system in Vagrant.

## Commands Support

* up
* destroy
* status
* ssh


## Usage

Install using standard Vagrant 1.1+ plugin installation methods. After installing, `vagrant up` and specify the `openstack` provider. An example is shown below.


```
$ vagrant plugin install vagrant-openstack
...
$ vagrant up --provider=openstack
...
```

## Quick Start

Create a Vagrantfile and put a section like this, adapting it to your environment.

```
config.vm.provider :openstack do |os|
  os.url = "http://127.0.0.1:5000/v2.0/"
  os.tenant = "my_tenant"
  os.user = "my_user"
  os.password = "super_password"

  os.flavor = "1"
  os.keypair = "my_key"
  os.image = "b9b3f324-80d2-4413-89ec-3d299ceb8279"

  os.name = "test"
  os.ssh_username = "my_cool_user"
  os.ssh_private_key = "~/not_custom_path/super_private"
end
```

## Configuration


* url: OpenStack's auth url
* tenant: OpenStack's tenant to use
* user: OpenStack's auth username
* password: OpenStack's password for `username`

* name: Instance's name. It'll be assigned to it during the first boot.
* image: Glance's image id to use. (It doesn't support names)
* flavor: Nova's flavor to use for the new instance.
* keypair: Keypair that should be associated to the new instance.

* ssh_port: SSH port to used (Default 22)
* ssh_username: SSH username
* ssh_private_key: Local private key to be used for ssh connections. (Default ~/.ssh/id_rsa)

## Development

To work on the `vagrant-openstack` plugin, clone this repository out, and use
[Bundler](http://gembundler.com) to get the dependencies:

```
$ bundle
```

You can test the plugin without installing it into your Vagrant environment by just creating a `Vagrantfile` in the top level of this directory (it is gitignored) that uses it, and uses bundler to execute Vagrant:

```
$ bundle exec vagrant up --provider=openstack
