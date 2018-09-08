class User < ApplicationRecord
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
    BCrypt::Password.create(string, cost: cost)
  end

  private
  def email_downcase
    email.downcase!
  end
end
