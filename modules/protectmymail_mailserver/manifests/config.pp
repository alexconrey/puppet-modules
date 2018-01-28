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

  if !defined(File["${::protectmymail_mailserver::maildir}"]) {
    file { "${::protectmymail_mailserver::maildir}":
      ensure      => present,
      owner       => 'vmail',
    }
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
    lmtp_unix_listener_user => 'postfix',
    lmtp_unix_listener_group => 'postfix',
    auth_listener_userdb_mode => '0600',
    auth_listener_userdb_user => 'vmail',
    include_inbox_namespace   =>  true,
    auth_listener_postfix      => true,
    auth_listener_postfix_user => 'postfix',
    auth_listener_postfix_group => 'postfix',
    auth_listener_default_user => 'dovecot',
    ssl                        => 'required',
    ssl_cert                   => $::protectmymail_mailserver::ssl_cert,
    ssl_key                    => $::protectmymail_mailserver::ssl_key,
    imap_client_workarounds    => 'tb-extra-mailbox-sep',
#    auth_sql_path              => '/etc/dovecot/conf.d/dovecot-sql.conf.ext',
    auth_sql_userdb_static     => 'uid=vmail gid=vmail home=/srv/data/mail/%d/%n',
    mail_fsync			=> 'always',
    mail_nfs_storage		=> 'yes',
    mail_nfs_index		=> 'yes',
    mmap_disable		=> 'yes',
    
  }

  dovecot::file { 'dovecot-sql.conf.ext':
    owner    => 'mail',
    group    => 'dovecot',
    content   => template('protectmymail_mailserver/dovecot-sql.conf.ext.erb'),
  }
  
  class { 'postfix::server':
    myhostname     => $::protectmymail_mailserver::mail_myhostname,
    mydomain       => $::protectmymail_mailserver::mail_mydomain,
    myorigin       => '$mydomain',
    inet_interfaces => 'all',
    extra_main_parameters   => {
      'maildir_stat_dirs'   => 'yes',
      'broken_sasl_auth_clients'  => 'yes',
      'smtpd_sasl_authenticated_header' => 'yes',
      'smtp_tls_session_cache_database' => 'btree:${data_directory}/smtp_cache',
      'smtpd_tls_session_cache_database' => 'btree:${data_directory}/smtpd_scache',
    },
    virtual_mailbox_domains  => ['mysql:/etc/postfix/sql/domains.cf'],
    virtual_mailbox_maps     => ['mysql:/etc/postfix/sql/mailboxes.cf'],
    virtual_alias_maps       => ['mysql:/etc/postfix/sql/aliases.cf'],
    virtual_transport        => 'lmtp:unix:private/dovecot-lmtp',
    smtpd_tls_cert_file      => $::protectmymail_mailserver::ssl_cert,
    smtpd_tls_key_file       => $::protectmymail_mailserver::ssl_key,
    ssl                      => true,
    smtpd_sasl_type          => 'dovecot',
    smtpd_sasl_auth          => true,
    smtpd_recipient_restrictions => ['permit_sasl_authenticated', 'permit_mynetworks', 'reject_unauth_destination'],
#    submission               => true,
    master_services	     => [
      'submission inet  n       -       n       -       -       smtpd',
    ],
  }
}
