class prometheus_server {
  
  $servers = hiera('prometheus::server_list')
  
  $scrape_configs = hiera_hash('prometheus::scrape_config')

  class { '::prometheus':
    version => '1.8.2',
    scrape_configs => [ {'job_name'=>'prometheus','scrape_interval'=> '30s','scrape_timeout'=>'30s','static_configs'=> [{'targets'=>['localhost:9090', 'localhost:9100'], 'labels'=> { 'alias'=>'Prometheus'}}]}],
  }

}

