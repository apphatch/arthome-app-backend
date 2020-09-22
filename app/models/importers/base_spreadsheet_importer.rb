require 'roo'
require 'roo-xls'

module Importers
  class BaseSpreadsheetImporter
    def initialize params={}
      # 1. override import or update methods
      # 2. declare index to grab attribute - column associations
      # 3. call super for default behaviour
      # 4. super accepts a block with attributes, associations and row data

      @header_mappings = {}
      @uid_attr =nil
      @spreadsheet = nil
      @skip_if_record_exists = false
      @auto_gen_uid = false
      @model_attrs_to_use = []
      @bypass_filter_attrs = []

      #dealing with actiondispatch uploaded files and normal file paths
      f = params[:file].path() || "import/#{params[:file_name]}"
      begin
        klass = Roo::Excel
        klass = Roo::Excelx if f.match(/\.xlsx/)
        @spreadsheet = klass.new f
      rescue
        raise Exception.new 'file not found'
      end

      raise Exception.new 'must define @model_class' if @model_class.nil?
      @model_class_instance = @model_class.new
    end

    def skip_if_record_exists
      @skip_if_record_exists = true
    end

    def is_uid model_attr
      @uid_attr = model_attr
    end

    def auto_gen_uid_with model_attrs_to_use=[:all]
      @auto_gen_uid = true
      @model_attrs_to_use = model_attrs_to_use
    end

    def index model_attr, allowed_data_headers, params={allow_dup: false, as: nil}
      idx = nil
      typecast_method = {
        string: :to_s,
        int: :to_i,
        float: :to_f,
      }[params[:as].try(:to_sym)]

      allowed_data_headers.each do |data_header|
        idx = data_headers.find_index(data_header)
        next if idx.nil?

        unless @header_mappings.values.include?(idx) && !params[:allow_dup]
          @header_mappings = @header_mappings.merge(model_attr => [idx, typecast_method])
          break
        end
        @bypass_filter_attrs += [model_attr] if params[:bypass_filter]
      end

      return @header_mappings
    end

    def associate model_attr, allowed_data_headers, params={allow_dup: false, as: :none}
      #alias of index, improves readability
      index model_attr, allowed_data_headers, params
    end

    #--------------------------------------------------------------------------
    #main

    def data_headers
      return @spreadsheet.row(1)
    end

    def auto_gen_uid model_attrs, model_attrs_to_use=[:all]
      unless model_attrs_to_use == [:all]
        model_attrs = model_attrs.select{|k, v| model_attrs_to_use.include? k}
      end
      return model_attrs.collect{|k, v| v.to_s}.join()
    end

    def import
      # default import behaviour
      # find and update or create

      raise Exception.new 'uid not found. use is_uid to declare uid model attribute.' if @uid_attr.nil?
      @spreadsheet.each do |row|
        next if row == data_headers

        # get data from file header mappings
        header_mappings = @header_mappings.dup
        attributes = header_mappings.each do |k, v|
          # v = [value, typecast method]
          header_mappings[k] = row[v[0]]
          header_mappings[k] = row[v[0]].try(:send, v[1]) if v[1].present?
        end
        assocs = attributes.dup

        # prepare and yield data for manipulation before import
        attr_assocs = [attributes, assocs]
        attr_assocs = yield(attributes, assocs, row) if block_given?
        raise Exception.new 'importer must return [attributes, assocs]' if attr_assocs.length != 2
        attributes, assocs = attr_assocs
        auto_gen_uid_attributes = attributes.dup

        # clean data
        attributes = attributes.reject{ |k, v|
          (
            @model_class_instance.attributes.keys + @bypass_filter_attrs
          ).exclude? k.to_s
        }
        assocs = assocs.reject{ |k, v|
          !@model_class_instance.public_methods.include?(k.to_sym) ||
            attributes.keys.include?(k.to_sym)
        }

        # perform import
        if @auto_gen_uid
          uid = auto_gen_uid(auto_gen_uid_attributes, @model_attrs_to_use)
        else
          uid = attributes[@uid_attr]
          raise Exception.new 'uid not indexed' if uid.nil?
        end

        # find or create object
        attributes[@uid_attr] = uid
        obj = @model_class.send "find_by_#{@uid_attr}".to_sym, uid
        next if (obj.present? && @skip_if_record_exists)
        obj = @model_class.new attributes if obj.nil?

        # fill object data
        obj.assign_attributes(attributes)
        assocs.each do |k, v|
          next if v.nil?
          begin
            assoc = obj.send k
            assoc.push(v) unless assoc.include?(v)
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
    end

    def self.template headers
      book = Spreadsheet::Workbook.new
      sheet = book.create_worksheet
      sheet.row(0).concat(headers)
      book.write 'export/import-template.xls'
    end
  end
end
