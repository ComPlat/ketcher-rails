class CreateKetcherailsTemplateCategories < ActiveRecord::Migration[4.2]
  def change
    create_table :ketcherails_template_categories do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
