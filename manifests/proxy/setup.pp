# Class spacewalk::proxy::setup
# ===========================
#
# Initial spacewalk proxy server setup

class spacewalk::proxy::setup (

  $admin_email                 = $spacewalk::proxy::admin_email,
  $force_own_ca_opt            = $spacewalk::proxy::force_own_ca_opt,
  $ssl_organization            = $spacewalk::proxy::ssl_organization,
  $ssl_organization_unit       = $spacewalk::proxy::ssl_organization_unit,
  $ssl_common_name             = $::fqdn,
  $ssl_email_address           = $spacewalk::proxy::ssl_email_address,
  $ssl_city                    = $spacewalk::proxy::ssl_city,
  $ssl_state                   = $spacewalk::proxy::ssl_state,
  $ssl_country_code            = $spacewalk::proxy::ssl_country_code,
  $populate_config_channel     = $spacewalk::proxy::populate_config_channel,
){

  $force_own_ca = $force_own_ca_opt ? {
    true    => '--force-own-ca',
    false   => '',
    default => '',
  }

  $command    = "#!/bin/bash\nconfigure-proxy.sh --answer-file=/etc/sysconfig/spacewalk-proxy.answer --non-interactive ${force_own_ca}"

  $ssl_password = $spacewalk::proxy::ssl_password

  file{'/root/ssl-build':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0640';
  }

  file {'/etc/sysconfig/spacewalk-proxy.answer':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0400',
    content => template('spacewalk/proxy/spacewalk-proxy.answer.erb'),
    notify  => Exec['spacewalk-proxy-setup'],
  }

  file {'/usr/bin/spacewalk_proxy.sh':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0750',
    content => $command,
    notify  => Exec['spacewalk-proxy-setup'],
  }

  exec {'spacewalk-proxy-setup':
    cwd         => '/root',
    command     => '/usr/bin/spacewalk_proxy.sh',
    refreshonly => true,
    logoutput   => on_failure,
    require     => File[
        '/etc/sysconfig/spacewalk-proxy.answer',
        '/usr/bin/spacewalk_proxy.sh',
        '/root/ssl-build',
    ],
  }
}
