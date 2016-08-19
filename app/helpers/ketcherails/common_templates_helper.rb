module Ketcherails
  module CommonTemplatesHelper
    def template_category_select form
      opts = options_from_collection_for_select(
          @template_categories, "id","name", @common_template.template_category_id
        )
      form.select :template_category_id, opts, class: 'form-control'
    end

    def status_select form
      status = @common_template.status
      opts = options_for_select(CommonTemplate::STATUSES, status)

      form.select :status, opts, class: 'form-control'
    end

    def ketcher_layout_cache_key
      'ketcher' +
      Ketcherails::TemplateCategory.order('updated_at DESC').first.updated_at +
      Ketcherails::CommonTemplate.order('updated_at DESC').first.updated_at +
      Ketcherails::CustomTemplate.where(user: current_user).order('updated_at DESC').first.updated_at
    end
  end
end
