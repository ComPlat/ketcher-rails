module Ketcherails
  class KetcherController < ::ApplicationController

    skip_before_filter :authenticate_user!
    helper KetcherHelper
    layout false

    def index
      @template_categories = TemplateCategory.with_approved_templates
    end
  end
end
