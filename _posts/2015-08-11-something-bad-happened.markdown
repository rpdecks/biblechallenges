---
layout: post
title:  "Lost some data on Aug 10, 2015.  Also, updates."
date:   2015-08-11
categories: updates
comments: true
---

Yesterday, at around 1030am Eastern time, someone deleted the entire production database of Bible Challenges from the server.  That someone was me.

It happened (besides the obvious reason of my being careless) because I needed some Amazon S3 keys to get biblechallenges running on my home computer so I could make some improvements.  I copied a bunch of keys from the production server, and one of the items I copied was the DATABASE\_URL ENV variable, which pointed to the production database.  Because I had that value set, when I ran the server at home, instead of using the local database on my computer, my home computer connected to the production database in the cloud and deleted everything.

Then, when I went to restore a backup, I found that the daily backups had not been turned on (also my fault) and that the most recent backup was four days old.  

All in all, a terrible morning.  We panicked and eventually because we had no alternative, just restored the four day old backup.  Which meant that any accounts, any challenges, and any readings logged in the last four days would be erased.

It doesn't really shine through below, but this was a very unhappy 20 minutes:

![sad transcript](http://318ce10a4aff81d8fd77-9942159f0cde80bd1f0d981f1d813960.r48.cf1.rackcdn.com/mac-mini/Screen%20Shot%202015-08-11%20at%2011.17.15%20AM.png)

I'm very sorry I made this mistake.  Now backups are set up daily (and by the end of the day, probably hourly).  One of the developers felt we should offer to massage the statistics for those of you who lost your consistency stat. So what we will do is this:  For the days that we wiped, which are Aug 6-10, roughly, we will mark all the readings on those days as "on\_schedule".  We will give everyone a couple days to re-enter those readings if they got disappeared, then we will update them all at once on Friday.


In better news, one recent improvement is an admin section for challenge creators.  Now, if you are the challenge creator, you have an admin dashboard where you can:

* Send an email to everyone in the challenge ("Ready, Set, Go!, etc.")
* Remove people from the challenge
* Remove groups from the challenge



In closing, I'm very sorry for what happened with the database.  I'm not sure how to make a web site great, but I'm pretty sure I did the opposite yesterday.  

Phil






[biblechallenges]:      http://biblechallenges.com
[nct]: https://collegetraining.org/2015/
[intercom]: https://intercom.io
[ltw]: http://lettheword.com

