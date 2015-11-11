http://guides.rubyonrails.org/testing.html
http://everydayrails.com/2012/04/07/testing-series-rspec-controllers.html
    http://everydayrails.com/2012/03/12/testing-series-intro.html
https://robots.thoughtbot.com/how-we-test-rails-applications
http://david.heinemeierhansson.com/2014/tdd-is-dead-long-live-testing.html

# Questions
- Why are fixtures/factories necessary?
    +  "You could use the built-in User.create, but that gets tedious when you have many validations on your model. With User.create you have to specify attributes to fulfill the validations, even if your test has nothing to do with those validations. " - https://robots.thoughtbot.com/how-we-test-rails-applications
-  What would integration tests in Rails look like?
    +  According to Rails Guides, Integration tests are used to test interaction among any number of controllers.  Test important work flows within the app.
    +  This page (https://robots.thoughtbot.com/rspec-integration-tests-with-capybara) makes it sound like Integration and acceptance tests are the same thing.  They use the example of testing a visitor sign up process.
    +  This page (http://stackoverflow.com/questions/4019646/integration-vs-acceptance-test-what-is-cucumber-steak) has a good answer.  Integration tests hit several but not all layers, while acceptance tests are end-to-end.
    +  http://chriskottom.com/blog/2015/07/three-options-for-top-down-rails-testing/

# Everyday Rails
Tests should be:
- Reliable
- Easy to read
- Easy to understand

Gems to install for a rails app include:
- Factory Girl (see notes below on factory vs fixture)

- Use `rake db:create:all` to create DB including testing DB.

### Model Spec (http://everydayrails.com/2012/03/19/testing-series-rspec-models-factory-girl.html)
Example:
```ruby
    describe Contact
    it "has a valid factory"
    it "is invalid without a firstname"
    it "is invalid without a lastname"
    it "returns a contact's full name as a string"
```

### Factories
- Fixtures can be brittle and easily broken
- With fixtures, Rails bypasses ActiveRecord when it loads data to test DB.  So things like validations are ignored.
- In 'spec' directory, create subfolder 'factories'.  Create a file for a model, such as:
```ruby
# contacts.rb
FactoryGirl.define do
  factory :contact do |f|
    f.firstname "John"
    f.lastname "Doe"
  end
end
```
- When testing things like validations, use build instead of create.  If we used save it may break due to the validation.

### Controller specs
- Author stopped working on controller specs for a while, instead covering functionality in request specs (integration tests).
- Tests things such as redirection to homepage upon save.
- Syntax of controller spec a little different - REST method
Example:
```ruby
describe "GET #index" do
  it "populates an array of contacts" do
    contact = Factory(:contact)
    get :index
    assigns(:contacts).should eq([contact])
  end
  
  it "renders the :index view" do
    get :index
    response.should render_template :index
  end
end
```


# Thoughtbot - how we test Rails apps
- Feature specs-  a kind of acceptance tests.  Walk through entire application.
- Model tests
    + In rspec syntax, Model methods have dot notation.  Instance methods have # ('#method')
- Controller specs: testing multiple paths through controller.  Preferred over feature specs.
- View specs: testing conditional display of info in templates.
    + You 'assign' objects that would be assigned via the controller, and tehn you can check for links, content, etc.


### Factory vs. Fixture article (http://www.slideshare.net/mtoppa/2014-03-11factorygirl)
- You can use neither, and simply create the objects in your test file.
- Fixture (default in Rails): set up yml files in fixtures folder with param values for each object.
    + E.g., if yml file has a candidate named :mike, in your test you can say `candidate = candidates(:mike)`
    + Pros:
        + Simple scenarios, reusable across tests.
        + Easy to read.  Tests are fast (ActiveRecord is bypassed)
    + Cons
        * Brittle: must update fixtures when you add fields to model.
        * Fixture files an external dependency.
        * Not dymanic - you get same values every time.
- Factory
    + Create objects in test file.
    + Can use faker gem for randomized values
    + Instantiation options: create (save to DB), build (memory only, but saves associated objects to DB), build_stubbed (memory only)
        * Use build_stubbed when possible.
        * Use create or build for integration testing.
    + Can use child factories, traits.  Don't over-use these.
    + Pros of factories:
        * Not as brittle
        * Lessened external dependency, more flexibility.
        * When using build_stub your tests will be faster.
