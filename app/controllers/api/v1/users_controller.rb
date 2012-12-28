
module Api
  module V1
    class UsersController < ActionController::Base
      doorkeeper_for :all
      load_and_authorize_resource :user, :parent => false, :except => :ability
      respond_to :json

      def me
        respond_with current_user.to_json(:except => :password_digest)
      end

      def index
        user_ids = params[:user_ids]
        organization = Organization.find(params[:organization_id])
        @users = @users.where(:id => user_ids) if user_ids
        respond_with @users.to_json(:only => [:id, :name, :role])
      end

      def ability
        perform_action = params[:perform_action].to_sym
        klass = params[:resource].classify.constantize
        respond_with({ :result => can?(perform_action, klass) })
      end

      private

      def current_user
        @current_user ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
      end
    end
  end
end
