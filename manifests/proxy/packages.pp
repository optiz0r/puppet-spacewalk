# Class spacewalk::proxy::package
# ===========================
#
# Install required packages
# This Class shoud not be call directly, call class spacewalk::proxy for installation.

class spacewalk::proxy::packages (

){

  package {'spacewalk-proxy-installer':
    ensure => installed;
  }

}
