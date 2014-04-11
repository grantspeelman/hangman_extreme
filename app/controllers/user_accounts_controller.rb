class UserAccountsController < ApplicationController
  before_filter :set_user_account

  def show
  end

  def edit

  end

  def update
    if @user_account.update_attributes(user_params)
      redirect_to user_accounts_path, notice: 'Profile was successfully updated.'
    else
      redirect_to user_accounts_path, alert: @user_account.errors.inspect
    end
  end

  def mxit_authorise
    redirect_to action: 'mxit_oauth', code: 'MXITAUTH', state: params[:state]
  end

  def mxit_oauth
    if params[:code].blank?
      redirect_to mxit_oauth_redirect_to_path, alert: "Authorisation failed: #{params[:error].to_s}"
    else
      begin
        mxit_connection = MxitApiWrapper.connect(:grant_type => 'authorization_code',
                                                 :code => params[:code],
                                                 :redirect_uri => mxit_oauth_user_accounts_url(host: request.host))
        if mxit_connection
          if mxit_connection.scope.include?('profile')
            mxit_user_profile = mxit_connection.profile
            unless mxit_user_profile.empty?
              if current_user_account.real_name.blank?
                current_user_account.real_name = "#{mxit_user_profile[:first_name]} #{mxit_user_profile[:last_name]}"
              end
              if current_user_account.mobile_number.blank?
                current_user_account.mobile_number = mxit_user_profile[:mobile_number]
              end
              if current_user_account.email.blank?
                current_user_account.email = "#{request.env['HTTP_X_MXIT_LOGIN'] || mxit_user_profile[:user_id]}@mxit.im"
              end
              current_user_account.save
            end
          end
          if mxit_connection.scope.include?('invite')
            mxit_connection.send_invite('m40363966002') # mxitid of extremepayout
          end
        end
      rescue Exception => e
        # ignore error
        ENV['AIRBRAKE_API_KEY'].present? ? notify_airbrake(e) : raise
      end
      redirect_to mxit_oauth_redirect_to_path
    end
  end

  private

  def mxit_oauth_redirect_to_path
    if params[:state] == 'feedback'
      feedback_index_path
    else
      user_accounts_path
    end
  end

  def set_user_account
    @user_account = current_user_account
  end

  def user_params
    params[:user_account].permit(:real_name, :mobile_number)
  end
end
