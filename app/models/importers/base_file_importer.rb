module Importers
  class BaseFileImporter
    def initialize params={}
      @model_class = params[:model_class]
    end

    def import
      # default import behaviour
      # find and update or create

      puts 'import files'
      raise Exception.new 'uid not found. use is_uid to declare uid model attribute.' if @uid_attr.nil?
    end

    def update
      # default update behaviour
      # only update, no create
    end
  end
end