class router::sysctl { 
    sysctl { 'net.ipv4.ip_forward': value => '1' }
}
