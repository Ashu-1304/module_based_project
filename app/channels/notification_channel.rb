class NotificationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "notification_channel_#{params[:account_id]}"
  end

  def unsubscribed
  end
end
