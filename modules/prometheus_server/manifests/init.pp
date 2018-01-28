class prometheus_server {
  
#  $prometheus_config = hiera_hash('prometheus::config')
  $prometheus_nodes = hiera('prometheus::nodes', [])

#  create_resources('prometheus', $prometheus_config

  class {'::prometheus':
    version  => '1.8.2',
    scrape_configs  =>  [
      {
        'job_name' => 'prometheus',
        'scrape_interval' => '10s',
        'scrape_timeout'  => '10s',
        'static_configs'  => [{
          'targets'  => ['localhost:9090'],
          'labels'   => { 'alias' => 'Prometheus' },
	}],
      },
      {
        'job_name'  => 'noes',
        'scrape_interval' => '10s',
        'scrape_timeout'  => '10s',
        'static_configs'  => [{
#          'targets'  => ['localhost:9100', '10.10.2.35:9100'],
          'targets'  => $prometheus_nodes,
          'labels'   => { 'alias' => 'nodes' },
	}],
      }
    ],
  }

}

