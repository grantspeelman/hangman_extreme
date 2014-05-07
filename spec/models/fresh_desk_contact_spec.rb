require 'spec_helper'

describe FreshDeskContact do
  describe '.find_or_create_by_user_account' do
    context 'contact exists' do
      it 'returns' do
        stub_request(:get, "http://#{ENV['FRESHDESK_API_KEY']}:X@ubxdmxitapps.freshdesk.com/contacts.json?query=email%20is%20example.com&state=all").
          to_return(:status => 200, :body => "[{\"user\":{\"active\":false,\"address\":null,\"created_at\":\"2014-05-05T08:28:47+03:00\",\"customer_id\":null,\"deleted\":false,\"description\":null,\"email\":\"test@example.com\",\"external_id\":null,\"fb_profile_id\":null,\"helpdesk_agent\":false,\"id\":1002471758,\"job_title\":null,\"language\":\"en\",\"mobile\":null,\"name\":\"Joe\",\"phone\":null,\"time_zone\":\"Athens\",\"twitter_id\":null,\"updated_at\":\"2014-05-05T08:28:47+03:00\"}}]", :headers => {})
        contact = FreshDeskContact.find_or_create_by_user_account(UserAccount.new(real_name: 'Person', email: 'example.com'))
        contact.name.should == 'Joe' # it uses the value from the response not the UserAccount
        contact.email.should == 'test@example.com'
      end
    end

    context 'contact does not exist' do
      before :each do
        stub_request(:get, "http://#{ENV['FRESHDESK_API_KEY']}:X@ubxdmxitapps.freshdesk.com/contacts.json?query=email%20is%20grant@example.com&state=all").
          to_return(:status => 200, :body => '[]', :headers => {})
      end

      def stub_post(request,response = '{}')
        stub_request(:post, "http://#{ENV['FRESHDESK_API_KEY']}:X@ubxdmxitapps.freshdesk.com/contacts.json").
          with(:body => request).
          to_return(:status => 200, :body => response, :headers => {})
      end

      it 'creates a new contact' do
        stub_post('user' => {'email' => 'grant@example.com', 'name' => '', 'phone' => ''})
        contact = FreshDeskContact.find_or_create_by_user_account(UserAccount.new(email: 'grant@example.com'))
        contact.should be_kind_of(FreshDeskContact)
      end

      it 'sets contact values' do
        stub_post({'user' => {'email' => 'grant@example.com', 'name' => 'Grant', 'phone' => '123'}},
                   "{\"user\":{\"active\":false,\"address\":null,\"created_at\":\"2014-05-07T08:31:49+03:00\",\"customer_id\":null,\"deleted\":false,\"description\":null,\"email\":\"grant@example.com\",\"external_id\":null,\"fb_profile_id\":null,\"id\":1002507205,\"job_title\":null,\"language\":\"en\",\"mobile\":null,\"name\":\"Grant\",\"phone\":\"123\",\"time_zone\":\"Athens\",\"twitter_id\":null,\"updated_at\":\"2014-05-07T08:31:49+03:00\"}}"
                 )
        contact = FreshDeskContact.find_or_create_by_user_account(UserAccount.new(real_name: 'Grant', email: 'grant@example.com', mobile_number: '123'))
        contact.name.should == 'Grant'
        contact.email.should == 'grant@example.com'
        contact.phone.should == '123'
      end
    end
  end
end
