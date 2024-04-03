class Event < ApplicationRecord
  belongs_to :user
  has_many :tickets, dependent: :destroy

  validates :name, :description, :location, :date, :time, :total_tickets, presence: true
end
