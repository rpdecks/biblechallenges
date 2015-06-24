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

## Environmental Variables

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
Note: Under `APIs` remember to enable (Contacts API) and (Google+ API). Under `Credentials`, click `Create new client id`.

##Tests

This app uses seed data on the test db, so please be sure to run `rake db:seed RAILS_ENV=test` when cloning and before starting to work on it.

Then in a different console ` $ time rspec` (it will run all the specs).

As we're using Rspec please take in count this [guideline](http://betterspecs.org/).


Note: DO NOT FORGET TO RUN THE TESTS BEFORE PUSH.

## Mail Preview

go to `localhost:3000/mail_view`

## Development emails

mailcatcher gem is installed
run % mailcatcher 
go to localhost:1080 to see dev emails


## Schema explanation

A Challenge is a bible reading program that Users can join
A Membership is a join record that associates a User with a Challenge
Each Challenge has many Readings, which are the chapters covered by that Challenge
For every Reading in a Challenge, for every User, there is a MembershipReading that represents the "read" state of that reading for that user

The Challenge, Membership, Reading, and MembershipReading models are the main classes modified moment by moment.

