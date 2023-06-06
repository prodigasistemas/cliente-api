require 'base64'

module ClienteAPI
  module Integracao
    module Requisicao
      def get(path=[], params = {})
        if params.any?
          response = RestClient.get filter_url + params.to_query, {Authorization: ENV['TOKEN'] }.to_h
        else
          response = RestClient.get build_url(path), {Authorization: ENV['TOKEN'] }.to_h
        end

        JSON.parse(response.body)
      end

      def get_relations(path=[], params = {})
        response = RestClient.get relations_url + params.to_query, {Authorization: ENV['TOKEN'] }.to_h
        JSON.parse(response.body)
      end

      def get_with_params(path=[], params = {}, page_params = {})
        query = { query: params.merge(page_params) }
        response = RestClient::Request.execute(method: :get, 
                                               url: build_url(path) + "?" + query.to_query, 
                                               read_timeout: 300,
                                               headers: {Authorization: ENV['TOKEN'] }.to_h)
        JSON.parse(response.body)
      end

      def post(path=[], params={})
        response = RestClient.post build_url(path), params.try(:to_h), {Authorization: ENV['TOKEN'] }.to_h
        JSON.parse(response.body)
      end

      def put(path=[], params={})
        response = RestClient.put build_url(path), params.try(:to_h), {Authorization: ENV['TOKEN'] }.to_h
        JSON.parse(response.body)
      end

      def delete(path=[])
        response = RestClient.delete build_url(path), {Authorization: ENV['TOKEN'] }.to_h
        JSON.parse(response.body)
      end

      def build_url(path)
        resource = self.resource_name
        url_base = "#{ClienteAPI::Base::URL_BASE}/#{resource}"

        path.each { |item| url_base.concat "/#{item}" }

        url_base
      end

      def filter_url
        "#{ClienteAPI::Base::URL_BASE}/filtros?"
      end

      def relations_url
        "#{ClienteAPI::Base::URL_BASE}/associacoes?"
      end

      class ExcecaoNaoConcluido < StandardError
        def initialize(klass, error)
          @klass = klass
          @error = error
        end

        def message
          @error.message
        end

        def entidade
          entidade = @klass.new

          entidade.errors = ActiveModel::Errors.new(entidade)
          errors = JSON.parse(@error.response)
          errors["errors"].each do |key, messages|
            messages.each { |message| entidade.errors[key] << message }
          end

          entidade
        end

        def self.basic_auth
          client_id = ENV['CLIENT_ID']
          client_secret = ENV['CLIENT_SECRET']

          basic = Base64.encode64(client_id + ":" + client_secret).force_encoding('UTF-8')

          headerBasic = {Authorization: "BASIC #{basic}"}

          reponse = RestClient::Request.execute(method: :get, 
                                               url: "#{ClienteAPI::Base::URL_BASE}/basic_auth", 
                                               read_timeout: 300,
                                               headers: headerBasic.to_h)

          respJson = JSON.parse(response)

          headerBearer = {Authorization: "#{parseJson['token_type']} #{parseJson['access_token']}"}          

          headerBearer.to_h
        end

      end
    end
  end
end
