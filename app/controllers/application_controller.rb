require 'cancan'
require 'gabba'
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :load_user, :check_mxit_input_for_redirect
  after_filter :send_stats
  layout :set_layout

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  protected

  def current_user_account
    @current_user_account
  end

  def current_ability
    @current_ability ||= Ability.new(current_user_account)
  end

  def current_user_request_info
    @current_user_request_info ||= UserRequestInfo.new
  end

  def mxit_request?
    current_user_account.try(:mxit?)
  end

  def facebook_user?
    current_user_account.try(:facebook?)
  end

  helper_method :current_user_account, :current_user_request_info, :notify_airbrake, :mxit_request?, :facebook_user?

  def login_required
    return true if current_user_account
    access_denied
  end

  def access_denied
    redirect_to('/', :alert => "You are required to be logged")
    false
  end

  def send_stats
    if tracking_enabled? && current_user_account && mxit_request? && status != 302
      begin
        Timeout::timeout(15) do
          g = Gabba::Gabba.new(tracking_code, request.host)
          g.user_agent = current_user_request_info.user_agent || request.env['HTTP_USER_AGENT']
          g.utmul = current_user_request_info.language || "en"
          g.set_custom_var(1, 'Gender', current_user_request_info.gender || "unknown", 1)
          g.set_custom_var(2, 'Age', current_user_request_info.age || "unknown", 1)
          g.set_custom_var(3, current_user_request_info.country || "unknown Country", current_user_request_info.area || "unknown", 1)
          g.set_custom_var(5, 'Provider', current_user_account.provider, 1)
          g.identify_user(current_user_account.utma(true))
          g.ip(request.remote_ip)
          g.page_view("#{params[:controller]} #{params[:action]}", request.fullpath,current_user_account.id)
        end
      rescue Timeout::Error => te
        Rails.logger.warn(te.message)
        Settings.ga_tracking_disabled_until = 1.minute.from_now # disable for a 1 minute
      rescue Exception => e
        ENV['AIRBRAKE_API_KEY'].present? ? notify_airbrake(e) : Rails.logger.error(e.message)
        Settings.ga_tracking_disabled_until = 20.minutes.from_now# disable for a 20 minutes
        raise e unless Rails.env.production?
      end
    end
  end

  def load_user
    if request.env['HTTP_X_MXIT_USERID_R'] # load mxit user
      load_mxit_user
    elsif params[:signed_request]
      load_facebook_user
    else # load browser user
      @current_user_account = UserAccount.find_by(:uid => session[:current_uid],:provider => session[:current_provider])
    end
  end

  def set_layout
    if current_user_account.try(:provider) == 'developer'
      current_user_account.uid == 'mxit' ? 'mxit' : 'mobile'
    else
      mxit_request? ? 'mxit' : 'mobile'
    end
  end

  def check_mxit_input_for_redirect
    case request.env["HTTP_X_MXIT_USER_INPUT"]
      when "profile"
        redirect_to(user_accounts_path) unless params[:controller] == 'user_accounts'
      when 'airtime vouchers'
        redirect_to(winners_path) unless params[:controller] == 'airtime_vouchers'
    end
    status != 302
  end

  private

  def load_mxit_user
    @current_user_account = UserAccount.find_or_create_from_auth_hash(provider: 'mxit',
                                                       uid: request.env['HTTP_X_MXIT_USERID_R'],
                                                       info: { name: request.env['HTTP_X_MXIT_NICK'],
                                                               login: request.env['HTTP_X_MXIT_LOGIN'],
                                                               email: request.env['HTTP_X_MXIT_LOGIN'] && "#{request.env['HTTP_X_MXIT_LOGIN']}@mxit.im"})
    if request.env["HTTP_X_MXIT_PROFILE"]
      @mxit_profile = MxitProfile.new(request.env["HTTP_X_MXIT_PROFILE"])
      current_user_request_info.mxit_profile = @mxit_profile
    end
    if request.env['HTTP_X_DEVICE_USER_AGENT']
      current_user_request_info.user_agent = "Mxit #{request.env['HTTP_X_DEVICE_USER_AGENT']}"
    end
    if request.env["HTTP_X_MXIT_LOCATION"]
      @mxit_location = MxitLocation.new(request.env["HTTP_X_MXIT_LOCATION"])
      current_user_request_info.mxit_location = @mxit_location
    end
  end

  def load_facebook_user
    encoded_sig, payload = params[:signed_request].split('.')
    encoded_str = payload.gsub('-','+').gsub('_','/')
    encoded_str += '=' while !(encoded_str.size % 4).zero?
    @data = ActiveSupport::JSON.decode(Base64.decode64(encoded_str))
    Rails.logger.info "signed_request: #{@data.inspect}"
    if @data.kind_of?(Hash) && @data['user_id']
      self.current_user_account = UserAccount.find_facebook_user_by_uid(@data['user_id'])
    end
    if current_user_account
      true
    else
      redirect_to '/auth/facebook'
      false
    end
  end

  def current_user_account=(user)
    @current_user_account = user
    session[:current_uid] = user.try(:uid)
    session[:current_provider] = user.try(:provider)
  end

  def tracking_enabled?
    tracking_code.present? &&
    (Settings.ga_tracking_disabled_until.blank? || Time.current > Settings.ga_tracking_disabled_until)
  end

  def tracking_code
    ENV['GA_TRACKING_CODE']
  end

end
