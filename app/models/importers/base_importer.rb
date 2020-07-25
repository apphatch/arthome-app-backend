require 'roo'

module Importers
  class BaseImporter
    def initialize params={}
      # 1. override import or update methods
      # 2. declare index to grab attribute - column associations
      # 3. call super for default behaviour
      # 4. super accepts a block with attributes, associations and row data

      @header_mappings = {}
      @spreadsheet = nil
      @skip_if_record_exists = false

      f = params[:file] || "import/#{params[:file_name]}"
      begin
        @spreadsheet = Roo::Spreadsheet.open f
      rescue
        raise Exception.new 'file not found'
      end

      raise Exception.new 'must define @model_class' if @model_class.nil?
    end

    def data_headers
      return @spreadsheet.row(1)
    end

    def associate model_attr, allowed_data_headers, params={allow_dup: false, is_uuid: false}
      #alias of index, improves readability
      index model_attr, allowed_data_headers, params
    end

    def index model_attr, allowed_data_headers, params={allow_dup: false, is_uuid: false}
      idx = nil

      allowed_data_headers.each do |data_header|
        idx = data_headers.find_index(data_header)
        next if idx.nil?

        @uuid = {key: model_attr.to_s, idx: idx} if params[:is_uuid]

        unless @header_mappings.values.include?(idx) && !params[:allow_dup]
          @header_mappings = @header_mappings.merge(model_attr => idx)
          break
        end
      end

      if params[:is_uuid].present? && idx.nil?
        raise Exception.new 'uuid column not found'
      end

      return @header_mappings
    end

    def skip_if_record_exists
      @skip_if_record_exists = true
    end

    def import
      # default import behaviour
      # find and update or create

      raise Exception.new 'uuid not found' if @uuid.nil?
      @spreadsheet.each do |row|
        next if row == data_headers

        header_mappings = @header_mappings.dup
        attributes = header_mappings.dup.each{ |k, v|
          header_mappings[k] = row[v]
        }
        assocs = attributes.dup

        attr_assocs = yield(attributes, assocs, row) if block_given?
        raise Exception.new 'importer must return [attributes, assocs]' if attr_assocs.length != 2
        attributes, assocs = attr_assocs

        attributes = attributes.reject{ |k, v|
          !@model_class.new.attributes.keys.include?(k.to_s)
        }
        assocs = assocs.reject{ |k, v|
          !@model_class.new.public_methods.include?(k.to_sym) ||
            attributes.keys.include?(k.to_sym)
        }

        obj = @model_class.send "find_by_#{@uuid[:key]}".to_sym, row[@uuid[:idx]]

        next if (obj.present? && @skip_if_record_exists)

        if obj.nil?
          obj = @model_class.new attributes
        else
          obj.update attributes
        end

        assocs.each do |k, v|
          next if v.nil?
          begin
            assoc = obj.send k
            assoc.push(v) unless assoc.include?(v.id)
          rescue
            obj.send "#{k}=", v
          end
        end
        obj.save!
      end
    end

    def update
      # default update behaviour
      # only update, no create

      raise Exception.new 'uuid not found' if @uuid.nil?
      @spreadsheet.each do |row|
        next if row == data_headers

        obj = @model_class.send "find_by_#{@uuid[:key]}", row[@uuid[:idx]]
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
