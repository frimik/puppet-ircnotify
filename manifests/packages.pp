class ircnotify::packages {

  case $operatingsystem {
    ubuntu, debian: {
      $netcat_pkg_name = "netcat"
    }
    centos, redhat, oel, scientific: {
      $netcat_pkg_name = "nc"
    }
    default: {
      fail ("The ${module_name} module is not supported on ${operatingsystem}")
    }
  }

  # if package is not defined, define it
  if !defined(Package["$netcat_pkg_name"]) {
    package{"$netcat_pkg_name": }
  }

}
