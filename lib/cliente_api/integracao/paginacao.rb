module ClienteAPI
  module Integracao
    class Paginacao
      def self.build(object)
        object = object.deep_symbolize_keys

        entidades = object[:entidades]

        if object[:meta] && object[:meta].any? && meta = object[:meta]
          total    = meta[:total]
          page     = meta[:pagina]
          per_page = meta[:por_pagina]
        else
          total    = entidades.size
          page     = 1
          per_page = total
        end

        per_page = 1 if per_page.try(:zero?)

        Kaminari.paginate_array(entidades, total_count: total).page(page).per(per_page)
      end
    end
  end
end
