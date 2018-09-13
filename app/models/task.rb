class Task < ApplicationRecord
  belongs_to :user
  validates :name,    presence: true, length: {maximum: 100}
  validates :detail,  length: {maximum: 1000}
  validates :user_id, presence: true

  def self.search(name,status)
    if name.blank? && status.blank?
      all
    elsif name && status.blank?
      where(['name LIKE (?)', "%#{name}%"])
    elsif status && name.blank?
      where('status = ?', "#{status}")
    else
      where(['name LIKE (?) AND status = ?', "%#{name}%", "#{status}"])
    end
  end
end
