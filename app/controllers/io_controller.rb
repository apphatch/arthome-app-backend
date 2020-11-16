require 'base64'

class IoController < ApplicationController
  include Nameable

  def export
    begin
      file_name = "export/" << generate_salted_name([params[:export_endpoint], 'results'], '.xls')
      options = {
        app: @current_app.get(:app),
        app_group: @current_app.get(:app_group),
        output: file_name,
        yearweek: params[:yearweek],
        date_from: params[:date_from],
        date_to: params[:date_to],
      }

      exporter_name = params[:export_endpoint].to_s + 'er'
      exporter = @current_app.get(exporter_name.to_sym).new options
      exporter.export

      f = File.open file_name, 'rb'
      enc = Base64.encode64 f.read
      send_data enc, type: :xls, filename: file_name

    rescue => e
      Rails.logger.warn e
      head 500
    end
  end

  def import
    begin
      importer_name = params[:import_endpoint].to_s + 'er'
      importer_klass = @current_app.get importer_name.to_sym

      params[:files].each do |f|
        #TODO: resque still doesn't work correctly
        #req = WorkerRequest.create(
        #  worker_class: importer_klass.to_s,
        #  file: f
        #)
        #Resque.enqueue(ImportJob, req.id)
        importer = importer_klass.new(
          file: f,
          app: @current_app.get(:app),
          app_group: @current_app.get(:app_group)
        )
        importer.import
      end
      head 201
    rescue => e
      Rails.logger.warn e
      head 500
    end
  end

  def permitted_params
    return params.permit(:yearweek, :date_from, :date_to)
  end
end
