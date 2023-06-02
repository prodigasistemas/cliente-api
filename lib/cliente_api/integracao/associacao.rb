require 'cliente_api/integracao/paginacao'

module ClienteAPI
  module Integracao
    module Associacao
      extend ActiveSupport::Concern

      module ClassMethods
        def has_many relations, options = {}
          instance_eval do
            define_method("#{relations}") do |args = {}|
              attrs = { "entidades" => self.attributes[relations.to_s] }
              attrs = fetch_lazy(relations, args) if attrs["entidades"].blank?

              return [] if attrs.blank? && attrs["entidades"].blank?

              attrs["entidades"].map! do |relation|
                relations.to_s.classify.constantize.new(relation)
              end

              if sort_field = options[:order]
                attrs["entidades"] = attrs["entidades"].sort_by{ |r| r.send(sort_field) }
              end

              ClienteAPI::Integracao::Paginacao.build(attrs)
            end
          end
        end

        def belongs_to relation
          instance_eval do
            define_method("#{relation}") do
              attrs = self.attributes[relation.to_s]
              attrs = fetch_lazy(relation)["entidade"] if attrs.blank?

              return if attrs.blank?

              relation.to_s.classify.constantize.new(attrs)
            end
          end
        end

        alias_method :has_one, :belongs_to
      end
    end
  end
end