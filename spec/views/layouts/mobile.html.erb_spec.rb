require 'view_spec_helper'

describe "layouts/mobile" do
  before(:each) do
    @current_user_account = stub_model(UserAccount, id: 50)
    view.stub(:current_user_account).and_return(@current_user_account)
    view.stub(:current_page?).and_return(false)
    view.stub(:smaato_ad).and_return(false)
    view.stub(:mxit_request?).and_return(false)
  end

  it "should have a home link" do
    render
    rendered.should have_link("Home", href: root_path)
  end
end
