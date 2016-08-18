module Ketcherails
  module KetcherHelper
    def ketcher_layout_cache_key
      result = 'ketcher'
      [TemplateCategory, CommonTemplate, CustomTemplate].each do |model|
        record = model.order('updated_at DESC').first
        if record
          result += record.updated_at.to_i.to_s
        end
      end

      result
    end

    def inline_template tmpl
      klass = (tmpl.class.name.split('::')[1] + 'Serializer').constantize
      klass.new(tmpl).to_json.html_safe
    end
  end
end
