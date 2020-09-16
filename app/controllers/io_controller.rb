require 'base64'

class IoController < ApplicationController
  #TODO move this into Apps model
  @endpoints = {
    oos: :oos_exporter,
    sos: :sos_exporter,
    npd: :npd_exporter,
    promotions: :promotions_exporter,
    osa_weekend: :osa_weekend_exporter,
    rental: :rental_exporter,
  }

  @endpoints.each do |k, v|
    define_method "export_osa_#{k.to_s}".to_sym do
      begin
        options = {
          output: "export/#{k.to_s}-export.xls"
        }.merge(permitted_params)
        exporter = @current_app.get(v).new options
        exporter.export
        f = File.open "export/#{k.to_s}-export.xls", 'rb'
        enc = Base64.encode64 f.read
        send_data enc, type: :xls, filename: "#{k.to_s}-export.xls"
      rescue
        head 500
      end
    end
  end

  def permitted_params
    return params.permit(:yearweek, :date_from, :date_to)
  end
end
