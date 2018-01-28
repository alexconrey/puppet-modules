class prometheus_server {
  
  $prometheus_config = hiera_hash('prometheus::config')
  create_resources('prometheus', $prometheus_config

}

