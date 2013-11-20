

Nov 19 2013

Estaban:

Thank you for your assistance.  I have some limited background in RoR and I am trying to get better, so 
I will ask you for clarification on things from time to time.  I hope that is ok.  I especially need
help with testing.

SUMMARY OF BIBLECHALLENGES.COM
---------------------------------------

The app allows for a user to create one or more "challenges" for other users.

What is a challenge?  A challenge has:
* A begin and end date
* A name and subdomain (accessible through the subdomain)
* A range of bible chapters that are distributed across the days of the challenge

So here is a simple example for a challenge:

Name: Estebans challenge (assume the id of the challenge is 1)
Subdomain: esteban.biblechallenges.com  (although we are using bcstaging.com as a staging server)
Dates: Dec 1 to Dec 5
Chapters: Matthew 1 to Matthew 5

If you visit the challenge creation page in the creator namespace, you can see that this information
is all that is collected to create a challenge.  Right now it is just stored in the challenge model, 
and that brings me to the first TODO for you:

****************************************************************************
TODO:  upon challenge creation, create a reading for every chapter assigned 
in the challenge.  The readings should belong to the challenge and have a date 
assigned, as well as belong to a chapter and challenge.

So going back to the example above, after creation it should have five readings:

|challenge_id | date | chapter_id|
|-------------|------|-----------|
1 | 2013-12-1 | 40001
1 | 2013-12-2 | 40002
1 | 2013-12-3 | 40003
1 |  2013-12-4 | 40004
1 | 2013-12-5 | 40005

The chapter_id of Matthew 1 through Matthew 5 is 40001 through 40005

The question going through your head is probably "how do I get those
chapters from the string in the challenge that designates the range of 
chapters?"  Well you can use the Chapter.search method, a class method that 
will return all the chapters that match the chapter search string.
Chapter.search("Matthew 1-5") will return all five chapter objects.

****************************************************************************
TODO:
  When a user signs up for a challenge on that challenges subdomain,
  he should be able to choose the version of the Bible he prefers, in a
  select dropdown.  Choices are: ASV ESV KJV NASB NKJV

  This will require adding a field to the membership model
****************************************************************************
TODO:
  A user should not be able to create a challenge with a start date earlier than 
  today.  
****************************************************************************
TODO:
  when a user creates a challenge, and email should be sent to that user
  giving them the challenge details.  Dont worry about the format of the
  email, if you can just put a template there, I can fill in the details.
****************************************************************************
TODO:
  When a visitor comes to a challenge page (i.e, one with a subdomain)
  and joins a challenge, after they enter their username and first and
  last name, a membership is created.  IF they do not have a user account,
  one should be created for that email address silently, and the membership
  should be associated with it.  If they already have an account in the system, 
  the membership should just be added to their existing account.

  Yes, I know this means someone can sign up someone else for a challenge
  by just knowing their email address.  Thats ok.

****************************************************************************
TODO:
  Someone who has already joined a challenge should not be able to join it again
  (validate uniqueness on email)
****************************************************************************
TODO:
  When anyones creates a membership for a challenge, they should receive
  a notification email that has the challenge details.
****************************************************************************
TODO:
  When someone visits a challenge page (subdomain.bc.com) they should see 
  as part of the challenge details a table that shows all the readings,
  i.e, one column has the date and the next column has the chapter to be
  read on that day
****************************************************************************
TODO:

Once a challenge object exists with a bunch of readings, we need to send 
an email to every challenge member each day that contains the text of 
that days chapter.  Notice in the seed.rb file that I seeded the Verse
model with all the verses for each chapter.  Each user should get an email 
that has all the verses for that days chapter.  If possible, send the verses
that match the preferred version of the Bible that the user chose in their
membership for that challenge. If it is not available, just send ASV.  (there are 
five versions in the verses table: ASV, ESV, KJV, NASB, and NKJV).
****************************************************************************

****************************************************************************

