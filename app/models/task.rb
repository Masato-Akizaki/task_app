class Task < ApplicationRecord
  belongs_to :user
  has_many :task_labels, dependent: :destroy
  has_many :labels, through: :task_labels
  accepts_nested_attributes_for :task_labels, allow_destroy: true
  validates :name,    presence: true, length: { maximum: 100 }
  validates :detail,  length: { maximum: 1000 }
  validates :user_id, presence: true
  enum status:{ waiting: 0, working: 1, completed: 2 }
  enum priority:{ low: 0, medium: 1, high: 2 }

  def self.search(name, status_ja, label)
    status_en = Task.statuses_i18n.key("#{status_ja}")    # n s l
    if name.blank? && status_ja.blank? && label.blank?    # x x x
      all

    elsif name && status_ja.blank? && label.blank?        # o x x
      where(['name LIKE (?)', "%#{name}%"])

    elsif name.blank? && status_ja && label.blank?        # x o x
      where(status: Task.statuses[:"#{status_en}"])

    elsif name.blank? && status_ja.blank? && label        # x x o
      joins(:labels).where({labels: {name: label}})

    elsif name && status_ja && label.blank?               # o o x
      where(['name LIKE (?)', "%#{name}%"]).where(status: Task.statuses[:"#{status_en}"])

    elsif name && status_ja.blank? && label               # o x o
      where(['tasks.name LIKE (?)', "%#{name}%"]).joins(:labels).where({labels: {name: label}})

    elsif name.blank? && status_ja && label               # x o o
      where(status: Task.statuses[:"#{status_en}"]).joins(:labels).where({labels: {name: label}})

    else 
      where(['tasks.name LIKE (?)', "%#{name}%"]).where(status: Task.statuses[:"#{status_en}"]).joins(:labels).where({labels: {name: label}})
    end
  end
end
#enum
#日本語 => 英語
#Task.statuses_i18n.key("#{status_ja}")

#英語 => 数字　
#Task.statuses[:"#{status_en}"]