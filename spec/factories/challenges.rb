# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :challenge do
    subdomain "MyString"
    name "MyString"
    begindate "2013-10-21"
    enddate "2013-10-21"
  end
end
