# == Schema Information
#
# Table name: user_accounts
#
#  id            :integer          not null, primary key
#  uid           :string(255)      not null
#  provider      :string(255)      not null
#  mxit_login    :string(255)
#  real_name     :string(255)
#  mobile_number :string(255)
#  email         :string(255)
#  credits       :integer          default(24)
#  prize_points  :integer          default(0)
#  lock_version  :integer          default(0), not null
#  created_at    :datetime
#  updated_at    :datetime
#
require 'mxit_api'

class UserAccount < ActiveRecord::Base
  validates :provider, :uid, presence: true
  validates_uniqueness_of :uid, :scope => :provider
  validates_numericality_of :credits, greater_than_or_equal_to: 0

  scope :mxit, -> { where(:provider => 'mxit') }

  def self.find_or_create_from_auth_hash(auth_hash)
    auth_hash.stringify_keys!
    return nil if auth_hash['uid'].blank? || auth_hash['provider'].blank?
    user_account = find_or_create_by(uid: auth_hash['uid'],provider: auth_hash['provider'])
    user_account.set_user_account_info(auth_hash['info'])
    return user_account
  end

  def set_user_account_info(info)
    if info
      info.stringify_keys!
      self.name = info['name']
      self.mxit_login = info['login']
      self.email = info['email'] if email.blank?
      save
    end
  end

  def utma(*args)
    GoogleTracking.find_or_create_by_user_id(id).utma(*args)
  end

  def registered_on_mxit_money?(connection = MxitMoneyApi.connect(ENV['MXIT_MONEY_API_KEY']))
    if connection
      result = connection.user_info(:id => uid)
      result[:is_registered]
    end
  rescue Exception => e
    Airbrake.notify_or_ignore(e,:parameters => {:user => self, :connection => connection})
    false
  end

  def mxit?
    provider == 'mxit'
  end

  def facebook?
    provider == 'facebook'
  end
end
