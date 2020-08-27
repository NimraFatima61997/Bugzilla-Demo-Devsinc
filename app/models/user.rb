class User < ApplicationRecord
  has_and_belongs_to_many :projects
  has_and_belongs_to_many :bugs
  has_many :bug_reports, class_name: "Bug"
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
end
