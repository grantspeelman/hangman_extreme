require 'features_helper'

shared_examples 'a registered user' do
  it 'must have a fill in profile information' do
    visit_home
    click_link('authorise')
    page.should have_content('Grant Speelman')
    page.should have_content('0821234567')
    click_link('edit_real_name')
    fill_in 'user_account_real_name', with: 'Joe Barber'
    click_button 'submit'
    click_link('edit_mobile_number')
    fill_in 'user_account_mobile_number', with: '0821234561'
    click_button 'submit'
    page.should have_content('Joe Barber')
    page.should have_content('0821234561')
    click_link('Home')
    page.current_path.should == '/'
  end
end

describe 'user accounts', :redis => true do
  context 'as mxit user', :google_analytics_vcr => true do
    before :each do
      @current_user_account = mxit_user_account('m2604100')
      set_mxit_headers('m2604100') # set mxit user
      stub_mxit_oauth :first_name => 'Grant', :last_name => 'Speelman', :mobile_number => '0821234567'
    end

    it_behaves_like 'a registered user'

    it 'must show the profile if user mxit input is profile' do
      add_headers('X_MXIT_USER_INPUT' => 'profile')
      visit_home
      page.current_path.should == user_accounts_path
    end
  end

  context 'as mobile user', :facebook => true, :smaato_vcr => true, :js => true do
    before :each do
      @current_user_account = facebook_user_account(:real_name => 'Grant Speelman', :mobile_number => '0821234567')
      login_facebook_user_account(@current_user_account)
    end

    it_behaves_like 'a registered user'
  end
end
