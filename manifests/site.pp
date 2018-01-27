node default {
  $packages = hiera_array('packages', [])
  ensure_packages($packages)

  hiera_include('classes', [])

}
