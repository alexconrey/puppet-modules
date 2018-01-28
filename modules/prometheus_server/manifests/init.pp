class prometheus_server {
  
  $servers = hiera('prometheus::server_list')

  class { '::prometheus':
    scrape_configs  => [{
        'job_name' => 'prometheus',
        'scrape_interval'  => '10s',
        'scrape_timeout'   => '10s',
        'target_groups'    => [
          {
          'targets'    => $servers,
          'labels'     => {'alias' => 'Prometheus'},
          }
        ],
      }],
  }

}

