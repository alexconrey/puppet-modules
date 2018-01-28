class router::vpn_tunnel {
  
  $conns = hiera('router::tunnels')
  $secrets = hiera('router::secrets')

  create_resources('libreswan::conn', $conns)
  create_resources('libreswan::secret', $secrets)
    
} 
  

