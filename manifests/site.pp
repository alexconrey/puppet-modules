node default {
  include prometheus::node_exporter

  hiera_include('classes', [])

}
