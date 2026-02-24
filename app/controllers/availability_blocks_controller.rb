class AvailabilityBlocksController < ApplicationController
  def toggle
    date = Date.parse(params[:date])
    block = Current.user.availability_blocks.find_by(date: date)

    if block.nil?
      Current.user.availability_blocks.create!(date: date, status: params[:status] || :open)
    else
      block.destroy!
    end

    respond_to do |format|
      format.turbo_stream do
        @block = Current.user.availability_blocks.find_by(date: date)
        month_start = date.beginning_of_month
        month_end = date.end_of_month
        render turbo_stream: [
          turbo_stream.replace(
            "day-#{date}",
            partial: "calendars/day",
            locals: { day: date, block: @block }
          ),
          turbo_stream.replace(
            "openings",
            partial: "calendars/openings",
            locals: { month_start: month_start, month_end: month_end }
          )
        ]
      end
      format.html { redirect_to calendar_path(date: date.beginning_of_month) }
    end
  end

  def destroy
    block = Current.user.availability_blocks.find(params[:id])
    date = block.date
    block.destroy!

    respond_to do |format|
      format.turbo_stream do
        month_start = date.beginning_of_month
        month_end = date.end_of_month
        render turbo_stream: [
          turbo_stream.replace(
            "day-#{date}",
            partial: "calendars/day",
            locals: { day: date, block: nil }
          ),
          turbo_stream.replace(
            "openings",
            partial: "calendars/openings",
            locals: { month_start: month_start, month_end: month_end }
          )
        ]
      end
      format.html { redirect_to calendar_path(date: date.beginning_of_month) }
    end
  end

  def update
    block = Current.user.availability_blocks.find(params[:id])

    block.update!(block_params)

    date = block.date
    respond_to do |format|
      format.turbo_stream do
        month_start = date.beginning_of_month
        month_end = date.end_of_month
        render turbo_stream: [
          turbo_stream.replace(
            "day-#{date}",
            partial: "calendars/day",
            locals: { day: date, block: block }
          ),
          turbo_stream.replace(
            "openings",
            partial: "calendars/openings",
            locals: { month_start: month_start, month_end: month_end }
          )
        ]
      end
      format.html { redirect_to calendar_path(date: date.beginning_of_month) }
    end
  end

  private

  def block_params
    params.require(:availability_block).permit(:status, :time_label)
  end
end
