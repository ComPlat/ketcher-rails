class AddIconAsAttachmentToCommonTemplates < ActiveRecord::Migration[4.2]
  def change
    add_attachment :ketcherails_common_templates, :icon
  end
end
