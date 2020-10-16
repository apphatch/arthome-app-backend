require 'base64'

class IoController < ApplicationController
  #TODO move this into Apps model
  @exporters = {
    oos: :oos_exporter,
    sos: :sos_exporter,
    npd: :npd_exporter,
    promotions: :promotions_exporter,
    weekend: :osa_weekend_exporter,
    rental: :rental_exporter,
  }

  @exporters.each do |k, v|
    define_method "export_osa_#{k.to_s}".to_sym do
      begin
        options = {
          app: @current_app.get(:app),
          app_group: @current_app.get(:app_group),
          output: "export/#{k.to_s}-export.xls",
          yearweek: params[:yearweek],
          date_from: params[:date_from],
          date_to: params[:date_to],
        }
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

  @importers = {
    users: :user_importer,
    shops: :shop_importer,
    stocks: :stock_importer,
    checklists: :checklist_importer,
    checklist_items: :checklist_item_importer,
    full: :master_importer,
    photos: :photo_importer
  }

  @importers.each do |k, v|
    define_method "import_osa_#{k.to_s}".to_sym do
      begin
        importer_klass = @current_app.get(v)
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
      rescue
        head 500
      end
    end
  end

  def permitted_params
    return params.permit(:yearweek, :date_from, :date_to)
  end
end
