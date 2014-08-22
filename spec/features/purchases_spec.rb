require 'features_helper'

describe 'purchases', :redis => true do
  context 'as mxit user', :google_analytics_vcr => true do
    before :each do
      @current_user_account = mxit_user_account('m2604100')
      @credits = @current_user_account.credits
      set_mxit_headers('m2604100') # set mxit user
      stub_mxit_oauth # stub mixt profile auth
    end

    it 'must allow user to purchase credits' do
      visit_home
      click_link('profile')
      page.should have_content("#{@credits} credits")
      click_link('buy_credits')
      click_link('buy_credits11')
      click_link('submit')
      click_link('profile')
      page.should have_content("#{@credits + 11} credits")
    end

    it 'must allow user to cancel purchase of clue points' do
      visit_home
      click_link('profile')
      page.should have_content("#{@credits} credits")
      click_link('buy_credits')
      click_link('buy_credits11')
      click_link('cancel')
      click_link('profile')
      page.should have_content("#{@credits} credits")
    end
  end
end
