module BxBlockNotifications
  class Notification < ApplicationRecord
    self.table_name = :notifications
    belongs_to :account, class_name: "BxBlockAccountBlock::Account"
  end
end
