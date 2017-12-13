class profile::web {

  include apache
  include apache::mod::php

  apache::vhost { $::fqdn:
    port    => '80',
    docroot => '/var/www/test',
    require => File['/var/www/test'],
  }

  file { ['/var/www', '/var/www/test']:
    ensure => directory,
  }

  file { '/var/www/test/index.php':
    ensure  => file,
    content => template('profile/index.php.erb'),
  }
}
