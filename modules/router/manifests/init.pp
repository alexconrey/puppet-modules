class router {

  class {'router::sysctl': } ->
  class {'router::vpn_tunnel': } ->
  Class['::router']

}
