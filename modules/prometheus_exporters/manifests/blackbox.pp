class prometheus_exporters::blackbox(
  $modules = hiera_hash('prometheus_exporters::blackbox::modules', {})
){
  $resource_hash = { 'modules' => $modules } 
  create_resources('prometheus::blackbox_exporter', $resource_hash) 

}
