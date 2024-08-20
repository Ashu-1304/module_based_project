module BxBlockNotifications
  class NotificationsController < ApplicationController
    before_action :authenticate_request
    before_action :fetch_notification, only: [:destroy, :read_notification]
    before_action :load_notifications, only: [:index]

    def index
      if @notifications
        render json: @notifications, status: :ok
      else
        render json: { message: "Notification not found" }, status: :not_found
      end
    end

    def destroy
      if @notification.present?
        @notification.destroy!
        render json: {
          success: true,
          message: "Notification has been deleted successfuly",
        }, status: :ok
      else
        render json: { message: "Notification not found" }, status: :unprocessable_entity
      end
    end

    def destroy_all
      if @current_user.notifications
        @current_user.notifications.destroy_all
        render json: { message: "All notifications are deleted" }, status: :ok
      else
        render json: { message: "Couldn't delete, something went wrong" }, status: :unprocessable_entity
      end
    end

    def read_notification
      if @notification.present?
        @notification.update(is_read: true)
        render json: { message: "Notification read successfully" }, status: :ok
      elsif params[:read_all]
        @current_user.notifications.update_all(is_read: true)
        render json: { message: "All notifications read successfully" }, status: :ok
      else
        render json: { message: "No notification found" }, status: :not_found
      end
    end

    private

    def fetch_notification
      @notification = @current_user.notifications.find_by(id: params[:id])
    end

    def load_notifications
      @notifications = @current_user.notifications.order(created_at: :desc)
    end
    
  end
end
