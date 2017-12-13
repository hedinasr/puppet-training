package { 'epel-release':
  ensure => installed,
}
->
package { ['collectd', 'collectd-rrdtool', 'rrdtool','collectd-web']:
  ensure => installed,
}

package { 'httpd':
  ensure => installed,
}

#package { 'git': ensure => installed, }
#->
#vcsrepo { '/var/www/html/collectd-web':
#  ensure => present,
#  provider => git,
#  source => 'https://github.com/httpdss/collectd-web',
#}
#->
#exec { 'make_collectd_web_script_executable':
#  command => 'chmod +x /var/www/html/collectd-web/cgi-bin/graphdefs.cgi',
#  path => '/usr/local/bin/:/bin/',
#}

package {
  ['rrdtool-devel', 'rrdtool-perl', 'perl-HTML-Parser', 'perl-JSON']:
    ensure => installed,
}
#->
#file {
#  '/etc/httpd/conf.d/collectd.conf':
#    ensure  => file,
#    mode    => '0644',
#    owner   => root,
#    group   => root,
#    source  => '/vagrant/2-Relationships/files/collectd.conf',
#}
->
service {
  'httpd':
    ensure => running,
    enable => true;
}

service {
  'collectd':
    ensure => running,
    enable => true;
}


