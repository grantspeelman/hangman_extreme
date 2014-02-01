require 'grape'

module V1
  class Api < Grape::API
    version 'v1', using: :header, vendor: 'quickapps'
    prefix 'api'
    format :json

    helpers do
      def authenticate!
        error!('401 Unauthorized', 401) unless env['API_KEY'].to_s == ENV['API_KEY'].to_s
      end

      def clean_params(params)
        ActionController::Parameters.new(params)
      end
    end

    resource :user_accounts do
      desc "get Account"
      params do
        requires :uid, type: String, desc: "User uid"
        requires :provider, type: String, desc: "User provider"
      end
      get do
        authenticate!
        UserAccount.find_by(uid: params[:uid],provider: params[:provider])
      end

      desc "Update Account"
      put ':id' do
        authenticate!
        account = UserAccount.find(params[:id])
        user_params = clean_params(params).permit(user_account: [:real_name, :mobile_number, :mxit_login, :email, :credits, :prize_points])[:user_account]
        account.update_attributes!(user_params)
        status 204
      end

      desc "Create Account"
      post do
        authenticate!
        user_params = clean_params(params).permit(user_account: [:uid, :provider, :real_name, :mobile_number, :mxit_login, :email, :credits, :prize_points])[:user_account]
        ua = UserAccount.new(user_params)
        if ua.save
          status 201
          header('Location', "http://#{request.host_with_port}/api/user_accounts/#{ua.id}")
          body ''
        else
          status 400
          ua.errors
        end
      end
    end
  end
end
