class Run < ActiveRecord::Base

  devise :database_authenticatable, :trackable, :timeoutable, :lockable
  belongs_to :group, class_name: 'Group', foreign_key: 'group_id'
  delegate :name, to: :group, prefix: true

  has_many :stocks
  enum status: [ :pending, :active, :done ]

  public
  def activate
    status = false
    if self.stocks.size == self.group.users.size * 5
      self.status = 'active'
      self.started_at = Time.now
      self.ended_at = 1.month.from_now
      self.stocks.each { |stock| stock.update_attribute(:start_price, stock.lastTradePriceOnly) }
      status = true
    end
    status
  end

  def finalize
    self.status = 'done'
    self.stocks.each { |stock| stock.update_attribute(:end_price, stock.lastTradePriceOnly) }
    self
  end


end
