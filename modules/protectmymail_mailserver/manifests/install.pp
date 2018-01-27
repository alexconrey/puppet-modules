class protectmymail_mailserver::install {
  
  ensure_packages([
    'dovecot',
    'dovecot-mysql',
    'postfix',
  ])

  
}
