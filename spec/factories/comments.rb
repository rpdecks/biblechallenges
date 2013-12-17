# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :reading_comment, class: "Comment" do
    association :commentable, factory: :reading
    content "A message!"
    association :user
    invisible false
    flag_count 0
  end
end
