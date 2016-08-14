BIBLECHALLENGES.COM
==================

[![Build
Status](https://magnum.travis-ci.com/biblesforamerica/biblechallenges.svg?token=FPGcoGHoxfQhf2jcpsha&branch=master)](https://magnum.travis-ci.com/biblesforamerica/biblechallenges)

1. Once you have cloned the repo, run `bin/setup`.
2. To run the application you need a rails server, sidekiq, and redis running.  You can get all this at once with this command, which will run the services you need in development:

  % foreman start -f Procfile.dev

3. Google authentication and Facebook Authentication will not work; only the devise authentication will work but that is enough to create accounts / login etc
4. In development mode, paperclip will store your images (avatars, etc) locally in your public/images folder
5. `redis-cli flushall` to wipe redis queue, if needed

##Tests

1. You need to seed the test database with some information.  Run this command:  RAILS_ENV=test rake db:seed (how can we make this easier / automatic?)
2. Tests should all pass.  Run them via:  `bundle exec rspec spec`
3. New features should be tested, at least on the unit level

## Schema explanation

A Challenge is a bible reading program that Users can join
A Membership is a join record that associates a User with a Challenge
Each Challenge has many Readings, which are the chapters covered by that Challenge
For every Reading in a Challenge, for every User, there is a MembershipReading that represents the "read" state of that reading for that user

The Challenge, Membership, Reading, and MembershipReading models are the main classes modified moment by moment.
