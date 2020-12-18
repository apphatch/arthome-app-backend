module AppRouters
  class BaseFactory
    attr_accessor :name, :object_mappings

    def initialize
      @object_mappings = {
        app: nil,
        app_group: nil,
        default_locale: nil
      }
      @name = nil
    end

    def self.make app
      apps = {
        'osa-mobile' => ::AppRouters::OsaMobileFactory,
        'qc-mobile' => ::AppRouters::QcMobileFactory,
        'osa-webportal' => ::AppRouters::OsaWebportalFactory,
        'qc-webportal' => ::AppRouters::QcWebportalFactory,
      }
      app_obj = apps[app] || self
      app_obj = app_obj.new
      app_obj.name = app
      app_obj.declare
      return app_obj
    end

    def declare
      #do not raise exception, by default use self if no definitions given
      raise Exception 'you must declare mappings for each app'
    end

    def use klass, options
      @object_mappings[options[:as]] = klass
    end

    def get object_klass
      return @object_mappings[object_klass]
    end

    def inspect
      return @object_mappings
    end
  end
end
