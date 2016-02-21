# Hospice at Home

* [About this project](http://brymac.ca/projects/hospice-at-home)

## Installation
* Install Ruby 2.2.3
* `bundle install`
* `rake db:setup` (will seed database with sample data)
* `rake geocode:update_coords`
* Install and launch postgres
* `bin/rails s`

## Running Tests
* `rake` will run Rspec tests, Jasmine tests, and Rubocop.  Or you can run the tests individually:

### Rspec tests
* Install rspec
* `rspec spec`

### Jasmine tests
* `rake spec:javascripts`