require 'sidekiq'
require 'uservoice-ruby'

class SendFeedbackToFreshDesk
  include Sidekiq::Worker
  sidekiq_options :backtrace => true

  def perform(feedback_id)
    feedback =  Feedback.find(feedback_id)
    send_options = {:email => feedback.user_account_email,
                    :subject => "#{feedback.subject || feedback.message[0,30]}",
                    :message => feedback.message,
                    :name => feedback.user_account_real_name || CGI::unescape(feedback.user_account_name).gsub(/[^a-zA-Z0-9\s]/, '')}
    if feedback.support_type == 'suggestion'
      send_suggestion(send_options,feedback.user_account)
    else
      send_support(send_options)
    end
  end

  def send_suggestion(options,user_account)
    topic = {
      sticky: 0,
      locked: 0,
      title:  options[:subject],
      body_html: options[:message],
      user_id: FreshDeskContact.find_or_create_by_user_account(user_account).id
    }
    FreshDeskConnection.instance.post '/categories/1000038701/forums/1000156079/topics.json', {
      topic: topic
    }
  end

  def send_support(options)
    FreshDeskConnection.instance.post '/helpdesk/tickets.json', {
      helpdesk_ticket: {
        description: options[:message],
        subject: "[ACCS] #{options[:subject]}",
        email:  options[:email]
      }
    }
  end
end
