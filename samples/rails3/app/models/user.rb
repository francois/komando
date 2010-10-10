class User < ActiveRecord::Base

  scope :invited, where(:state => "invited")
  scope :active,  where(:state => "active")
  scope :deleted, where(:state => "deleted")

  validates :username, :password, :email, :presence => true
  validates :username, :uniqueness => true

  attr_accessible :username, :password, :email

  def self.invite!(params)
    User.invited.create!(params)
  end

end
