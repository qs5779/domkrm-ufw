# Installs, configures and enables UFW 
class ufw {

  # Install package
  package { 'ufw': }

  # Deny all
  exec { 'ufw-deny' :
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

}
