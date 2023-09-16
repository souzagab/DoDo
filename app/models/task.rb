class Task < ApplicationRecord

  broadcasts_to ->(_task) { :tasks }, inserts_by: :prepend

  validates :body, presence: true

  def self.search(params)
    params["q"].nil? ? all : where("body LIKE ?", "%#{sanitize_sql_like(params[:q])}%")
  end
end
