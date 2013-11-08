Biblechallenge
==

Todo List
--

- A user should be able to create a challenge
  Challenge: A challenge has a begin date and an end date, and has a
  title, and a number of participants.

- A VISITOR should also be able to join a challenge as a participant
  I should be able to join multiple challenges at the same time
  (has_many :through).
  Visitor may sign up for a challenge just using his e-mail address. We
should generate a password for them and mail it to them (?)
- As a bible challenge participant, I want to be able to sign up for a
  challenge by submitting my email on a signup page that corresponds to
  subdomain.biblechallenges.com

- As a bible challenge creator, I want to be able to create a challenge
  so that others can sign up for challenge I create.

- As a visitor to the main site, on the home page I want to see
  information about what bible challenges are so that the site makes
  sense to me

- As a bible challenge creator I want to be able to set begin times and
  end times for my bible challenges that I create so that people who
  join them can know what they are getting involved with

- As a visitor to subdomain.biblechallenges.com (a page specific to a
  challenge), I want to see a form where I can enter my email and submit
  it so that I can be enrolled in the challenge

- As a participant in a challenge, I want to receive a daily email on
  each day of the challenge that contains that day's verses, so that I
  can easily read them and submit my results

- As a bible challenge creator, I want to be able to assign one or more
  chapters to each day in my challenge, so that participants will have
  something to read on each day of the challenge

- As a bible challenge participant, I want to be able to click on a link
  at the bottom of my daily email that will take me to a page where I
  can confirm that I read that day's reading so I can log my reading for
  the challenge easily

- As a bible challenge creator, I want to be able to sign others up for
  the challenge that I created so that they don't need to fill out the
  form online

- As a bible challenge participant, I want to be able to click on a link
  at the bottom of my daily email that will take me to a page where I
  can make a comment on that day's reading so that I can participate in a
  discussion about that chapter with other participants of my challenge

We should provide a persistence_token on the e-mail link, so users
get signed in automatically from the link.




### Conceptual Design

#### Models

Challenge
  attr_accessible :subdomain, :begin_date, :end_date, :title, as:
:creator

  has_many   :memberships
  has_many   :users, through: :memberships
  has_many   :readings
  has_many   :chapters, through: :readings

  belongs_to :creator

Chapter
  attr_accessible :name, as: :admin

  has_many :chapter_challenges
  has_many :challenges, through: :chapter_challenges

Membership
  attr_accessible :user_id, :challenge_id

  belongs_to :user
  belongs_to :challenge

Reading
  attr_accessible :chapter_id, :challenge_id, :date

  belongs_to :challenge
  belongs_to :chapter

  has_many :user_readings
  has_many :users, through: :user_readings

User

  has_many :memberships
  has_many :challenges, through: :memberships
  has_many :readings, through: :user_readings
  has_many :chapters, through: :readings


#### Controllers

Challenges::MembershipsController
vs 
MembershipsController   ?
-- new action should display a form with an email address
-- create should create a membership for that user unless one exists



POST  /challenges/:subdomain/memberships
create(email) 
User#join_challenge(email, challenge)


ChallengesController

GET /challenges
index
Paginate Challenges

GET /challenges/:id

GET /reading/:id
Authenticated User
ReadingsController
show(reading_id)

POST /readings/:id/user_readings
UserReadingsController

create(reading_id)

Done
--

- [DONE] The user should be logged in, before creating a challenge.
  Guests (not logged in users) should not be able to create challenges.
  Challenges have owners (single owner per challenge).

