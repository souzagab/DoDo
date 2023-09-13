class Task < ApplicationRecord

  broadcasts_to ->(_task) { :tasks }, inserts_by: :prepend

  validates :body, presence: true
end
