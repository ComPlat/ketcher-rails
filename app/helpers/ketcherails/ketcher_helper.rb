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

    def template_category_icon_tag cat
      if cat.sprite_class.present?
        sprite_tag cat.sprite_class, title: cat.name, class: 'sideButton', id: 'commontemplate' + cat.id.to_s
      else
        image_tag cat.icon.url(:small), title: cat.name, class: 'sideButton', id: 'commontemplate' + cat.id.to_s
      end
    end

    def sprite_tag(name, options = {})
      options[:class] = "#{name} #{options[:class]}" # add sprite class
      image_tag('', options) # image URL comes in CSS
    end
  end
end
