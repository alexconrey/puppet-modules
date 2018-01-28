class prometheus_server {

  class { '::prometheus':
    scrape_configs  => [{
        'job_name' => 'prometheus',
        'scrape_interval'  => '10s',
        'scrape_timeout'   => '10s',
        'target_groups'    => [
          {
          'targets'    => ['localhost:9090','10.10.2.35:9090'],
          'labels'     => {'alias' => 'Prometheus'},
          }
        ],
      }],
  }

}
