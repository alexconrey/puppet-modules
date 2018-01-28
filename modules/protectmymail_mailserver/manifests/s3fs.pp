class protectmymail_mailserver::s3fs {
 
  $s3_mounts = hiera('protectmymail_mailserver::s3fs') 

  create_resources('yas3fs::mount',  $s3_mounts)

}
