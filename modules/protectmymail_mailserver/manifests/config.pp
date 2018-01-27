class protectmymail_mailserver::config {

  $postfix_files = []

  $postfix_files.each |$file| {
    postfix::file { $file:
      content => template("protectmymail_mailserver/${file}.erb"),
    }
  }

  user { 'vmail':
    ensure => present,
    uid    => '1002',
  }
  
  file { '/srv/data':
    ensure  => directory,
  }
  
  file { '/srv/data/mail':
    ensure  => directory,
  }

  class { 'dovecot':
    protocols  =>  'imap lmtp',
    disable_plaintext_auth  => false,
    auth_mechanisms         => 'plain login',
    auth_include            => ['sql'],
    mail_location           => 'maildir:/srv/data/mail/%d/%n:LAYOUT=fs',
    mail_privileged_group   => 'mail',
    imaplogin_imaps_ssl     => true,
    lmtp_unix_listener      => '/var/spool/postfix/private/dovecot-lmtp',
    lmtp_unix_listener_port => '0600',
    lmtp_unix_listener_user => 'postfix',
    lmtp_unix_listener_group => 'postfix',
    auth_listener_userdb_mode => '0600',
    auth_listener_userdb_user => 'vmail',
    auth_listener_postfix_mode => '0666',
    auth_listener_postfix_user => 'postfix',
    auth_listener_postfix_group => 'postfix',
    auth_listener_default_user => 'dovecot',
    ssl                        => true,
    ssl_cert                   => '/etc/letsencrypt/live/mail.protectmymail.com/fullchain.pem',
    ssl_key                    => '/etc/leysencrypt/live/mail.protectmymail.com/privkey.pem',
    imap_client_workarounds    => 'tb-extra-mailbox-sep',
#    auth_sql_path              => '/etc/dovecot/conf.d/dovecot-sql.conf.ext',
    auth_sql_userdb_static     => 'uid=vmail gid=vmail home=/srv/data/mail/%d/%n',
    
  }

  dovecot::file { 'dovecot-sql.conf.ext':
    owner    => 'mail',
    group    => 'dovecot',
    content   => template('protectmymail_mailserver/dovecot-sql.conf.ext.erb'),
  }
  
  class { 'postfix::server':
    mysql          => true,
    myhostname     => $::protectmymail_mailserver::mail_myhostname,
    mydomain       => $::protectmymail_mailserver::mail_mydomain,
    myorigin       => '$mydomain',
    inet_interfaces => 'all',
    extra_main_parameters   => {
      'allow_mail_to_files' => 'alias',
      'maildir_stat_dirs'   => 'yes',
      'broken_sasl_auth_clients'  => 'yes',
      'smtpd_sasl_authenticated_header' => 'yes',
    },
    virtual_mailbox_domains  => ['mysql:/etc/postfix/sql/domains.cf'],
    virtual_mailbox_maps     => ['mysql:/etc/postfix/sql/sender-login-maps.cf'],
    virtual_alias_maps       => ['mysql:/etc/postfix/sql/aliases.cf'],
    virtual_transport        => 'lmtp:unix:private/dovecot-lmtp',
    smtpd_tls_cert_file      => '/etc/letsencrypt/live/mail.protectmymail.com/fullchain.pem',
    smtpd_tls_key_file       => '/etc/letsencrypt/live/mail.protectmymail.com/privkey.pem',
    smtpd_use_tls            => true,
#    smtpd_tls_session_cache_database => 'btree:${data_directory}/smtpd_scache',
#    smtp_tls_session_cache_database => 'btree:${data_directory}/smtp_cache',
    smtpd_sasl_type          => 'dovecot',
    smtpd_sasl_auth          => true,
    smtpd_recipient_restrictions => ['permit_sasl_authenticated', 'permit_mynetworks', 'reject_unauth_destination'],
    spamassassin             => true,
  }
}
