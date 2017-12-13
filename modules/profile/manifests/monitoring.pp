class profile::monitoring {
  include netdata

  #apache::vhost { $::fqdn:
  #  port => '8081',
  #}
}
