class Jobs::SetUserCredits < Jobs::Base

  def run
    # perform work here
    UserAccount.where('credits < 50').update_all(credits: 50)
  end

end
