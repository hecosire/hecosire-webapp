module Api
  module V1
    class RecordsController < BaseApiController

      acts_as_token_authentication_handler_for User, fallback_to_devise: false

      before_action :make_sure_valid_user

      def index
        respond_with({ test: "works" })
      end

      private

      def make_sure_valid_user
        head(401) unless current_api_v1_user
      end

    end
  end
end