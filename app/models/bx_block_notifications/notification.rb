module BxBlockNotifications
  class Notification < ApplicationRecord
    self.table_name = :notifications
    belongs_to :account, class_name: "BxBlockAccountBlock::Account"
    # scope :unread, -> { where(read: false) }
  end
end
