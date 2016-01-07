class Group < ActiveRecord::Base

  #devise :database_authenticatable, :trackable, :timeoutable, :lockable
  has_many :appearances, class_name: 'Appearance', dependent: :destroy
  has_many :users, through: :appearances
  has_many :runs

  def user_emails
    mails = Array.new
    self.users.each do |user|
      mails << user.email
    end
    mails.join(',')
  end

  def is_current?(group_name)
    name == group_name
  end

  def is_changed?
    users_changed? && name_changed?
  end

  def should_update(emails, group_name)
    name = group_name unless is_current?(group_name)
    users_to_update = emails.map do |mail|
      user = User.find_by_email(mail)
      user unless users.include? user
    end
    users << users_to_update unless users_to_update.empty?
  end

end
