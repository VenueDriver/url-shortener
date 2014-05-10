# Hkk-sn

This is a URL shortener for the [Hakkasan Group](http://hakkasangroup.com/).  Any URL gets shortened
to http://Hkk.sn/whatever.  It uses [Rails](http://rubyonrails.org/) 4.1.1 and [Ruby](https://www
.ruby-lang.org/en/) 1.9.3.  The production environment is at [Engine
Yard](https://www.engineyard.com/).  This project uses [Vagrant](http://www.vagrantup.com/) for
development, with a minimal [Gentoo](http://www.gentoo.org/) VM, configured with
[Chef](http://www.getchef.com/chef/).

## Development setup

* Clone the repository to your development system.
* Make sure that you have [VirtualBox](https://www.virtualbox.org/) installed.  (On a Mac, do a
  Spotlight search for "VirtualBox".)
* Make sure that you have [Vagrant](http://www.vagrantup.com/) installed.  (From a terminal, do
  "vagrant -v".)
* Go to the project in a terminal and tell it: ```vagrant up```.  Provisioning will take some time
  the first time, then it will be quick to start up after that.
* After the VM starts, tell it: ```vagrant ssh```.
* Once your into the VM, change to the shared folder: ```cd /vagrant```

Now you're in a Rails development environment.