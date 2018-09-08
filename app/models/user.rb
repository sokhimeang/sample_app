class User < ApplicationRecord
  attr_accessor :remember_token
  before_save :email_downcase

  validates :name,  presence: true,
    length: {maximum: Settings.user.name.length}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
    length: {maximum: Settings.user.email.length},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: Settings.user.sensitive}
  has_secure_password
  validates :password,
    presence: true,
    length: {minimum: Settings.user.password.length}

  def self.digest string
    cost = if ActiveModel::SecurePassword.min_cost.present?
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create string, cost: cost
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update remember_digest: User.digest(remember_token)
  end

  def authenticated? remember_token
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update remember_digest: nil
  end

  private
  def email_downcase
    email.downcase!
  end
end
