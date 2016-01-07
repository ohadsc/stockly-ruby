class User < ActiveRecord::Base

  TEMP_EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  devise :timeoutable, :timeout_in => 15.minutes

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :omniauthable, :lastseenable,
         omniauth_providers: [
             # :digitalocean,
             # :twitter,
             :facebook,
             # :google,
             # :amazon,
             # :github,
             # :linkedin,
             # :aliexpress
         ]

  # has_secure_password
  has_many :stocks, class_name: 'Stock', :dependent => :destroy
  has_many :appearances, class_name: 'Appearance', :dependent => :destroy
  has_many :groups, class_name: 'Group', :through => :appearances

  has_many :user_logs,
           class_name: 'UserLog',
           dependent: :destroy

  has_many :error_logs,
           class_name: 'ErrorLog',
           dependent: :destroy,
           through: :user_logs

  validates_presence_of :name

  def self.find_by_emails(mails=[])
    mails.map { |mail| find_by_email(mails) }
  end

  validates_format_of :email, with: TEMP_EMAIL_REGEX, on: :update

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      create_from(auth, user)
    end
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end

  def online
    where('last_seen > ?', 5.minutes.ago)
  end

  def valid_password?(password)
    logger.info ">>>>>>>>>>>>>>>>>#{password}, #{self.password_legacy}, #{self.password_legacy.present?}"
    if self.password_legacy.present?
      logger.info "inside present?"
      if validate_password_legacy(password)
        logger.info "validate"
        migrate_legacy_user(password)
        true
      end
    else
      logger.info "super"
      super
    end
  end

  def reset_password!(*args)
    self.password_legacy = nil
    super
  end

  private

  def migrate_legacy_user(password)
    logger.info "migrate"
    user = User.new(email: self.email, password: password)
    self.update_attributes(
          {
              password: password,
              encrypted_password: user.encrypted_password,
              password_legacy: nil
          }
      )
  end

  def validate_password_legacy(password)
    require 'bcrypt'

    cost = ActiveModel::SecurePassword.min_cost ?
        BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost

    BCrypt::Password.new(BCrypt::Password.create(password, cost: cost)) == password
  end

  def self.create_from(auth, user)

    url = 'https://graph.facebook.com/'+ auth.uid+'/?fields=first_name,last_name&access_token=' + auth.credentials.token
    url = URI.encode(url)
    URI.parse(url)
    resp = RestClient.get url, content_type: :json, accept: :json

    user.provider = auth.provider
    user.uid = auth.uid
    user.oauth_token = auth.credentials.token
    user.oauth_expires_at = Time.at(auth.credentials.expires_at) unless auth.credentials.expires_at.nil?

    #name = auth.info.resource_owner if auth.provider == 'aliexpress'

    user.email = auth.info.email || "#{name.parameterize.gsub(/-/, '.')}@#{auth.provider}.com"
    user.password = Devise.friendly_token[0, 20]

    # assuming the user model has a name
    user.name = JSON.parse(resp)['first_name']
    # assuming the user model has an image
    user.image = auth.info.image
    user.save!

  end


end
