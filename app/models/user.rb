class User < ActiveRecord::Base
  include BCrypt

  has_many :games

  validates :username, :name, presence: true

  validate :password_validation

  def password
    @password ||= Password.new(password_type_thing)
  end

  def password=(new_password)
    @plain_text_password = new_password
    @password = Password.create(new_password)
    self.password_type_thing = @password
  end

  def password_validation
    if @plain_text_password.nil?
      errors.add(:password, "Password is required")
    elsif @plain_text_password.length < 6
      errors.add(:password, "Password must be 6 characters or greater")
    end
  end

  def self.authenticate(username, password)
    user = User.find_by(username: username)
    user && user.password == password ? user : nil
  end
end
