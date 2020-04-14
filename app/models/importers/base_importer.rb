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

      if params[:file_name].present?
        @spreadsheet = Roo::Spreadsheet.open "import/#{params[:file_name]}"
      else
        raise Exception.new 'file not found'
      end

      if @model_class.nil?
        raise Exception.new 'must define @model_class'
      end
    end

    def headers
      return @spreadsheet.row(1)
    end

    def associate model_symbol, allowed_headers, params={allow_dup: false, is_uuid: false}
      #alias of index
      index model_symbol, allowed_headers, params
    end

    def index model_symbol, allowed_headers, params={allow_dup: false, is_uuid: false}
      idx = nil

      allowed_headers.each do |text|
        idx = headers.find_index(text)
        next if idx.nil?

        if params[:is_uuid]
          @uuid = {key: model_symbol.to_s, idx: idx}
        end

        unless @header_mappings.values.include?(idx) && !params[:allow_dup]
          @header_mappings = @header_mappings.merge(
            model_symbol => idx
          )
          break
        end
      end

      if params[:is_uuid] && idx.nil?
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
        next if row == headers

        header_mappings = @header_mappings.dup
        attributes = header_mappings.each{ |k, v|
          header_mappings[k] = row[v]
        }
        header_mappings = @header_mappings.dup
        assocs = header_mappings.each{ |k, v|
          header_mappings[k] = row[v]
        }

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
          begin
            assoc = obj.send(k)
            assoc.push v unless (assoc.include?(v) || v.nil?)
          rescue
            obj.send("#{k}=", v) unless v.nil?
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
        next if row == headers

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
