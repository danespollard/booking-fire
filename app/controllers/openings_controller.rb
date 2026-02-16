class OpeningsController < ApplicationController
  def show
    from = params[:from] ? Date.parse(params[:from]) : Date.today.beginning_of_month
    to = params[:to] ? Date.parse(params[:to]) : Date.today.end_of_month

    respond_to do |format|
      format.text { render plain: helpers.openings_text(from, to) }
      format.html { redirect_to calendar_path }
    end
  end
end
