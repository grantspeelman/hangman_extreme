# == Schema Information
#
# Table name: airtime_vouchers
#
#  id                :integer          not null, primary key
#  redeem_winning_id :integer
#  user_id           :integer
#  freepaid_refno    :string(255)
#  network           :string(255)
#  pin               :string(255)
#  sellvalue         :float
#  response          :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :airtime_voucher do
    redeem_winning
    freepaid_refno "MyString"
    network "MyString"
    sellvalue 1.5
    response "MyText"
    pin "123123"
  end
end
