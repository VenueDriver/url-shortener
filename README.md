# URL Shortener

This is a URL shortener for the [Hakkasan Group](http://hakkasangroup.com/).  Any URL gets shortened
to http://Hkk.sn/whatever.  It uses [Rails](http://rubyonrails.org/) 4.1.1 and [Ruby](https://www
.ruby-lang.org/en/) 1.9.3.  The production environment is at [Engine
Yard](https://www.engineyard.com/).  This project uses [Vagrant](http://www.vagrantup.com/) for
development, with a minimal [Gentoo](http://www.gentoo.org/) VM, configured with
[Chef](http://www.getchef.com/chef/).

## Development setup

### Prerequisites

This web app is packaged in Docker containers, for portability.  To run it, you'll need Docker
version 1.7.1 at least.  Please see the Docker installation instructions at:

    https://docs.docker.com/engine/installation/ubuntulinux/

All other prerequisites are packaged inside of the containers.  Docker is the only thing to
install.

### Build your container images

This project uses [Docker Compose](https://docs.docker.com/compose/) to orchestrate multiple
containers.  One container provides your database, and one provides your Rails app. The
configuration is in the file docker-compose.yml.

When you first start development, and any time that your Gemfile changes, you'll need to build
your containers with:

    docker-compose build

### Run your Ruby code

Use your containers to run your Ruby code:

    docker-compose run web rake -T

That tells Docker Compose to run the web and db containers and run "rake -T" in the web
container.  You don't need the database to do that, but next you'll see how you can also access
the database container from your Ruby code.

### Build your databases

Now create your database structure with Ruby code in your web container:

    docker-compose run web rake db:migrate

And don't forget to create a test database:

    docker-compose run web db:test:prepare

### Do stuff

Now you're in a Rails development environment.  You can do your standard Rails stuff:

    docker-compose run web rails console

    docker-compose run web rails server

### Run tests

Run the unit tests with:

    docker-compose run web rake test

Run the Cucumber specs with:

    docker-compose run web rake cucumber
