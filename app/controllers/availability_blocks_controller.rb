class AvailabilityBlocksController < ApplicationController
  def toggle
    date = Date.parse(params[:date])
    block = Current.user.availability_blocks.find_by(date: date)

    if block.nil?
      Current.user.availability_blocks.create!(date: date, status: :open)
    elsif block.open?
      block.update!(status: :booked)
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
end
