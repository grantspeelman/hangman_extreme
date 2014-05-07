require 'spec_helper'

describe SendFeedbackToFreshDesk do
  describe 'perform' do
    before :each do
      @user_account = stub_model(UserAccount, real_name: 'Grant', email: 'm123_mxit@noreply.io')
      @feedback = stub_model(Feedback, subject: 'The message', message: 'long part', user_account: @user_account)
      Feedback.stub(:find).and_return(@feedback)
      subject.stub(:send_suggestion)
    end

    it 'must find the feedback' do
      Feedback.should_receive(:find).with(123).and_return(@feedback)
      subject.perform(123)
    end

    it 'must send support' do
      @feedback.support_type = 'support'
      subject.should_receive(:send_support).
        with(email: 'm123_mxit@noreply.io', subject: 'The message', message: 'long part', name: 'Grant')
      subject.perform(123)
    end

    it 'must send suggestion' do
      @feedback.support_type = 'suggestion'
      subject.should_receive(:send_suggestion).
        with({email: 'm123_mxit@noreply.io', subject: 'The message', message: 'long part', name: 'Grant'}, @user_account)
      subject.perform(123)
    end

    it 'must use the message as subject if not subject' do
      @feedback.support_type = 'support'
      @feedback.subject = nil
      subject.should_receive(:send_support).
        with(email: 'm123_mxit@noreply.io', subject: 'long part', message: 'long part', name: 'Grant')
      subject.perform(123)
    end

  end

  describe 'send_support' do
    it 'must send the support' do
      stub_request(:post, "http://#{ENV['FRESHDESK_API_KEY']}:X@ubxdmxitapps.freshdesk.com/helpdesk/tickets.json").
        with(:body => {'helpdesk_ticket' =>{ 'description' => 'hello', 'email' => 'test@mail.com', 'subject' => '[ACCS] Test subject'}}).
        to_return(:status => 200, :body => '{}', :headers => {})
      subject.send_support(name: 'Grant', email: 'test@mail.com', subject: 'Test subject', message: 'hello')
    end
  end

  describe 'send_suggestion' do
    before :each do
      FreshDeskContact.stub(:find_or_create_by_user_account).and_return(FreshDeskContact.new(id: '11'))
    end

    it 'must send the support' do
      stub_request(:post, "http://#{ENV['FRESHDESK_API_KEY']}:X@ubxdmxitapps.freshdesk.com/categories/1000038701/forums/1000156079/topics.json").
        with(:body => {'topic' => {'body_html' => 'hello', 'locked' => '0', 'sticky' => '0', 'title' => 'Test subject', 'user_id' => '11'}}).
        to_return(:status => 200, :body => '', :headers => {})
      subject.send_suggestion({email: 'test@mail.com', subject: 'Test subject', message: 'hello'}, UserAccount.new(email: 'test@mail.com'))
    end
  end
end
