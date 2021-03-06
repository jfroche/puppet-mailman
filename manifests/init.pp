#
# mailman module
#
# Copyright 2009, admin(at)immerda.ch
#
# This program is free software; you can redistribute 
# it and/or modify it under the terms of the GNU 
# General Public License version 3 as published by 
# the Free Software Foundation.
#

class mailman {
  case $operatingsystem {
    centos: { include mailman::centos }
    base: { include mailman::base }
  }
  if $use_munin {
    include mailman::munin
  }
}
