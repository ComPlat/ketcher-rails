class AddIconAsAttachmentToCommonTemplates < ActiveRecord::Migration
  def change
    add_attachment :ketcherails_common_templates, :icon
  end
end
