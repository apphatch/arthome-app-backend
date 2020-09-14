module Apps
  class BaseFactory
    attr_accessor :name

    def initialize
      @object_mappings = {
        user_importer: Importers::BaseImporter,
        shop_importer: Importers::BaseImporter,
        stock_importer: Importers::BaseImporter,
        checklist_importer: Importers::BaseImporter,
        checklist_item_importer: Importers::BaseImporter,
        master_importer: Importers::BaseImporter,
      }
      @name = nil
    end

    def self.make app
      apps = {
        'osa-webportal' => ::Apps::OsaWebportalFactory,
        'qc-webportal' => ::Apps::QcWebportalFactory,
      }
      app_obj = apps[app] || self
      app_obj = app_obj.new
      app_obj.name = app
      app_obj.declare
      return app_obj
    end

    def use klass, options
      @object_mappings[options[:as]] = klass
    end

    def declare
    end

    def get object_klass
      return @object_mappings[object_klass]
    end
  end
end
