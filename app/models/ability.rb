require 'cancan'
class Ability
  include CanCan::Ability

  def initialize(user_account)
    can :read, UserAccount

    can :update, user_account

    can :read, PurchaseTransaction, user_account_id: user_account.id
    can :read, RedeemWinning, user_account_id: user_account.id
    can :read, AirtimeVoucher, user_account_id: user_account.id
    can :read, Feedback, user_account_id: user_account.id

    can :create, PurchaseTransaction
    can :create, RedeemWinning
    can :create, Feedback
  end
end
