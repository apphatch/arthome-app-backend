require 'base64'

class IoController < ApplicationController
  include Nameable

  def export
    begin
      file_name = "export/" << generate_salted_name([params[:export_endpoint], 'results'], extension: '.xls')
      exporter_name = params[:export_endpoint].to_s + 'er'
      exporter = @current_app.get(exporter_name.to_sym).new permitted_params.merge(output: file_name)
      photo_urls = exporter.export #assignment to work for photo exports only at the moment

      if params[:export_endpoint] == 'photo_export'
        render json: photo_urls and return
      end

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

  def import_template
    begin
      template_file = "import/" << generate_name([params[:import_template_endpoint], 'template'], extension: '.xls')

      importer_name = params[:import_template_endpoint].to_s + 'er'
      importer_klass = @current_app.get(importer_name.to_sym)
      # REFAC this when possible
      importer_klass.template template_file
      importer_klass.template_rental template_file if params[:rental]

      f = File.open template_file, 'rb'
      enc = Base64.encode64 f.read
      send_data enc, type: :xls, filename: template_file
    rescue => e
      Rails.logger.warn e
      head 500
    end
  end

  def permitted_params
    super params.permit(:yearweek, :date_from, :date_to)
  end
end
