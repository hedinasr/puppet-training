# Part 1 : DSL Puppet

## Tuto 2 : Relations

Dans ce tutoriel nous allons installer collectd et activer l'interface web de collectd.
Pour cela nous aurons besoin d'installer le module `puppetlabs/vscrepo` nous permettant de cloner le projet Github collectd-web.

### Installation du module

```sh
vagrant ssh
sudo su
puppet module install puppetlabs/vcsrepo
```

### Packages

#### Installation de collectd

Pour CentOS, il faut activer le repository epel-release.

    package {
      'epel:
        ensure => installed;
    }

    package {
      'collectd':
        ensure => installed;
    }

#### Installation de httpd 

    package {
      'httpd':
        ensure => installed;
    }


#### Installation des dépendances pour l'interface web

    package {
      ['git', 'rrdtool', 'rrdtool-devel', 'rrdtool-perl', 'perl-HTML-Parser', 'perl-JSON']:
        ensure => installed;
    }

#### Installation de l'interface web

```puppet
vcsrepo { '/var/www/html':
   ensure => present,
   provider => git,
   source => 'https://github.com/httpdss/collectd-web',
}
```

### Services

#### Collectd

    service {
      'collectd':
        ensure => running,
        enable => true;
    }

#### Httpd

    service {
      'httpd':
        ensure => running,
        enable => true;
    }

### Fichier de configuration Httpd

    file {
      '/etc/httpd/conf.d/collectd.conf':
        ensure  => file,
        mode    => '0644',
        owner   => root,
        group   => root,
        source  => '/vagrant/tuto2/files/collectd.conf',
    }

### Puppet apply

Dans l'état actuel du manifest, la commande suivant va générer des erreurs :

    $ sudo puppet apply /vagrant/tuto2/manifests/init.pp

### Définition des relations

* Définissez les relations nécessaires à l'aide des metaparamètres.
* Factoriser ensuite le manifest à l'aide des flèches de relations.

### Vérifier le résultat

Ouvrir l'URL suivante dans votre naigateur : [http://localhost:10080/collectd/](http://localhost:10080/collectd/)

