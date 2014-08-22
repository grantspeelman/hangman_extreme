
def mxit_user_account(params_or_uid = 'm2604100')
  generate_user_account('mxit',params_or_uid)
end

def generate_user_account(provider,params_or_uid)
  if params_or_uid.kind_of?(String)
    UserAccount.find_by_provider_and_uid(provider,params_or_uid) || create(:user_account, uid: params_or_uid, provider: provider)
  else
    params = HashWithIndifferentAccess.new(params_or_uid).reverse_merge(uid: '1234567').merge(provider: provider)
    user_account = UserAccount.find_by_provider_and_uid(provider,params[:uid])
    if user_account
      user_account.update_attributes(params)
      user_account
    else
      create(:user_account, params)
    end
  end
end
