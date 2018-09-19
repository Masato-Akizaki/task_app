class User < ApplicationRecord
  has_many :tasks, dependent: :destroy
  before_save { email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
  before_destroy :least_one_admin_user, prepend: true

  private

  def least_one_admin_user
    if User.find(self.id).admin? && User.where(admin: 1).count == 1
      errors.add :base, "少なくとも1つ、管理ユーザーが必要です" 
      throw :abort
    end
  end

end
