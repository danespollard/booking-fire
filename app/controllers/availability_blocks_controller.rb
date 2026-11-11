class AvailabilityBlocksController < ApplicationController
  before_action :set_block, only: [ :update, :destroy ]

  def create
    @block = Current.user.availability_blocks.find_or_initialize_by(date: params.dig(:availability_block, :date))
    @block.update!(block_params)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to month_path(Month.new(@block.date)) }
    end
  end

  def update
    @block.update!(block_params)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to month_path(Month.new(@block.date)) }
    end
  end

  def destroy
    @block.destroy!

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to month_path(Month.new(@block.date)) }
    end
  end

  private

  def set_block
    @block = Current.user.availability_blocks.find(params[:id])
  end

  def block_params
    params.require(:availability_block).permit(:status, :time_label, :client_name)
  end
end
