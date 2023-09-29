class Task < ApplicationRecord

  broadcasts_to ->(_task) { :tasks }, inserts_by: :prepend

  belongs_to :user

  validates :body, presence: true
  validates :due_date, comparison: { greater_than_or_equal_to: -> { Time.zone.today }, allow_nil: true }

  enum status: { open: "open", closed: "closed", archived: "archived" }

  def self.search(params)
    params["q"].nil? ? all : where("body LIKE ?", "%#{sanitize_sql_like(params[:q])}%")
  end
end
