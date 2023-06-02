module ClienteAPI
  module Integracao
    module Autenticacao
      def autenticar(params)
        begin
          self.new autenticar_usuario(params)
        rescue RestClient::Unauthorized
          usuario = self.new
          usuario.errors = ActiveModel::Errors.new(usuario)
          usuario.errors[:nome_usuario] << "Nome de usuário ou Senha inválido"
          usuario.errors[:senha] << "Nome de usuário ou Senha inválido"
          usuario
        rescue
          raise "Falha na comunicação com a API"
        end
      end

      def autenticar_usuario(params)
        @authorization = self.basic_auth
        response = RestClient.post "#{ClienteAPI::Base::URL_BASE}/autenticacao", params, @authorization
        json = JSON.parse(response.body)

        json["usuario"]
      end
    end
  end
end
