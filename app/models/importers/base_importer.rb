require 'roo'

module Importers
  class BaseImporter
    def initialize params={}
      @header_mappings = {}
      @spreadsheet = nil

      if params[:file_name].present?
        @spreadsheet = Roo::Spreadsheet.open "import/#{params[:file_name]}"
      else
        raise Exception.new 'file not found'
      end

      if @klass.nil?
        raise Exception.new 'must define @klass'
      end
    end

    def headers
      return @spreadsheet.row(1)
    end

    def index symbol, allowed_headers, params={allow_dup: false, is_uuid: false}
      idx = nil

      allowed_headers.each do |text|
        idx = headers.find_index(text)
        next if idx.nil?

        if params[:is_uuid]
          @uuid = {key: symbol, value: idx}
        end

        unless @header_mappings.values.include?(idx) && !params[:allow_dup]
          @header_mappings = @header_mappings.merge(
            symbol => idx
          )
          break
        end
      end

      if params[:is_uuid] && idx.nil?
        raise Exception.new 'uuid column not found'
      end

      return @header_mappings
    end

    def import
      # default import behaviour
      # find and update or create

      @spreadsheet.each do |row|

        header_mappings = @header_mappings.dup
        attributes = header_mappings.each do |k, v|
          header_mappings[k] = row[v]
        end
        obj = @klass.send "find_by_#{@uuid[:key]}".to_sym, @uuid[:value]

        if obj.nil?
          @klass.create attributes
        else
          obj.update_attributes attributes
        end
      end
    end

    def update
      # default update behaviour
      # only update, no create

      @spreadsheet.each do |row|

        obj = @klass.send "find_by_#{@uuid[:key]}", @uuid[:value]
        if obj.present?
          header_mappings = @header_mappings.dup
          attributes = header_mappings.each{ |k, v|
            header_mappings[k] = row[v]
          }
          obj.update_attributes attributes
        end

      end
    end
  end
end
