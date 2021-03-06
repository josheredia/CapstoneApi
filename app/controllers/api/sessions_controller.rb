module Api
  class SessionsController < ApplicationController
    skip_before_action :authorize_token, only: :create

    # POST /api/login
    def create
      user = User.find_by(email: params[:email])

      if user&.valid_password?(params[:password])
        user.regenerate_token
        render json: response_format(user)
      else
        unauthorized_request 'Invalid user credentials'
      end
    end

    # DELETE /api/logout
    def destroy
      current_user.invalidate_token
      render json: { message: 'Logged out successfully' }
    end

    private

    def response_format(user)
      { token: user.token,
        user_info: { email: user.email, name: user.name, phone: user.phone,
                     role: user.role, id: user.id },
        properties_info: { favorites: user.favorites, contacts: user.contacts,
                           properties: user.properties } }
    end
  end
end
