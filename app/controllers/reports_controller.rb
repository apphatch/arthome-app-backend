class ReportsController < ApplicationController
  def qc_summary
    report = @current_app.get(:summary_report).new permitted_params
    render json: report.generate
  end

  def qc_detail
    report = @current_app.get(:detail_report).new permitted_params
    render json: report.generate
  end

  def permitted_params
    params.permit!
    super params
  end
end
