# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :challenge do
    owner_id 1
    subdomain "MyString"
    name "MyString"
    begindate "2013-10-21"
    enddate "2013-10-21"
  end
end
