class AddImageToTemplateCategories < ActiveRecord::Migration[4.2]
  def change
    add_attachment :ketcherails_template_categories, :icon
  end
end
