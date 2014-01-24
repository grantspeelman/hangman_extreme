require 'spec_helper'
require 'cancan/matchers'

describe Ability do
  context "User" do
    before :each do
      @user_account = create(:user_account)
      @ability = Ability.new(@user_account)
    end

    context "Feedback" do
      it "must be able to view" do
        @ability.should be_able_to(:read, Feedback)
      end

      it "wont be able to read other users" do
        feedback = create(:feedback, user_account: create(:user_account))
        @ability.should_not be_able_to(:read, feedback)
      end

      it "must be able to read own" do
        feedback = create(:feedback, user_account: @user_account)
        @ability.should be_able_to(:read, feedback)
      end

      it "must be able to create" do
        @ability.should be_able_to(:create, Feedback)
      end
    end

    context "User Accounts" do
      it "must be able to read users" do
        @ability.should be_able_to(:read, UserAccount)
      end

      it "must be able update self" do
        @ability.should be_able_to(:update, @user_account)
      end

      it "wont be able update other users" do
        other_user = create(:user_account)
        @ability.should_not be_able_to(:update, other_user)
      end
    end

    context "Purchase Transactions" do
      it "must be able to view purchase transactions" do
        @ability.should be_able_to(:read, PurchaseTransaction)
      end

      it "wont be able to read other users purchase_transactions" do
        trans = create(:purchase_transaction, user_account: create(:user_account))
        @ability.should_not be_able_to(:read, trans)
      end

      it "must be able to read own purchase_transactions" do
        trans = create(:purchase_transaction, user_account: @user_account)
        @ability.should be_able_to(:read, trans)
      end

      it "must be able to create purchase_transactions" do
        @ability.should be_able_to(:create, PurchaseTransaction)
      end
    end

    context "Redeem Winnings" do
      it "must be able to view redeem_winning" do
        @ability.should be_able_to(:read, RedeemWinning)
      end

      it "wont be able to read other users redeem_winnings" do
        trans = create(:redeem_winning, user_account: create(:user_account, prize_points: 2))
        @ability.should_not be_able_to(:read, trans)
      end

      it "must be able to read own redeem_winnings" do
        @user_account.increment!(:prize_points)
        trans = create(:redeem_winning, user_account: @user_account)
        @ability.should be_able_to(:read, trans)
      end

      it "must be able to create redeem_winning" do
        @ability.should be_able_to(:create, RedeemWinning)
      end
    end

    context "Airtime Vouchers" do
      it "must be able to read airtime vouchers" do
        @ability.should be_able_to(:read, AirtimeVoucher)
      end

      it "wont be able to read other users airtime vouchers" do
        airtime_voucher = create(:airtime_voucher, user_account: create(:user_account, prize_points: 2))
        @ability.should_not be_able_to(:read, airtime_voucher)
      end

      it "must be able to read own airtime vouchers" do
        airtime_voucher = create(:airtime_voucher, user_account: @user_account)
        @ability.should be_able_to(:read, airtime_voucher)
      end
    end
  end
end
