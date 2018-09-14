class Task < ApplicationRecord
  validates :name,   presence: true, length: {maximum: 100}
  validates :detail, length: {maximum: 1000}

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
