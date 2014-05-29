BIBLECHALLENGES.COM
==================

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
9.  also added biblechallenges.com and *.biblechallenges.com in the domains add page



##Tests

*This app uses seed data on the test db, so please be sure to run `rake db:seed RAILS_ENV=test` when cloning and before starting to work on it.

Run the Spork test server ` $ spork`. It forks a copy of the server each time you run the tests rather than using the Rails constant unloading to reloadthe files. Way faster!!

Then in a different console ` $ time rspec` (it will run all the specs).

If you run any migration or change any route while _spork_ is running then you'll have to restart _spork_.

> As we're using Rspec please take in count this [guideline](http://betterspecs.org/).
>

Note: DO NOT FORGET TO RUN THE TESTS BEFORE PUSH.

## Mail Preview

go to localhost:3000/mail_view


