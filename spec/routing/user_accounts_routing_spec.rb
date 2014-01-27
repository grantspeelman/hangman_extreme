require "spec_helper"

describe UserAccountsController do
  describe "routing" do
    it "builds mxit authorise" do
      url = mxit_authorise_url(response_type: 'code',
                               host: "auth.mxit.com",
                               client_id: '123',
                               redirect_uri: edit_user_accounts_url(host: "test.host"),
                               scope: "profile/private")
      url.should include("http://auth.mxit.com")
      url.should include("response_type=code")
      url.should include("client_id=123")
      url.should include("redirect_uri=http%3A%2F%2Ftest.host%2Fprofile")
      url.should include("profile%2Fprivate")
    end

    it "routes to #mxit_oauth" do
      get("/profile/mxit_oauth").should route_to("user_accounts#mxit_oauth")
    end

    it "routes to #profile" do
      get("/profile").should route_to("user_accounts#show")
    end

    it "routes to #edit" do
      get("/profile/edit").should route_to("user_accounts#edit")
    end

    it "routes to #update" do
      patch("/profile").should route_to("user_accounts#update")
    end

    it "routes to #mxit_authorise" do
      get("/authorize").should route_to("user_accounts#mxit_authorise")
    end
  end
end
