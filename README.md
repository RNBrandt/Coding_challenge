# Welcome

This application enables easy, private communications via an open source server. Since email and SMS are not reliably
encrypted, easycomm sends a notification via these channels that you have an encrypted message on the easycomm server.

Easycomm is not full-featured.  It lacks some basic things, such as authentication.  Your pull requests are welcome,
but the goal of easycomm is primarily to contain clear, easy to understand code.

# Setup

- Install Ruby version 2.2.2 (on windows, use version 2.0.x or 2.1)

- Install git

- Install Postgresql

- Clone this repository

- `bundle install` to install necessary libraries

- `rake db:create:all db:migrate db:test:prepare` to set up your database models

- `rake spec` to run the test suite

- `rails s` to run the server

# Challenge

This application should support SMS, but it doesn't seem to be working.  By entering phone numbers into the sender and
recipient fields for your message, you should be able to send a text message to your phone.

- The tests currently in the repository need to pass

- For any new code you add, public methods should be tested

- You'll need a developer Twilio account to make this work. Do not commit your credentials to the repo.

- To get the tests to pass, you'll want to use test credentials from Twilio.

# Submission

- You have been granted access to an individual bitbucket repository. If you do not complete the challenge within your allotted time, your access may expire.  Please contact us if you need additional time.

- As you work on the challenge, commit your work to a branch other than master.  You can create and start work on a new branch with `git checkout -b your_branch_name`

- Submit your work by creating a pull request to the master branch of your repo.

- Within your pull request, explain your rationale for your approach to the problem.
    - Why add those methods or objects?
    - Why modify where you modified, not elsewhere?

- Your employer contact will be notified once you've submitted the challenge.  Please give us 1 week to evaluate your work and get back to you.

# Resources

- [Bitbucket setup](https://confluence.atlassian.com/display/BITBUCKET/Bitbucket+101)
- [Twilio API docs](https://www.twilio.com/docs/api/rest/sending-messages)
- [Configuring your keys](http://richonrails.com/articles/the-rails-4-1-secrets-yml-file)
- [First time on Rails?](https://www.railstutorial.org/book)
