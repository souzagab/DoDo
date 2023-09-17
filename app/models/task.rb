class Task < ApplicationRecord

  broadcasts_to ->(_task) { :tasks }, inserts_by: :prepend

  enum status: { open: "open", closed: "closed", archived: "archived" }

  validates :body, presence: true
  validates :due_date, comparison: { greater_than_or_equal_to: -> { Time.zone.today }, allow_nil: true }

  def self.search(params)
    params["q"].nil? ? all : where("body LIKE ?", "%#{sanitize_sql_like(params[:q])}%")
  end
end
