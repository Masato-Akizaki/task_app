class Task < ApplicationRecord
  validates :name,   presence: true, length: { maximum: 100 }
  validates :detail, length: { maximum: 1000 }
  enum status:{ waiting: 0, working: 1, completed: 2 }
  enum priority:{ low: 0, medium: 1, high: 2 }

  def self.search(name, status_ja)
    status_en = Task.statuses_i18n.key("#{status_ja}")
    if name.blank? && status_ja.blank?
      all
    elsif name && status_ja.blank?
      where(['name LIKE (?)', "%#{name}%"])
    elsif status_ja && name.blank?
      where(status: Task.statuses[:"#{status_en}"])
    else
      where(['name LIKE (?) AND status = ?', "%#{name}%", Task.statuses[:"#{status_en}"]])
    end
  end
end

#enum
#日本語 => 英語
#Task.statuses_i18n.key("#{status_ja}")

#英語 => 数字　
#Task.statuses[:"#{status_en}"]