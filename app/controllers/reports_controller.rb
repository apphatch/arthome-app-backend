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
    return params.permit(:date_from, :date_to)
  end
end
