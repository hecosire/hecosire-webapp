module Api
  module V1
    class RecordsController < BaseApiController

      acts_as_token_authentication_handler_for User, fallback_to_devise: false

      before_action :make_sure_valid_user

      def index
        @records = Record.includes(:health_state).where(user: current_user).order('created_at DESC').paginate(:page => params[:page], :per_page => 10).all
        respond_to do |format|
          format.json do
            render :json => @records.to_json(:include => { :health_state => { :only => :name } }, :except => [:user_id, :health_state_id])
          end
        end
      end

      def create
        @record = Record.new(record_params)
        if @record.save

          respond_with(@record, status: 201)
        else
          respond_with(@record, status: 400)
        end
      end

      private

      def make_sure_valid_user
        head(401) unless current_user
      end

      def record_params
        p = params.require(:record).permit(:health_state_id, :comment)
        p.merge(:user => current_user)
      end

    end
  end
end