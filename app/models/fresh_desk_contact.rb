class FreshDeskContact < Hashie::Dash

  property :id
  property :active
  property :name
  property :phone
  property :address
  property :customer_id
  property :deleted
  property :description
  property :email
  property :external_id
  property :fb_profile_id
  property :job_title
  property :language
  property :mobile
  property :time_zone
  property :twitter_id
  property :helpdesk_agent
  property :created_at
  property :updated_at

  def self.find_or_create_by_user_account(user_account)
    user_account ||= UserAccount.new
    connection = FreshDeskConnection.instance
    users = JSON.parse(connection.get('/contacts.json', query: "email is #{user_account.email}", state: 'all').body)
    if users.any?
      FreshDeskContact.new(users.first['user'])
    else
      response = connection.post('/contacts.json', {
          user: {
            name: user_account.real_name,
            phone:  user_account.mobile_number,
            email:  user_account.email
          }
        }
      )
      FreshDeskContact.new(JSON.parse(response.body)['user'])
    end
  end
end
