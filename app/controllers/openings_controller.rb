class OpeningsController < ApplicationController
  def show
    from = params[:from] ? Date.parse(params[:from]) : Date.today.beginning_of_month
    to = params[:to] ? Date.parse(params[:to]) : Date.today.end_of_month

    template = if params[:template_id]
      Current.user.templates.find(params[:template_id])
    else
      Current.user.templates.ordered.first
    end

    respond_to do |format|
      format.text do
        if template
          render plain: helpers.render_template(template.body, from, to)
        else
          render plain: "No templates found."
        end
      end
      format.html { redirect_to calendar_path }
    end
  end
end
