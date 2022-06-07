class Addon < ApplicationRecord
  has_many :fields, dependent: :destroy

  validates :title, :key, presence: true

  state_machine :status, initial: :pending do
    around_transition installed: :uninstalled do |addon, _transition, block|
      addon.client_key = nil
      addon.shared_secret_key = nil
      block.call
    end

    event :install do
      transition [:pending, :uninstalled] => :installed
    end
    event :uninstall do
      transition installed: :uninstalled
    end
  end
end
