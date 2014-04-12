# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :feedback do
    user_account
    subject 'MyString'
    message 'MyText'
  end
end
