class prometheus_server {
  
  $servers = hiera('prometheus::server_list')
  
  $scrape_configs = hiera_hash('prometheus::scrape_config')

  class { '::prometheus':
    scrape_configs  => [hiera_hash('prometheus::scrape_config')],
  }

}

