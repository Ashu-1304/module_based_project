module BxBlockProfile
    class ProfilesController < ApplicationController
      # before_action :authenticate_request
      before_action :set_profile, only: [:show,  :update]
      
      def create
        @profile = Profile.create(profile_params)
        render json: ProfileSerializer.new(@profile).serializable_hash,state: :created
      end

      def show
        render json: ProfileSerializer.new(@profile).serializable_hash,status: :ok if @profile
      end
  
      def update
        if @profile.update(profile_params)
          render json: @profile, status: :ok
        else
          render json: { errors: @profile.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        profile = BxBlockProfile::Profile.find(params[:id])
        if profile.present?
          profile.destroy
          render json:{ meta: { message: "Profile Removed"}}
        else
          render json:{meta: {message: "Record not found."}}
        end
      end

      # def user_profiles
      #   profiles = current_user.profiles
      #   render json: ProfileSerializer.new(profiles, meta: {
      #     message: "Successfully Loaded"
      #   }).serializable_hash, status: :ok
      # end
  
      private
  
      def set_profile
        @profile = Profile.find_by(id: params[:id])
        unless @profile
          render json: { error: 'Profile not found' }, status: :not_found
        end
      end

  
      def profile_params
        params.require(:profile).permit(:address, :city,  :postal_code, :account_id, :profile_role,:country)
      end

      # def current_user
      #   @account = AccountBlock::Account.find_by(id: @token.id)
      # end
  
  
      # def update_params
      #   params.require(:data).permit \
      #     :first_name,
      #     :last_name,
      #     :current_password,
      #     :new_password,
      #     :new_email,
      #     :new_phone_number
      # end
      
    end
  end
  
  