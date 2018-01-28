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
  $s3_buckets           = hiera_hash('protectmymail_mailserver::s3fs', undef),
) {

  if $s3_buckets {
    class { '::protectmymail_mailserver::s3fs': }
  } 
  
  class { '::protectmymail_mailserver::config': } ->
  Class['::protectmymail_mailserver']

}
