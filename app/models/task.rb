class Task < ApplicationRecord

  broadcasts_to ->(task) { :tasks }, inserts_by: :prepend

  validates :body, presence: true
end
