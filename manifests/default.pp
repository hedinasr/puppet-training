notify { 'my_message':
  message => lookup('my_message'),
}

include profile::base
include profile::test_define
include profile::monitoring

node 'dev.puppet.vm' {
  notify { 'classification': }
  include profile::web
}
