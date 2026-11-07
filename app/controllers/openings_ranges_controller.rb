class OpeningsRangesController < ApplicationController
  def update
    month = params[:month].present? ? Date.parse(params[:month]) : Date.current
    user = Current.user
    error = user.errors.full_messages.to_sentence unless user.update(range_params)
    user.restore_attributes if error

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "openings",
          partial: "calendars/openings",
          locals: { month: month, templates: user.templates.ordered, error: error }
        )
      end
      format.html { redirect_to calendar_path(date: month.beginning_of_month), alert: error }
    end
  end

  private

  def range_params
    params.require(:user).permit(:openings_range, :openings_from, :openings_to)
  end
end
