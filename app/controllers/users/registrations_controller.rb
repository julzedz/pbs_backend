# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json
  before_action :authenticate_user!, only: [:update]

  def create
    build_resource(sign_up_params)

    resource.save
    respond_with(resource)
  end

  def update
    user = current_user

    if needs_password_change?(account_update_params)
      updated = user.update_with_password(account_update_params)
    else
      # Remove password params if blank so Devise doesn't try to validate them
      params_to_update = account_update_params.except(:password, :password_confirmation, :current_password)
      updated = user.update(params_to_update)
    end

    if updated
      render json: {
        status: { code: 200, message: 'Account updated successfully.' },
        data: ::UserSerializer.new(user).serializable_hash[:data][:attributes]
      }, status: :ok
    else
      render json: {
        status: { message: "Account couldn't be updated. #{user.errors.full_messages.to_sentence}" }
      }, status: :unprocessable_entity
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :telephone)
  end

  def account_update_params
    params.require(:user).permit(
      :email,
      :first_name,
      :last_name,
      :telephone,
      :password,
      :password_confirmation,
      :current_password
    )
  end

  def needs_password_change?(permitted_params)
    permitted_params[:password].present? || permitted_params[:password_confirmation].present?
  end

  def respond_with(resource, _opts = {})
    if resource.persisted?
      render json: {
        status: { code: 200, message: 'Signed up successfully.' },
        data: ::UserSerializer.new(resource).serializable_hash[:data][:attributes]
      }
    else
      render json: {
        status: { message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}" }
      }, status: :unprocessable_entity
    end
  end
end 