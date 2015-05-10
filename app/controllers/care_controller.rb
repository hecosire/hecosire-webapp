class CareController < ApplicationController

  before_action :authenticate_user!

  respond_to :html

  def receivers
    @receivers = current_user.care_receivers
  end

end
