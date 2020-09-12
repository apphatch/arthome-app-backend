module Apps
  class BaseFactory
    attr_accessor :name

    def initialize
      @object_mappings = {}
      @name = nil
    end

    def self.make app
      apps = {
        'osa-webportal' => ::Apps::OsaWebportalFactory,
        'qc' => ::Apps::QcMobileFactory,
      }
      app_obj = apps[app].new
      app_obj.name = app
      app_obj.declare
      return app_obj
    end

    def use klass, options
      @object_mappings[options[:as]] = klass
    end

    def declare
      raise Exception.new 'provide declaration of object mappings'
    end

    def get object_klass
      return @object_mappings[object_klass]
    end
  end
end
