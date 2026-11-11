class MonthsController < ApplicationController
  def show
    @month = params[:id] ? Month.find(params[:id]) : Month.current
    @blocks = Current.user.availability_blocks.where(date: @month.days).index_by(&:date)
  end
end
