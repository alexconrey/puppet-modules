class protectmymail_mailserver::s3fs {
  
  $s3fs = hiera_hash('protectmymail_mailserver::s3fs', undef) 
  
  create_resources('yas3fs::mount',  $s3fs)

}
