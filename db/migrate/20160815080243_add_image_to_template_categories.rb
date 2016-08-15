class AddImageToTemplateCategories < ActiveRecord::Migration
  def change
    add_attachment :ketcherails_template_categories, :icon
  end
end
