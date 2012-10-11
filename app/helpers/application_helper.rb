module ApplicationHelper

  def shinka_ad
    result = ""
    return result unless shinka_ads_enabled?
    begin
      Timeout::timeout(15) do
        headers = {"User-Agent" => "Mozilla Compatible/5.0 #{env['HTTP_USER_AGENT']}",
                   "X-FORWARDED_FOR" => request_ip_address}
        ads = ActiveSupport::JSON.decode(open("http://ox-d.shinka.sh/ma/1.0/arj?auid=#{shinka_auid}&c.age=#{current_user_request_info.age}&c.gender=#{current_user_request_info.gender}",headers).read)
        return "" if ads['ads']['count'].to_i == 0
        ad = ads['ads']["ad"].sample
        result = ad["html"].gsub("href=","onclick='window.open(this.href); return false;' href=").html_safe
        creative = ad["creative"].first
        tracking = creative["tracking"]
        alt = creative["alt"]
        beacon = "<div style='position: absolute; left: 0px; top: 0px; visibility: hidden;'>"
        beacon << "<img src='#{tracking['impression']}' alt=\"\" height=\"1\" width=\"1\"/>"
        beacon << "</div>"
        if alt.blank? || alt.include?("http")
          link = creative["media"]
          return result if link.blank? || !link.include?("href=")
          link.gsub!("href=","onclick='window.open(this.href); return false;' href=")
          "#{beacon}#{link}".html_safe
        else
          "#{beacon}<a href=#{tracking['click']} onclick='window.open(this.href); return false;' >#{alt}</a>".html_safe
        end
      end
    rescue Exception => e
      ENV['AIRBRAKE_API_KEY'].present? ? notify_airbrake(e) : Rails.logger.error(e.message)
      Settings.shinka_disabled_until = 10.minutes.from_now # disable for a hour
      raise unless Rails.env.production?
      return result
    end
  end

  def shinka_ads_enabled?
    (Settings.shinka_disabled_until.blank? || Time.current > Settings.shinka_disabled_until) &&
      shinka_auid.present?
  end

  def shinka_auid
    ENV['SHINKA_AUID']
  end

  def env
    request.env
  end

  def request_ip_address
    Rails.env.test? ? (env["HTTP_X_FORWARDED_FOR"] || request.env['REMOTE_ADDR']) : env["HTTP_X_FORWARDED_FOR"]
  end

end
