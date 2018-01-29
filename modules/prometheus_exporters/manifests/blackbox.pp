class prometheus_exporters::blackbox(
  $modules = hiera_hash('prometheus_exporters::blackbox::modules', {})
){
  
  class {'prometheus::blackbox_exporter':
    modules => $modules,
  }


}
