class ReportsController < ApplicationController
  def qc_summary
    report = @current_app.get(:summary_report).new
    render json: report.generate
  end

  def qc_detail
    report = @current_app.get(:detail_report).new
    render json: report.generate
  end
end
