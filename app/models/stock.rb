class Stock < ActiveRecord::Base

  devise :database_authenticatable, :trackable, :timeoutable, :lockable

  attr_accessor :averageDailyVolume,
                :change,
                :daysLow,
                :daysHigh,
                :yearLow,
                :yearHigh,
                :marketCapitalization,
                :lastTradePriceOnly,
                :daysRange,
                :name,
                :volume,
                :stockExchange,
                :run_name

  belongs_to :user, class_name: 'User', foreign_key: :user_id
  belongs_to :run, class_name: 'Run', foreign_key: :run_id

  def enrich_attrs(h)
    h.each do |k, v|
      instance_variable_set("@#{k}", v) unless self.methods.include? k.to_sym && self[k]
    end
  end

end
