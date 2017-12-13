class profile::test_define {

  notify { 
    'hello':
      message => "Hello ${hostname}",
  }

  if $::osfamily == "Debian" {
    notify {
      'debian':
        message => "I see you're using $::operatingsystem...",
        require => Notify["hello"],
    }
  }

  #define customType($number, $device, $foo) {
  #  notify {
  #    "${title} : ${device} is ${number} not ${foo}":
  #  }
  #}

  #customType {
  #  'k1':
  #    number => "3", device => "Yes", foo => "whatever";
  #  'k2':
  #    number => "7", device => "No", foo => "WIP";
  #  'k3':
  #    number => "1", device => "Oui", foo => "bar";
  #}
}
