class prometheus_server {
  
#  $prometheus_config = hiera_hash('prometheus::config')
#  $prometheus_nodes = hiera('prometheus_server::nodes', [])
  $prometheus_jobs = hiera('prometheus_server::jobs')

#  create_resources('prometheus', $prometheus_config

  class {'::prometheus':
    version  => '1.8.2',
    scrape_configs  =>  $prometheus_jobs,
  }

}

