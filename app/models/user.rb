# frozen_string_literal: true

# This is the model for User, which inherits from the ApplicationRecord class.
# The User model has many associations: it has many microposts, which will be
# destroyed if the user is deleted, and it has many active and passive relationships,
# which allow it to follow and be followed by other users.
# It also has many followers and following users.
# The model defines several validations for the user's name and email,
# ensuring that they are present, of valid format, and unique.
# It uses the `has_secure_password` method to encrypt the user's password
# and validate the presence of the password and its confirmation.
# The model includes methods for creating and authenticating tokens and
# digests, and for remembering and forgetting a user.
# It also has methods for activation and resetting the user's password,
# as well as determining if a password reset has expired.
# Finally, the model defines several private methods to create activation and
# reset digests, and to downcase the user's email before saving.
class User < ApplicationRecord
  has_many :microposts, dependent: :destroy # If an user is deleted, all
  # microposts attached to his ID will do.

  has_many :active_relationships, class_name: 'Relationship', foreign_key:
    'follower_id', dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed

  has_many :passive_relationships, class_name: 'Relationship', foreign_key:
    'followed_id', dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  attr_accessor :remember_token, :activation_token, :reset_token

  before_save { self.email = email.downcase }
  before_create :create_activation_digest

  validates :name, presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\-.]+\.[a-z]+\z/i

  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true

  has_secure_password # :password, :password_confirmation

  validates :password, presence: true, length: { minimum: 6, maximum: 50 },
                       allow_nil: true

  # Create user digest
  def self.digest(string)
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost:)
  end

  # Return a random token
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions
  def remember
    self.remember_token = User.new_token
    update(remember_digest: User.digest(remember_token))
    # update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Forgets a user.
  def forget
    update(remember_digest: nil)
    # update_attribute(:remember_digest, nil)
  end

  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # Send activation email
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def send_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def feed
    following_ids_subselect = "SELECT followed_id FROM relationships WHERE
follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids_subselect}) OR user_id =
:user_id", user_id: id)
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # Returns true if the given token matches the digest
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")

    return false if digest.nil?

    BCrypt::Password.new(digest).is_password?(token)
  end

  def follow(other_user)
    following << other_user unless self == other_user
  end

  def unfollow(other_user)
    following.delete(other_user)
  end

  def following?(other_user)
    following.include?(other_user)
  end

  private

  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
