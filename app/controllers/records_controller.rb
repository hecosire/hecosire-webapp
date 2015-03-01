class RecordsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_record, only: [:show, :edit, :update, :destroy]

  before_action :set_health_state, only: [:new, :edit]

  respond_to :html

  def index
    @records = records.paginate(:page => params[:page], :per_page => 10).all
    if @records.size > 0
      @has_stats = @records.last.created_at < 1.days.ago
    end
    respond_with(@records)
  end

  def stats
    @records = records.paginate(:page => params[:page], :per_page => 200).all

    @records_stats = RecordsStats.new(@records)

    respond_with(@records)
  end

  def aggregates
    @aggregates_stats = Record.health_state_by_hour(current_user)
  end

  def log
    @records = records.where("comment is NOT NULL and comment != ''").paginate(:page => params[:page], :per_page => 10).all
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

  def export
    respond_to do |format|
      format.csv {
        set_csv_headers "records.csv"

        self.response_body = RecordsExport.new(current_user).generate
      }
    end
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

  def records
    Record.where(user_id: current_user).order('created_at DESC')
  end

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

  def set_csv_headers(filename)
    self.response.headers["Content-Type"] ||= "text/csv"
    self.response.headers["Content-Disposition"] = "attachment; filename=#{filename}"
    self.response.headers["Content-Transfer-Encoding"] = "binary"
    self.response.headers["X-Accel-Buffering"] = "no"
    self.response.headers["Cache-Control"] = "no-cache"
  end

end
