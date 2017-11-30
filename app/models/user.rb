class User < ApplicationRecord

  has_many :campaigns, dependent: :destroy

  has_many :campaigns_users
  has_many :campaigns_played, through: :campaigns_users, source: :campaign, dependent: :destroy

  has_many :hierarchy_elements_users
  has_many :visible_hierarchy_elements, through: :hierarchy_elements_users, source: :hierarchy_element,
                                        dependent: :destroy

  has_many :content_texts_users
  has_many :visible_content_texts, through: :content_texts_users, source: :content_text, dependent: :destroy

  has_secure_password

  validates :name, presence: true, length: { maximum: 30 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 8 }, if: :password_length_is_needed?

  after_validation  { self.errors.messages.delete(:password_digest) }
  before_save { email.downcase! }
  before_save :create_remember_token

  def players
    campaigns.includes(:players).map(&:players).flatten.uniq(&:email).sort!{ |x,y| x.email <=> y.email }
  end

  private

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end

  def password_length_is_needed?
    !(self.persisted? && password.blank?)
  end

end
