require 'base64'

class IoController < ApplicationController
  @endpoints = {
    oos: :oos_exporter,
    sos: :sos_exporter,
  }

  @endpoints.each do |k, v|
    define_method "export_osa_#{k.to_s}".to_sym do
      begin
        exporter = @current_app.get(v).new(output: "export/#{k.to_s}-export.xls")
        exporter.export
        f = File.open "export/#{k.to_s}-export.xls", 'rb'
        enc = Base64.encode64 f.read
        send_data enc, type: :xls, filename: "#{k.to_s}-export.xls"
      rescue
        head 500
      end
    end
  end
end
