require 'cliente_api/integracao/dados'
require 'cliente_api/integracao/associacao'

module ClienteAPI
  class Model
    include ActiveModel::Model
    extend  ActiveModel::Naming
    include ClienteAPI::Base
    include ClienteAPI::Integracao::Dados
    include ClienteAPI::Integracao::Associacao

    attr_accessor :errors

    def initialize(attributes={})
      super
    end

    def read_attribute_for_validation(attr)
      send(attr)
    end

    def self.human_attribute_name(attr, options = {})
      attr
    end

    def self.lookup_ancestors
      [self]
    end

    def valid?
      return true if errors.nil?
      false
    end

    def attributes
      self.as_json.except("id")
    end

    def self.resource_name
      self.name.pluralize.underscore.downcase
    end

    def resource_name
      resource = ""
      if resource_path
        resource_path.each do |path|
          resource << "/#{path.first}"
          resource << "/#{path.last}" if path.last
        end
      end

      "#{resource}/#{self.class.resource_name}"
    end

    def resource_path
      nil
    end
  end
end