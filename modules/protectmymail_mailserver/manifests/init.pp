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


  class { '::protectmymail_mailserver::config': } ->
  Class['::protectmymail_mailserver']

}
