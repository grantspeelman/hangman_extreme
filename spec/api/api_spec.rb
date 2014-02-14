require 'spec_helper'

RSpec.configure do |config|
  config.include RSpec::Rails::RequestExampleGroup, type: :request, example_group: {
    file_path: /spec\/api/
  }
end

describe V1::Api do
  describe "GET /api/user_accounts" do
    it "returns null if account does not exist" do
      get "/api/user_accounts?uid=test&provider=again"
      response.status.should == 200
      response.body.should == '[]'
    end
    #
    it "returns a new account" do
      user_account = create(:user_account, uid: 'hello', provider: 'world')
      get "/api/user_accounts?uid=hello&provider=world"
      response.status.should == 200
      parsed_response = JSON.parse(response.body).first
      parsed_response['id'].should == user_account.id
      parsed_response['uid'].should == user_account.uid
      parsed_response['provider'].should == user_account.provider
    end
  end

  describe "PUT /api/user_accounts/:id" do
    it "updates" do
      user_account = create(:user_account, uid: 'hello', provider: 'world')
      put "/api/user_accounts/#{user_account.id}", real_name: 'Kim'
      response.status.should == 200
      user_account.reload
      user_account.real_name == 'Kim'
    end
  end

  describe "POST /api/user_accounts" do
    it "creates" do
      post "/api/user_accounts", real_name: 'EG', uid: 't1', provider: 't2'
      response.status.should == 201
      user_account = UserAccount.last
      user_account.real_name == 'EG'
      user_account.uid == 't1'
      user_account.provider == 't2'
    end

    it "wont create duplicates" do
      user_account = create(:user_account, uid: 't1', provider: 't2')
      post "/api/user_accounts", real_name: 'EG', uid: 't1', provider: 't2'
      response.status.should == 400
      user_account.real_name == 'EG'
      response.body.should == '{"errors":{"uid":["has already been taken"]}}'
    end
  end
end
