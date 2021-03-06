class Project < ApplicationRecord
  validates :title, presence: true,length: { maximum: 40 }
  has_and_belongs_to_many :users
  has_many :bugs
end
