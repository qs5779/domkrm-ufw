# Installs, configures and enables UFW 
class ufw (

  Boolean $ipv6 = true

) {

  # Variables for config file
  $_ipv6 = $ipv6 ? {
    false   => 'IPV6=no',
    default => 'IPV6=yes'
  }

  # Install package
  package { 'ufw': }

  # Deny all
  exec { 'ufw-deny':
    command => 'ufw default deny',
    unless  => 'ufw status verbose | grep -q "Default: deny (incoming)"',
    path    => '/bin:/usr/bin:/sbin:/usr/sbin'
  }

  # Enable UFW
  exec { 'ufw-enable':
    command => 'ufw --force enable',
    unless  => 'ufw status | grep -q "Status: active"',
    path    => '/bin:/usr/bin:/sbin:/usr/sbin'
  }

  # Define service
  service { 'ufw':
    ensure => 'running',
    enable => true
  }

  # Disable IPv6
  file_line { 'ufw-ipv6':
    line   => $_ipv6,
    match  => '^IPV6=',
    path   => '/etc/default/ufw',
    notify => Service['ufw']
  }

}
