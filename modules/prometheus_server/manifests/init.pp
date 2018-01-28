class prometheus_server {
  
#  $prometheus_config = hiera_hash('prometheus::config')

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
          'targets'  => ['localhost:9100'],
          'labels'   => { 'alias' => 'nodes' },
	}],
      }
    ],
  }

}

