BIBLECHALLENGES.COM
==================

##Tests

Run the Spork test server ` $ spork`. It forks a copy of the server each time you run the tests rather than using the Rails constant unloading to reloadthe files. Way faster!!

Then in a different console ` $ time rspec` (it will run all the specs).

> As we're using Rspec please take in count this [guideline](http://betterspecs.org/).
>

Note: DO NOT FORGET TO RUN THE TESTS BEFORE PUSH.