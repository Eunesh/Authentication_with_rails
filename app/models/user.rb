class User < ApplicationRecord

  CONFIRMATION_TOKEN_EXPIRATION = 10.minutes

  has_secure_password # For hashing password with bcrypt on password_digest column

  before_save :downcase_email # before saving to database changing case of emails to downcase

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, presence: true, uniqueness: true

  def confirm!
    update_columns(confirmed_at: Time.current)  # update_column is used to update certail columns in table
  end

  # signed in method is used to generate a cryptographically signed identifier
  def generate_confirmation_token
    signed_id expires_in: CONFIRMATION_TOKEN_EXPIRATION, purpose: :confirm_email
  end

  private

  def downcase_email
    self.email = email.downcase
  end
end
