class router {

  class {'router::vpn_tunnel': } ->
  Class['::router']

}
