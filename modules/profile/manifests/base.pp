class profile::base {

  $enhancers = ['vim', 'git']

  package { $enhancers:
    ensure => 'installed',
  }

  notify { 'test':
    message => "${facts['environment']}",
  }

  # Arrays
  [$a, $b, $d] = [1, 2, 3]

  # Hashes
  $c = {c => 34}

  notify {
    'variables':
      message => $enhancers[0];
    'test2':
      message => $a;
    'test3':
      message => $c;
  }
}
