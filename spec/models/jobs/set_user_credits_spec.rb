require 'spec_helper'

describe Jobs::SetUserCredits do
  describe 'run' do
    context 'add_clue_point_to_active_players!' do
      it 'must set user credits to 50' do
        user_account = create(:user_account, credits: 49)
        Jobs::SetUserCredits.new.run
        user_account.reload
        user_account.credits.should == 50
      end

      it 'wont decrease user credits to 50' do
        user_account = create(:user_account, credits: 51)
        Jobs::SetUserCredits.new.run
        user_account.reload
        user_account.credits.should == 51
      end
    end
  end

  describe 'on_error' do
    it 'must send the error to airbrake' do
      Airbrake.should_receive(:notify_or_ignore).with('Error!',anything())
      Jobs::SetUserCredits.new.on_error('Error!')
    end
  end

  describe 'execute' do
    context 'if less than 50' do
      it 'must update user credits to 50 ' do
        user = create(:user_account, :credits => 49)
        Jobs::SetUserCredits.execute
        user.reload
        user.credits.should == 50
      end
    end
  end
end
