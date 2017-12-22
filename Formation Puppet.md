<style>
   
:root{
    --smile-blue: #3B80FF;
    --smile-orange: #ff7f54;
}

@media print {
    body {
        background-color: var(--smile-orange) !important;
    }
}

.reveal .slide-background {
    background-color: var(--smile-orange) !important;
    background-image: url(https://www.smile.eu/themes/custom/smileeu/assets/images/icons/logo_smile.png);
    background-repeat: no-repeat;
    background-size: 20%;
    background-position: 0 0;
}

.reveal h1, .reveal h2, .reveal h3 {
    color: var(--smile-blue) !important
}

.reveal p, .reveal li {
    color: white !important
}

.reveal p img {
    border: none;
    box-shadow: none;
    background-color: transparent;
}

</style>

# Formation Puppet

```puppet
class {'install::config_management_system':
    package {
        ['puppet', 'hiera', 'facter', 'puppetdb']:
            ensure  => installed;
        ['chef', 'ansible']:
            ensure => absent;
    }
}
```

---

Puppet is a configuration management tool that is extremely powerful in deploying, configuring, managing, maintaining, a server machine.

---

## Why using a configuration management tool ?

---

### Traditional system administration
- Group and user creation
```bash
if ["getent group sysadmin | awk -F: '{print $1}'" == ""]
then
    groupadd sysadmin
fi
if [0 -ne $(getent passwd foo > /dev/null)$?] then
    useradd foo --gid sysadmin -n
fi
GID=`getent passwd foo | awk -F: '{print $4}'`
GROUP=`getent group $GID | awk -F: '{print $4}'`
if ["$GROUP" != "$GID"] && ["$GROUP" != "sysadmin"] then
    usermod --gid $GROUP $usermod
fi
```

---

### Traditional system administration
- Apache installation
```bash
# One host
ssh user@server
# - Debian
apt-get install apache2
vi /etc/apache2/apache2.conf
service apache2 restart
# - RedHat
yum install httpd
vi /etc/httpd/conf/httpd.conf
systemctl restart httpd
```

---

### What's wrong with that ?
- What if we have 500 servers ?
- What if we have mixed Linux distribution ?
- What if we have 10 more services to manage on the machine ?

---

## Why Puppet ?
- Declarative language
- Define good **known** machine state
- Saves time
- Documentation
- Handle multiple OS

---

## How it looks like ?
- Group and user creation
```puppet
group {'sysadmin':
    ensure => present,
}

user {'foo':
    ensure => present,
    gid    => 'sysadmin',
}
```

---

## How it looks like ?
- Apache installation
```puppet
$apache_server = $::operatingsystem ? {
    Centos  => 'httpd',
    Debian  => 'apache2',
}

package { $apache_server:
    ensure => 'present',
    alias  => 'apache_server',
}

file { '/var/www/html/index.html':
    source  => 'puppet:///modules/apache/index.html',
    require => Package['apache_server'],
}
```

---

## How Puppet works

![](http://theokadmin.us/wordpress/wp-content/uploads/2014/06/Puppet.Labs_.Enforce.Desired.State_.png "Puppet Lifecycle")

---

## Idempotency
- Puppet only changes resources or attributes that are out of sync
- Produces the same end result, no matter how many times Puppet is run
- Describes the **FINAL** state, rather than a series of steps to follow

---

## Running Puppet
- Apply
- Agent

---

## Puppet Resources
- Resources are the main object in Puppet configuration
- They can be combined to create larger components
- They model the expected state of your system
- `puppet resource --types`

---

## Resource Abstraction Layer

![](http://docplayer.net/docs-images/27/10101151/images/24-0.png)

The Pupper RAL is what allows you to write a manifest that works on several different platforms without having to remember if you should invoke `apt-get install` or `yum install`.

---

## Relationships - Metaparameters

- `before`
- `require`
- `notify`
- `subscribe`

---

## Relationships - Chaining

```puppet
package { 'openssh-server':
    ensure => installed,
}
-> # then:
file { '/etc/ssh/sshd_config':
    ensure => file,
    mode => '0600',
    source => 'puppet:///modules/sshd/sshd_config',
}
~> # and then:
service { 'sshd':
    ensure => running,
    enable => true,
}
```

---


## Variables
- Variables store values so they can be accessed later
- Puppet only allows a given variable to be assigned once within a given **scope**

```puppet
# Assigning variables
$content = "some content"
# Arrays
$a = [1, 2, 3] # $a[0] = 1
# Hashes
[$a, $b] = {a => 10, b => 20} # $a = 10; $b = 20
```

---

- Accessing out-of-scope variables
    - You can access out-of-scope variables from named scopes by using their qualified names: 

```puppet
$vhostdir = $apache::params::vhostdir
```

- Note that the top scope's name is the empty string -- thus, the qualified name of a top scope variable would be, e.g., ```$::osfamily```.

---

## Variables examples

```puppet
class system {
    $operatingsystem = "MyOS"
    notify { "The OS is : ${operatingsystem}": }
}

# Notice: The OS is MyOS

class truesystem {
    $operatingsystem = "MyOS"
    notify { "The OS is : ${::operatingsystem}": }
}

# Notice: The OS is Ubuntu
```

---

## Facts

Puppet use facts to get information about the node (like the hostname, or the IPv4 address, etc...). 
```
> facter operatingsystem
Ubuntu
```

:computer:

---

## Templates

- Templates are written in ERB syntax.
- Templates are calculated at every Puppet run.

```
# vhost.conf.erb
server {
  listen 80;
  root /var/www/<%= @site_name %>;
  server_name <%= @site_domain %>;
}
```

```puppet
# site.pp
$site_name = 'smile'
$site_domaine = 'smile.fr'
file { '/etc/nginx/sites-enabled/bogo.conf':
    content => template('nginx/vhost.conf.erb'),
}
```

---

## Hiera
Hiera is a framework for hierarchically organizing data, and abstracting if from your manifests. Hiera aim to provider separation between code and data.

- Hierarchical database, intended to store values
- You define the hierarchy, e.g.:
    - Node FQDN
    - Environment name
    - OS family
    - Common data (for every node)
- Hiera can use multiple backend (YAML - JSON)

---

- Configured hierarchy:
```yaml
# /etc/puppet/hiera.yaml
---
version: 5

defaults:
  data_hash: yaml_data
  datadir: data

hierarchy:
  - name: "Per-node data"
    path: "nodes/%{trusted.certname}.yaml"
  - name: "Per-environment data"
    path: "env/%{$environment}.yaml"
  - name: "Common values"
    path: "common.yaml"
```

---

- Hieradata
```yaml
# data/nodes/server.example.com.yaml
examplekey: 'value for server.example.com'
```
```yaml
# data/environment/production.yaml
examplekey: 'value for nodes in production environment'
```
```yaml
# data/common.yaml
examplekey: 'value for all nodes'
```

---

- What will be in `$test`?
```puppet
$test = lookup('examplekey')
```

---

Puppet automatically looks up ```class::parameter``` into Hiera when using parametrized classes.

:computer:

---

## Nodes

- A node definition or node statement is a block of Puppet code that will only be included in matching node's **catalogs**.
- Node statements only match nodes by name. By default, the name of a node is its **certname**.

```puppet
# /etc/puppetlabs/puppet/manifests/site.pp
node 'www1.example.com' {
    include common
    include apache
    include squid
}

node 'db1.example.com' {
    include common
    include mysql
}
```

---

## Defines

- **Defined resource types** (also called **defined types** or **defines**) are blocks of Puppet code that can evaluated multiple times with different parameters.
- Once defined, they act like a new resource type: you can cause the block to be evaluated by __declaring a resource__ of that new resource type.
- Defines can be used as simple macros or as a lightweigth way to develop fairly sophisticated resource types.

```puppet
define hello_define ($content_variable) {
  file {"$title":
    ensure  => file,
    content => $content_variable,
  }
}

hello_define {'/tmp/hello_define1':
  content_variable => "Hello World. This is first define\n",
}

```

:computer:

---

## Classes

- Groups of resources can be organized into classes, which are larger units of configuration.
- While a resource might describe a single file or package, a class can describe everything needed to configure an entire service or application (including any number of packages, config files, service daemons, and maintainance tasks)

---

## Class - Example

```puppet
class ntp {
    $service_name = $::osfamily ? {
        Redhat  => 'ntpd',
        Debian  => 'ntp',
    }
    
    package { 'ntp': ensure => installed, }
    ->
    file { 'ntp.conf':
        path => '/etc/ntp.conf',
        ensure => file,
        source => 'puppet:///modules/ntp/ntp.conf',
    }
    ~>
    service { 'ntp':
        name => $service_name,
        ensure => running,
        enable => true,
    }
}
```

---

## Modules
- Modules are self-contained bundles of code and data. 
- Modules allow you to split code into logic units
- Module often contain one or several tightly-related classes
- There also are other types of modules, like a standard library or utility functions.

---

## Modules - Path and directory structure

- Puppet < 4 : `/etc/puppet/modules`
- Puppet >= 4 : `/etc/puppetlabs/code/environments/<ENV>/modules`

```
[root@dev ~]# puppet config print modulepath
/etc/puppetlabs/code/environments/production/modules:/etc/puppetlabs/code/modules:/opt/puppetlabs/puppet/modules
```

---

## Module Layout
- modulename
    - `manifests/` -- Puppet manifest describing your custom classes.
    - `files/` -- static files used by the module.
    - `templates/` -- templates used by the module.
    - `examples/` -- contains examples showing how to declare the module's classes and defined types.
    - `spec/` -- contains spec tests for the module. 

---


## Puppet Forge

- https://forge.puppetlabs.com
- Supported and approved modules
- `puppet module <install|upgrade> puppetlabs-apache`

---

## Thank You


