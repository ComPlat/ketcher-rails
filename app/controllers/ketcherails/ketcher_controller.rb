module Ketcherails
  class KetcherController < ::ApplicationController

    skip_before_filter :authenticate_user!
    helper KetcherHelper
    layout false
    DEFAULT_SCREEN_H = 1080

    def index
      @template_categories = TemplateCategory.with_approved_templates
      @user_templates = CustomTemplate.where(user: current_user)
      if params[:add_tr_count].present?
        @add_tr_count = params[:add_tr_count].to_i
      else
        screen_height = (params[:height] || DEFAULT_SCREEN_H).to_i
        @add_tr_count = get_add_tr_count(screen_height)
      end
    end

  private

    def get_add_tr_count height
      delta = height*0.75 - 590
      return 0 if delta <= 0

      (delta/36.0).round # each tr has 36px size
    end
  end
end
