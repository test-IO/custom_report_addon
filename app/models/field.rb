class Field < ApplicationRecord
  belongs_to :addon

  validates :name, :key, :data_type, presence: true
  validates :key, uniqueness: { scope: :addon_id }

  enum data_type: { text: 'text', string: 'string', file: 'file' }
end
