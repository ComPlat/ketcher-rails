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

    def common_template_icon_tag tmpl
      opts = {
        title: tmpl.name,
        class: 'dropdownIconTemplate',
        id: 'commontemplate' + tmpl.id.to_s
      }
      if tmpl.sprite_class.present?
        sprite_tag(tmpl.sprite_class, opts)
      else
        image_tag(tmpl.icon.url(:small), opts)
      end
    end

    def template_category_icon_tag cat
      opts = {
        title: cat.name,
        class: 'sideButton',
        id: 'commontemplate' + cat.id.to_s
      }

      if cat.sprite_class.present?
        sprite_tag(cat.sprite_class, opts)
      else
        image_tag(cat.icon.url(:small), opts)
      end
    end

    def sprite_tag(name, options = {})
      options[:class] = "#{name} #{options[:class]}" # add sprite class
      image_tag('transparent.png', options) # image URL comes in CSS
    end

    def get_add_tr_count height
      delta = height*0.8 - 590
      return if delta <= 0

      (delta/36.0).round # each tr has 36px size
    end
  end
end
