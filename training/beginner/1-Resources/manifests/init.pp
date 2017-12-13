File {
  owner => root,
  group => root
}

file {
  '/tmp/test1':
    ensure  => file,
    mode    => '0644',
    content => "test1\n";
  '/tmp/dir1':
    ensure  => directory,
    mode    => '0755';
  '/tmp/dir1/test2':
    ensure  => '/tmp/test1';
}
