require 'ohm/contrib'
class GoogleTracking < Ohm::Model
  include Ohm::Timestamps
  include Ohm::DataTypes
  include ActiveModel::Validations
  include ActiveModel::Dirty
  define_attribute_methods [:user_account_id, :initial_visit, :previous_session, :current_session, :last_visit]

  attribute :user_account_id
  index :user_account_id
  unique :user_account_id
  attribute :initial_visit, Type::Time
  attribute :previous_session, Type::Time
  attribute :current_session, Type::Time
  attribute :last_visit, Type::Time

  validates_presence_of :user_account_id

  def save
    (new? || changed?) && super
  end

  def self.time_now
    Time.at((Time.current.to_i / 60) * 60)
  end

  def update_tracking
    now = GoogleTracking.time_now
    if last_visit.nil? || (now > last_visit + 1.hour)
      self.previous_session = self.current_session
      self.current_session = now
    end
    self.last_visit = now
    save
  end

  def utma(update_tracking = false)
    self.update_tracking if update_tracking
    utma = "1.#{user_account_id}00145214523.#{initial_visit.to_i}.#{previous_session.to_i}.#{current_session.to_i}.15"
    "__utma=#{utma};+__utmz=1.#{current_session.to_i}.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none);"
  end

  def self.find_or_create_by_user_id(user_account_id)
    now = GoogleTracking.time_now
    find(user_account_id: user_account_id.to_s).first ||
    create(user_account_id: user_account_id.to_s,
           current_session: now,
           previous_session: now,
           initial_visit: now,
           last_visit: now)
  end

end
