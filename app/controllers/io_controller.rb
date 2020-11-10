require 'base64'

class IoController < ApplicationController
  @current_app.object_mappings.each do |k, _|
    obj_name = k.to_s
    next unless obj_name.match(/exporter$/) #enforce xxx_exporter endpoint
    define_method "#{obj_name.gsub('exporter', 'export')}".to_sym do
      begin
        export_file = "export/#{obj_name}-results.xls"
        options = {
          app: @current_app.get(:app),
          app_group: @current_app.get(:app_group),
          output: export_file,
          yearweek: params[:yearweek],
          date_from: params[:date_from],
          date_to: params[:date_to],
        }
        exporter = @current_app.get(k).new options
        exporter.export
        f = File.open export_file, 'rb'
        enc = Base64.encode64 f.read
        send_data enc, type: :xls, filename: export_file
      rescue => e
        Rails.logger.warn e
        head 500
      end
    end
  end

  @current_app.object_mappings.each do |k, _|
    obj_name = k.to_s
    next unless obj_name.match(/importer$/) #enforce xxx_importer endpoint
    define_method "#{obj_name.gsub('importer', 'import')}".to_sym do
      begin
        importer_klass = @current_app.get(k)
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
  end

  def permitted_params
    return params.permit(:yearweek, :date_from, :date_to)
  end
end
