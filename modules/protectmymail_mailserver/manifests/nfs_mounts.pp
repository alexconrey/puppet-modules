class protectmymail_mailserver::nfs_mounts {
  
  $nfs = hiera_hash('protectmymail_mailserver::nfs_mounts', undef) 

  create_resources('mount', $nfs)

}
