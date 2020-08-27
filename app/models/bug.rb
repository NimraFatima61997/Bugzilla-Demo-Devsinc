class Bug < ApplicationRecord
  mount_uploader :screenshot, ScreenshotUploader
  belongs_to :user
  belongs_to :project
  has_and_belongs_to_many :users
end
