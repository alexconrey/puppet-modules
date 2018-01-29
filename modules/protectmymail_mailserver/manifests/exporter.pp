class protectmymail_mailserver::exporter(
  String $repo,
  $build_cmd    = '/bin/bash build_static.sh',
  $build_path   = "/opt/${name}",
) {
  vcsrepo { "${build_path}":
    ensure   => present,
    provider => git,
    source   => "${repo}",
  }

  exec { "build ${name}":
    command    => "${build_cmd}",
    cwd        => "${build_path}",
    require    => Vcsrepo["${build_path}"],
  }

  exec { 'copy ${name} binary':
    command    => "/bin/cp ${build_path}/${name} /usr/local/bin",
    require    => Exec["build ${name}"],
  }

  file { "${name}":
    path       => "/etc/systemd/system/${name}.service",
    ensure     => present,
    content    => template('protectmymail_mailserver/exporter.service.erb'),
  }
}
