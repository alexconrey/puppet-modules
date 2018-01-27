class protectmymail_mailserver ( 
  $mail_myhostname	= 'mail.protectmymail.com',
  $mail_mydomain        = 'protectmymail.com',
  $mail_db_host		= undef,
  $mail_db_user		= undef,
  $mail_db_pass		= undef,
  $mail_db_port		= 3306,
  $mail_db_database     = undef,
  $mail_mynetworks      = [],
) {

  include ::postfix::server


  class { '::protectmymail_mailserver::install': } -> 
  class { '::protectmymail_mailserver::config': } ~>
  class { '::protectmymail_mailserver::general': } ->
  Class['::protectmymail_mailserver']

}
