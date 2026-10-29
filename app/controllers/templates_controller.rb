class TemplatesController < ApplicationController
  before_action :set_template, only: [ :edit, :update, :destroy ]

  def index
    @templates = Current.user.templates.ordered
  end

  def new
    @template = Current.user.templates.new(position: Current.user.templates.count)
  end

  def create
    @template = Current.user.templates.new(template_params)
    if @template.save
      redirect_to templates_path, notice: "Template created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @template.update(template_params)
      redirect_to templates_path, notice: "Template updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @template.destroy!
    redirect_to templates_path, notice: "Template deleted."
  end

  private

  def set_template
    @template = Current.user.templates.find(params[:id])
  end

  def template_params
    params.require(:template).permit(:name, :body, :position)
  end
end
