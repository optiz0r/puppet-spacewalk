# Class: spacewalk::proxy
# ===========================
#
#  The spacewalk module installs and configures Spacewalk Proxy server.
#
#
# Example
#============================
#
#  class { 'spacewalk::proxy':
#      rhn_parent = 'https://spacewalk.example.com',
#  }
#
#
# Authors
# -------
#
# Ben Roberts <me@benroberts.net>
#
# Copyright
# ---------
#
# Copyright 2017 Ben Roberts.
#
class spacewalk::proxy (

  $rhn_parent,

  ### service
  $service_ensure              = running,

  ### answer file
  $ca_chain                    = $spacewalk::params::ca_chain,
  $admin_email                 = $spacewalk::params::admin_email,
  $force_own_ca_opt            = $spacewalk::params::force_own_ca_opt,
  $ssl_organization            = $spacewalk::params::ca_organization,
  $ssl_organization_unit       = $spacewalk::params::ca_organization_unit,
  $ssl_email_address           = $spacewalk::params::ca_email_address,
  $ssl_city                    = $spacewalk::params::ca_city,
  $ssl_state                   = $spacewalk::params::ca_state,
  $ssl_country_code            = $spacewalk::params::ca_country_code,
  $populate_config_channel     = $spacewalk::params::populate_config_channel,

) inherits spacewalk::params {

  $ssl_password = lookup('spacewalk::proxy::ssl_password', {
    'default_value' => $spacewalk::params::ssl_password,
  })

  include ::spacewalk::proxy::packages
  include ::spacewalk::proxy::setup
  include ::spacewalk::proxy::service

  Class['spacewalk::proxy::packages'] ->
  Class['spacewalk::proxy::setup']    ->
  Class['spacewalk::proxy::service']  ->
  Class['spacewalk::proxy']
}
