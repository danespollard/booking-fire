class AvailabilityBlocksController < ApplicationController
  def toggle
    date = Date.parse(params[:date])
    block = Current.user.availability_blocks.find_by(date: date)

    if block.nil?
      Current.user.availability_blocks.create!(date: date, **block_params.to_h.symbolize_keys)
    else
      block.destroy!
    end

    @block = Current.user.availability_blocks.find_by(date: date)
    respond_with_openings(date, block: @block)
  end

  def destroy
    block = Current.user.availability_blocks.find(params[:id])
    date = block.date
    block.destroy!

    respond_with_openings(date, block: nil)
  end

  def update
    block = Current.user.availability_blocks.find(params[:id])
    block.update!(block_params)

    respond_with_openings(block.date, block: block)
  end

  private

  def block_params
    params.require(:availability_block).permit(:status, :time_label, :client_name)
  end

  def openings_stream(date, block:)
    templates = Current.user.templates.ordered
    [
      turbo_stream.replace(
        "day-#{date}",
        partial: "calendars/day",
        locals: { day: date, block: block }
      ),
      turbo_stream.replace(
        "openings",
        partial: "calendars/openings",
        locals: { month: date, templates: templates }
      )
    ]
  end

  def respond_with_openings(date, block:)
    stream = openings_stream(date, block: block)
    respond_to do |format|
      format.turbo_stream { render turbo_stream: stream }
      format.html { redirect_to calendar_path(date: date.beginning_of_month) }
    end
  end
end
