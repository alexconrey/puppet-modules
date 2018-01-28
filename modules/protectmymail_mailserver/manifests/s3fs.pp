class protectmymail_mailserver::s3fs {
 
  create_resources('yas3fs::mount',  $::protectmymail_mailserver::s3fs)

}
