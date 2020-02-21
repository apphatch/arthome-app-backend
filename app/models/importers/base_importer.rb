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
          @uuid = {key: symbol.to_s, idx: idx}
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

      raise Exception.new 'uuid not found' if @uuid.nil?
      @spreadsheet.each do |row|
        next if row == headers

        header_mappings = @header_mappings.dup
        attributes = header_mappings.each{ |k, v|
          header_mappings[k] = row[v]
        }.reject{ |k, v|
          !@klass.new.attributes.keys.include?(k.to_s)
        }

        attributes = yield(attributes, row) if block_given?
        puts attributes

        obj = @klass.send "find_by_#{@uuid[:key]}".to_sym, row[@uuid[:idx]]

        if obj.nil?
          @klass.create attributes
        else
          obj.update attributes
        end
      end
    end

    def update
      # default update behaviour
      # only update, no create

      raise Exception.new 'uuid not found' if @uuid.nil?
      @spreadsheet.each do |row|
        next if row == headers

        obj = @klass.send "find_by_#{@uuid[:key]}", row[@uuid[:idx]]
        if obj.present?
          header_mappings = @header_mappings.dup
          attributes = header_mappings.each{ |k, v|
            header_mappings[k] = row[v]
          }.reject{ |k, v|
            !obj.attributes.keys.include?(k.to_s)
          }

          attributes = yield(attributes, row) if block_given?

          obj.update(attributes)
        end

      end
    end
  end
end
