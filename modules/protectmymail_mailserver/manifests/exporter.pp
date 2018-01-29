define protectmymail_mailserver::exporter (
  String $repo,
  $build_cmd    = '/bin/bash build_static.sh',
  $build_path   = "/opt/${title}",
) {
  vcsrepo { "${build_path}":
    ensure   => present,
    provider => git,
    source   => "${repo}",
  }

  exec { "build ${title}":
    command    => "${build_cmd}",
    cwd        => "${build_path}",
    require    => Vcsrepo["${build_path}"],
  }

  exec { "copy ${title} binary":
    command    => "/bin/cp ${build_path}/${title} /usr/local/bin",
    require    => Exec["build ${title}"],
  }

  file { "${title} systemd":
    path       => "/etc/systemd/system/${title}.service",
    ensure     => present,
    content    => template('protectmymail_mailserver/exporter.service.erb'),
  }
}
