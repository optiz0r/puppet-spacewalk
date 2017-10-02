# Class spacewalk::proxy::service
# ===========================
#
# Manage spacewalk proxy service

class spacewalk::proxy::service (

  $service_ensure = $spacewalk::proxy::service_ensure,

){

  service {'spacewalk-proxy-service':
    ensure   => $service_ensure,
    start    => 'rhn-proxy start',
    stop     => 'rhn-proxy stop',
    restart  => 'rhn-proxy restart',
    status   => 'rhn-proxy status',
    provider => base,
  }
}
