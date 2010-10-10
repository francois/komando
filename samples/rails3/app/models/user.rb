require "digest/sha1"

class User < ActiveRecord::Base

  scope :invited, where(:state => "invited")
  scope :active,  where(:state => "active")
  scope :deleted, where(:state => "deleted")

  scope :with_token, lambda {|token| where(:token => token)}

  validates :email, :presence => true, :uniqueness => true
  validates :username, :password, :presence => true, :if => :active?
  validates :username, :uniqueness => true, :if => :active?

  before_save :assign_invitation_token, :if => :invited?

  attr_accessible :username, :password, :email

  def self.invite!(params)
    User.invited.create!(params)
  end

  def self.find_invited_by_token!(token)
    User.invited.with_token(@token).first.tap do |user|
      raise ActiveRecord::RecordNotFound if user.nil?
    end
  end

  def activate!(params)
    self.attributes = params
    self.state = "active"
    save!
  end

  def invited?
    state == "invited"
  end

  def active?
    state == "active"
  end

  def deleted?
    state == "deleted"
  end

  def self.generate_token
    plaintext = [object_id, Time.now.to_s(:db), rand].map(&:to_s).join("--")
    Digest::SHA1.hexdigest("--#{plaintext}--")
  end

  private

  def assign_invitation_token
    self.token = self.class.generate_token
  end

end
