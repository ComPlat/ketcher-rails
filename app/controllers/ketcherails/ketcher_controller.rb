module Ketcherails
  class KetcherController < ::ApplicationController

    skip_before_action :authenticate_user!
    helper KetcherHelper
    layout false

    def index
      @template_categories = TemplateCategory.with_approved_templates
      @show_attachment_point = current_user &&
        current_user.is_templates_moderator &&
        (request.referer.to_s.include?('atom_abbreviations') ||
          request.referer.to_s.include?('amino_acids'))

      @show_attachment_point2 = current_user &&
        current_user.is_templates_moderator &&
        request.referer.to_s.include?('amino_acids')

      @atom_abbreviation_list = AtomAbbreviation.approved.pluck(:name)
    end

    def demo; end

    def method_missing(method_name, *args, &block)
      return nil if method_name == :current_user
      super
    end
  end
end
