class Bug < ApplicationRecord
  validates :title, presence: true,length: { maximum: 40 },uniqueness: true
  validates :screenshot, presence: true
  validates :deadline, presence: true
  validates :status, presence: true
  validates :bug_type, presence: true
  mount_uploader :screenshot, ScreenshotUploader
  belongs_to :user
  belongs_to :project
  has_and_belongs_to_many :users
end
