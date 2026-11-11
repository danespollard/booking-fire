class OpeningsRangesController < ApplicationController
  def update
    @month = params[:month].present? ? Month.find(params[:month]) : Month.current
    @user = Current.user
    @error = @user.errors.full_messages.to_sentence unless @user.update(range_params)
    @user.restore_attributes if @error

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to month_path(@month), alert: @error }
    end
  end

  private

  def range_params
    params.require(:user).permit(:openings_range, :openings_from, :openings_to)
  end
end
