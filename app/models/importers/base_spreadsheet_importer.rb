require 'roo'
require 'roo-xls'

module Importers
  class BaseSpreadsheetImporter
    def initialize params={}
      # 1. override import or update methods
      # 2. declare index to grab attribute - column associations
      # 3. call super for default behaviour
      # 4. super accepts a block with attributes, associations and row data

      @params = params
      @header_mappings ||= {}
      @uid_attr ||= nil
      @spreadsheet ||= nil
      @skip_if_record_exists ||= false
      @auto_gen_uid ||= false
      @model_attrs_to_use ||= []
      @prefix ||= ''
      @app_group ||= params[:app_group]

      #for indexers
      @attribute_idx ||= {}
      @temp_attribute_idx ||= {}
      @assoc_idx ||= {}

      #dealing with actiondispatch uploaded files, absolute and relative file paths, and lastly try file object
      f = params[:file].try(:path) || params[:file_path] || "import/#{params[:file_name]}"

      begin
        klass = Roo::Excel if f.match(/\.xls/)
        klass = Roo::Excelx if f.match(/\.xlsx/)
        @spreadsheet = klass.new f
      rescue
        f = File.open f
      end

      begin
        @spreadsheet ||= Roo::Spreadsheet.open f, extension: :xlsx
      rescue => e
        Rails.logger.warn e
      end

      begin
        @spreadsheet ||= Roo::Spreadsheet.open f, extension: :xls
      rescue => e
        Rails.logger.warn e
      end

      raise Exception.new 'file not found' if @spreadsheet.nil?
      raise Exception.new 'must define @model_class' if @model_class.nil?
      @model_class_instance = @model_class.new
    end

    def skip_if_record_exists
      @skip_if_record_exists = true
    end

    def is_uid model_attr
      @uid_attr = model_attr
    end

    def auto_gen_uid_with_attributes model_attrs_to_use=[:all], params={prefix: ''}
      @auto_gen_uid = true
      @model_attrs_to_use = model_attrs_to_use
      @prefix = params[:prefix]
    end

    def perform_index model_attr, allowed_data_headers, params={as: nil}
      idx = nil
      typecast_method = {
        string: :to_s,
        int: :to_i,
        float: :to_f,
      }[params[:as].try(:to_sym)]

      allowed_data_headers.each do |data_header|
        idx = data_headers.find_index(data_header)
        next if idx.nil?

        return {model_attr => [idx, typecast_method]}
      end

      return {}
    end

    #--------------------------------------------------------------------------
    #public declarative methods

    def index model_attr, allowed_data_headers, params={as: :none}
      # index model attributes
      @attribute_idx ||= {}
      @attribute_idx = @attribute_idx.merge(
        perform_index model_attr, allowed_data_headers, params
      )
    end

    def index_temp model_attr, allowed_data_headers, params={as: :none}
      # index temporary attributes for later use
      @temp_attribute_idx ||= {}
      @temp_attribute_idx = @temp_attribute_idx.merge(
        perform_index model_attr, allowed_data_headers, params
      )
    end

    def associate model_attr, allowed_data_headers, params={as: :none}
      # index model associations
      @assoc_idx ||= {}
      @assoc_idx = @assoc_idx.merge(
        perform_index model_attr, allowed_data_headers, params
      )
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
      return @prefix + model_attrs.collect{|k, v| v.to_s}.join()
    end

    def import
      perform :import do |attributes, temp_attributes, assocs, row|
        yield(attributes, temp_attributes, assocs, row) if block_given?
        [attributes, temp_attributes, assocs]
      end
    end

    def update
      perform :update do |attributes, temp_attributes, assocs, row|
        yield(attributes, temp_attributes, assocs, row) if block_given?
        [attributes, temp_attributes, assocs]
      end
    end

    def fetch_values attr_idx_mapping, row
      attr_value_mapping = {}
      attr_idx_mapping.each do |k, v|
        attr_value_mapping[k] = row[v[0]]
        attr_value_mapping[k] = row[v[0]].try(:send, v[1]) if v[1].present?
      end

      return attr_value_mapping
    end

    def perform mode=:import
      raise Exception.new 'uid not found. use is_uid to declare uid model attribute.' if @uid_attr.nil?
      @spreadsheet.each do |row|
        next if row == data_headers

        # convert indices to actual data
        attributes = fetch_values @attribute_idx, row
        temp_attributes = fetch_values @temp_attribute_idx, row
        assocs = fetch_values @assoc_idx, row

        # prepare and yield data for manipulation before import
        attr_assocs = [attributes, temp_attributes, assocs]
        attr_assocs = yield(attributes, temp_attributes, assocs, row) if block_given?
        raise Exception.new 'importer must return [attributes, temp_attributes, assocs]' if attr_assocs.length != 3
        attributes, temp_attributes, assocs = attr_assocs
        # temp_attributes used for uid autogen, then thrown away
        temp_attributes = temp_attributes.merge attributes

        # perform import
        attributes[@uid_attr] = auto_gen_uid(temp_attributes, @model_attrs_to_use) if @auto_gen_uid

        # find or create object instance
        raise Exception.new 'uid not indexed' if attributes[@uid_attr].nil?
        obj = @model_class.active.send "find_by_#{@uid_attr}".to_sym, attributes[@uid_attr]
        next if (obj.present? && @skip_if_record_exists)
        next if (mode == :update && obj.nil?)
        obj = @model_class.new attributes if obj.nil?

        # fill object data
        obj.assign_attributes attributes
        assocs.each do |k, v|
          next if v.nil?
          begin
            # check if k is an association, if not rescue and assign attribute
            assoc = obj.send k
            assoc.push(v) unless assoc.include?(v)
          rescue
            obj.send "#{k}=", v
          end
        end
        obj.app_group = @app_group
        begin
          obj.save!
        rescue => e
          puts e
          Rails.logger.warn e
        end
      end
    end

    def self.template headers, file=nil
      raise Exception 'provide a file path' if file.nil?
      book = Spreadsheet::Workbook.new
      sheet = book.create_worksheet
      sheet.row(0).concat(headers)
      book.write file
    end
  end
end
