class protectmymail_mailserver::exporters {
  vcsrepo { '/opt/postfix_exporter':
    ensure   => present,
    provider => git,
    source   => 'git://github.com/kumina/postfix_exporter',
  }

  exec { 'build postfix_exporter':
    command    => '/bin/bash build_static.sh',
    cwd        => '/opt/postfix_exporter',
    require    => Vcsrepo['/opt/postfix_exporter'],
  }

  exec { 'copy postfix_exporter binary':
    command    => '/bin/cp /opt/postfix_exporter/postfix_exporter /usr/local/bin/postfix_exporter',
    require    => Exec['build postfix_exporter'],
  }

  file { 'postfix-exporter':
    path       => '/etc/systemd/system/postfix-exporter.service',
    ensure     => present,
    content    => template('protectmymail_mailserver/exporter.service.erb'),
  }
}
