class protectmymail_mailserver::postfix_exporter {
  vcsrepo { '/opt/postfix_exporter':
    ensure   => present,
    provider => git,
    source   => 'git://github.com/kumina/postfix_exporter',
  }

  exec { 'build postfix_exporter':
    command    => 'bash build_static.sh',
    cwd        => '/opt/postfix_exporter',
    require    => Vcsrepo['/opt/postfix_exporter'],
  }
}
