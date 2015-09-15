# [Rales Engine](https://github.com/turingschool/lesson_plans/blob/master/ruby_03-professional_rails_applications/rales_engine.md)

# Use Rails + ActiveRecord: build a JSON API to expose the SalesEngine data schema

# Learning Goals:
 - Build Single-Responsibility Controllers that provide an API that's (a) well-designed and (b) versioned
 - Use controller tests to drive design.
 - Use Ruby and ActiveRecord to perform complicated business intelligence.

[Technical Expectations](https://github.com/turingschool/lesson_plans/blob/master/ruby_03-professional_rails_applications/rales_engine.md#-technical-expectations)

# Setup

run `git clone git@github.com:adamcaron/rales_engine.git`

To setup and populate the database:
run `rake db:create`
run `rake db:migrate`
run `rake import`

To run the test suite:
run `rspec`