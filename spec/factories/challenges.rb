# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :challenge do
    subdomain "mystring"
    name "myname"
    begindate "2013-10-21"
    enddate "2013-11-21"
  end
end
