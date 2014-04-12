require 'grape'

module V1
  class Api < Grape::API
    version 'v1', using: :header, vendor: 'quickapps'
    prefix 'api'
    format :json

    helpers do
      def authenticate!
        error!('401 Unauthorized', 401) unless headers['X-Api-Token'].to_s == ENV['API_KEY'].to_s
      end

      def clean_params(params)
        ActionController::Parameters.new(params)
      end

      def user_params
        clean_params(params).permit(:uid, :provider, :name, :real_name, :mobile_number, :mxit_login, :email, :credits, :prize_points, :lock_version)
      end
    end

    resource :user_accounts do
      desc 'get Account'
      get ':id' do
        authenticate!
        UserAccount.find(params[:id])
      end

      desc 'find Accounts'
      get do
        authenticate!
        user_accounts = UserAccount.all
        user_params.each do |key,value|
          user_accounts = UserAccount.where(key => value)
        end
        user_accounts
      end

      desc 'Update Account'
      put ':id' do
        authenticate!
        account = UserAccount.find(params[:id])
        account.update_attributes!(user_params)
        account
      end

      desc 'Create Account'
      post do
        authenticate!
        ua = UserAccount.new(user_params)
        if ua.save
          status 201
          ua
        else
          status 400
          {:errors => ua.errors}
        end
      end
    end
  end
end
