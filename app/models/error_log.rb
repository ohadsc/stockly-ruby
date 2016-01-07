class ErrorLog < ActiveRecord::Base

  devise :database_authenticatable, :trackable, :timeoutable, :lockable
  belongs_to :user_log
  has_one :user, through: :user_log

  def self.handle_error(user, e)

    user_log = if user.nil?
                 UserLog.last
               else
                 user.user_logs.empty? ?
                     UserLog.last :
                     user.user_logs.order('updated_at DESC').limit(1).first
               end

    create!(
        {
            user_log_id: user_log.try(:id),
            name: (e.name rescue ''),
            message: e.cause,
            exception: e.exception,
            backtrace: e.backtrace
        }
    )

  end

  def self.fetch_data(user)
    user.error_logs.order('id DESC').includes(:user_log)
  end

end