BIBLECHALLENGES.COM
==================

[![Build
Status](https://magnum.travis-ci.com/biblesforamerica/biblechallenges.svg?token=FPGcoGHoxfQhf2jcpsha&branch=master)](https://magnum.travis-ci.com/biblesforamerica/biblechallenges)
## Setup on heroku

Addons needed:  postgres hobby basic ($9), heroku scheduler, pg backups, redis to go nano, and zerigo dns tier 1 ($7)

1. clone origin into your "production" folder
2. heroku git:remote -a biblechallenges
3. promote the new (basic) db with:  heroku pg:promote HEROKU_POSTGRESQL_PURPLE
4. zerigo settings should look like this: https://www.dropbox.com/s/kt51jxbq4nbqrv2/Screenshot%202014-01-09%2012.08.13.png
5. also change nameservers for domain to [a-e].ns.zerigo.net
6.  push to heroku
7.  rake db:migrate
8.  rake db:seed  (to get the verse data in there)  
  - Note: always run `rake db:seed RAILS_ENV=test` as well for tests to work properly

## Environmental Variables

### Omniauth

In order to setup omniauth login, you will need
two environment variables for each provider.
The instruction are different for each provider.

#### Facebook
You will need two environment variables:
 - `FACEBOOK_APP_ID`
 - `FACEBOOK_SECRET`

They will hold the id and secret keys for each omniauth app.
You can obtain these keys by setting up the app at `facebook.com/developer`
Note: on facebook.com, go to `Settings` and then `Add Platform` for website.

#### Google
You will need two environment variables:
 - `GOOGLE_CLIENT_ID`
 - `GOOGLE_CLIENT_SECRET`

You can obtain from registering app at to `console.developers.google.com`
Note: Under `APIs` remember to enable (Contacts API) and (Google+ API). 
Setup Credentials:
 1. Go to `Credentials`
 2. Click `Add Credentials` 
 3. Select `OAuth 2.0 Client ID`
 4. Select `Web Application`
 5. Type in the `Authorized redirect URIs`

### AWS
You will need four environment variables: 
- `AWS_BUCKET_NAME`
- `AWS_HOST_NAME`
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

Please put them in your application.yml if you want aws to work properly.

##Tests

This app uses seed data on the test db, so please be sure to run `rake db:seed RAILS_ENV=test` when cloning and before starting to work on it.

Then in a different console ` $ time rspec` (it will run all the specs).

As we're using Rspec please take in count this [guideline](http://betterspecs.org/).


Note: DO NOT FORGET TO RUN THE TESTS BEFORE PUSH.

## Mail Preview

go to `localhost:3000/inbox`

## Development Server

run `redis-server` to queue jobs/avoid errors, along with rails server.

## Development emails

goatmail gem is installed
`bundle exec sidekiq` to execute background email jobs (redis-server needs to be running)
go to localhost:3000/inbox to view dev emails, email links open in localhost

`redis-cli flushall` to wipe redis queue, if needed


## Schema explanation

A Challenge is a bible reading program that Users can join
A Membership is a join record that associates a User with a Challenge
Each Challenge has many Readings, which are the chapters covered by that Challenge
For every Reading in a Challenge, for every User, there is a MembershipReading that represents the "read" state of that reading for that user

The Challenge, Membership, Reading, and MembershipReading models are the main classes modified moment by moment.

