require 'spec_helper'

describe ExplainController do
  before :each do
    controller.stub(:send_stats)
  end

  describe "GET 'about'" do
    it 'returns http success' do
      get 'about'
      response.should be_success
    end
  end
end
