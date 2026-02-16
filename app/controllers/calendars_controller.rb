class CalendarsController < ApplicationController
  def show
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @month_start = @date.beginning_of_month
    @month_end = @date.end_of_month

    @blocks = Current.user.availability_blocks
      .where(date: @month_start..@month_end)
      .index_by(&:date)
  end
end
