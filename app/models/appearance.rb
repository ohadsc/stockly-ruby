class Appearance < ActiveRecord::Base
  devise :database_authenticatable, :trackable, :timeoutable, :lockable
  belongs_to :group
  belongs_to :user
end
