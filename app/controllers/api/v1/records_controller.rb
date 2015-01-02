module Api
  module V1
    class RecordsController < BaseApiController

      acts_as_token_authentication_handler_for User

      before_action :make_sure_valid_user

      def index
        respond_with({ test: "works" })
      end

      private

      def make_sure_valid_user
        respond_with({ test: "problems", email: request.headers['X-User-Email'], mytoken: request.headers['X-User-Token'],  token: User.find_by_email(request.headers['X-User-Email']) }) unless current_user
      end

    end
  end
end