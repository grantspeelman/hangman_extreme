class RedeemWinning < ActiveRecord::Base
  PRIZE_TYPES = ['clue_points','moola','vodago_airtime','cell_c_airtime','mtn_airtime']
  attr_accessible :prize_amount, :prize_type, :state, :user_id

  validates :user_id, presence: true
  validates :prize_type, inclusion: PRIZE_TYPES
  validates :state, inclusion: ['pending','paid']
  validates_numericality_of :prize_amount, greater_than: 0

  validate :check_user_prize_points
  after_create :update_user_prize_points

  belongs_to :user

  scope :pending, where('state = ?','pending')

  def self.pending_winnings_text
    pending.joins(:user).includes(:user).order('prize_type,uid').collect{|rw| [rw.prize_type,rw.id,rw.user.uid,rw.user.login,rw.user.mobile_number,rw.prize_amount].join(" : ")}.join("\n")
  end

  def self.paid!(id)
    find(id).update_column(:state, 'paid')
  end

  def self.cohort_array
    cohort = []
    day = maximum(:created_at).end_of_day
    first_day = 21.days.ago
    while(day >= first_day) do
      scope = where('created_at >= ? AND created_at <= ?',day.beginning_of_day,day)
      values = [day.strftime("%d-%m")]
      PRIZE_TYPES.each do |prize_type|
        values << scope.where(prize_type: prize_type).sum(:prize_amount)
      end
      cohort << values
      day -= 1.day
    end
    cohort.reverse
  end


  protected

  def check_user_prize_points
    if user && prize_amount && user.prize_points < prize_amount
      errors.add(:user_id,"does not have enough prize points")
    end
  end

  def update_user_prize_points
    user.decrement!(:prize_points,prize_amount)
    if prize_type == 'clue_points'
      update_column(:state, 'paid')
      user.increment!(:clue_points,prize_amount)
    end
  end

end
