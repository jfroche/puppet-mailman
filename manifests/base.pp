class mailman::base (
  $mailman_admin = hiera('mailman::admin'),
  $mailman_password = hiera('mailman::password'),
  $mailman_mailserver = hiera('mailman::mailserver'),
  $mailman_webserver = hiera('mailman::webserver')
){
  package{'mailman':
    ensure => installed,
  }

  service{'mailman':
    ensure => running,
    enable => true,
    hasstatus => false,
    pattern   => 'qrunner',
    hasrestart => true,
    require => Package['mailman'],
  }

  file{'/etc/mailman/mm_cfg.py':
    source => [ "puppet:///modules/site-mailman/config/${fqdn}/mm_cfg.py",
                "puppet:///modules/site-mailman/config/mm_cfg.py",
                "puppet:///modules/mailman/config/${operatingsystem}/mm_cfg.py",
                "puppet:///modules/mailman/config/mm_cfg.py",
                "puppet:///modules/affinitic/mailman/mm_cfg.py"],
    require => Package['mailman'],
    notify => Service['mailman'],
    owner => root, group => list, mode => 0644;
  }

  if $mailman_admin == '' { fail("you have to set \$mailman_admin on $fqdn") }
  if $mailman_password == '' { fail("you have to set \$mailman_password on $fqdn") }

  mailman::list {'mailman':
    ensure     => 'present',
    admin      => $mailman_admin,
    password   => $mailman_password,
    mailserver => $mailman_mailserver,
    webserver  => $mailman_webserver,
    require    => Package['mailman'],
    notify     => Service['mailman']
  }

  exec{'set_mailman_adminpw':
    command => "/var/lib/mailman/bin/mmsitepass ${mailman_password}",
    creates => "/var/lib/mailman/data/adm.pw",
    require => Package['mailman'],
  }
}
