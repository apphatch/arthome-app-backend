module Apps
  class BaseFactory
    def initialize
      @object_mappings = {}
    end

    def self.make app
      apps = {
        'osa-webportal' => ::Apps::OsaWebportalFactory,
      }
      app = apps[app].new
      app.declare
      return app
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
