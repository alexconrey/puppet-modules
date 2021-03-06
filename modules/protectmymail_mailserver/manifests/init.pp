class protectmymail_mailserver ( 
  $mail_myhostname	= 'mail.protectmymail.com',
  $mail_mydomain        = 'protectmymail.com',
  $mail_db_host		= undef,
  $mail_db_user		= undef,
  $mail_db_pass		= undef,
  $mail_db_port		= 3306,
  $mail_db_database     = undef,
  $mail_mynetworks      = [],
  $ssl_key              = hiera('protectmymail_mailserver::ssl_key', undef),
  $ssl_cert             = hiera('protectmymail_mailserver::ssl_cert', undef),
  $maildir              = hiera('protectmymail_mailserver::maildir', '/var/mail'),
  $nfs_mounts		= hiera_hash('protectmymail_mailserver::nfs_mounts', {}),
  $exporters            = hiera_hash('protectmymail_mailserver::exporters', {}),
) {

  if $nfs_mounts {
    class { '::protectmymail_mailserver::nfs_mounts': }
  } 
  
  if $exporters { 
    create_resources('protectmymail_mailserver::exporter', $exporters) 
  }

  class { '::protectmymail_mailserver::config': } ->
  Class['::protectmymail_mailserver']

}
