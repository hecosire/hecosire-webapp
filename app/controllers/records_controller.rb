class RecordsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_record, only: [:show, :edit, :update, :destroy]

  before_action :set_health_state, only: [:new, :edit]

  respond_to :html

  def index
    @records = Record.where(user: current_user).order('created_at DESC').paginate(:page => params[:page], :per_page => 10).all
    respond_with(@records)
  end

  def show
    respond_with(@record)
  end

  def new
    @record = Record.new
    respond_with(@record)
  end

  def edit
  end

  def create
    @record = Record.new(record_params)
    if @record.save
      redirect_to action: "index"
    else
      respond_with(@record)
    end
  end

  def update
    @record.update(record_params)
    respond_with(@record)
  end

  def destroy
    @record.destroy
    respond_with(@record)
  end

  private

    def set_health_state
      @health_state_select = HealthState.all
    end

    def set_record
      @record = Record.where(user: current_user).find(params[:id])
    end

    def record_params
      p = params.require(:record).permit(:health_state_id, :comment)
      p.merge(:user => current_user)
    end
end
