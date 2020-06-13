# Creates a new rule in UFW
define ufw::rule (
  Enum['present', 'absent'] $ensure = 'present'
) {

  if !defined(Class['ufw']) {
    fail('You must include the UFW base class first')
  }

  $exists = "ufw status | grep -qE '# ${name}'"

  if $ensure == 'present' {

    exec { "ufw-allow-${name}":
      command => "ufw ${name} comment '${name}'",
      unless  => $exists,
      path    => ['/bin', '/usr/bin', '/sbin', '/usr/sbin'],
      require => Package['ufw']
    }

  } else {

    exec { "ufw-delete-${name}":
      command => epp('ufw/delete-rule.epp', { 'comment' => $name } ),
      onlyif  => $exists,
      path    => ['/bin', '/usr/bin', '/sbin', '/usr/sbin'],
      require => Package['ufw']
    }

  }
}
