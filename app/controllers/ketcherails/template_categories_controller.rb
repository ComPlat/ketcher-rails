module Ketcherails
  class TemplateCategoriesController < ::ApplicationController
    before_action :check_user_permissions
    before_action :set_template_category, only: [:show, :edit, :update, :destroy]
    layout 'ketcherails/application'

    # GET /template_categories
    def index
      @template_categories = TemplateCategory.page params[:page]
    end

    # GET /template_categories/1
    def show
    end

    # GET /template_categories/new
    def new
      @template_category = TemplateCategory.new
    end

    # GET /template_categories/1/edit
    def edit
    end

    # POST /template_categories
    def create
      @template_category = TemplateCategory.new(template_category_params)
      @template_category.make_icon params[:svg] if params[:svg].present?

      if @template_category.save
        redirect_to @template_category, notice: 'Template category was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /template_categories/1
    def update
      if @template_category.update(template_category_params)
        redirect_to @template_category, notice: 'Template category was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /template_categories/1
    def destroy
      @template_category.destroy
      redirect_to template_categories_url, notice: 'Template category was successfully destroyed.'
    end

    private

      def check_user_permissions
        unless current_user && current_user.is_templates_moderator
          render :text => 'Unauthorized!', status: :unauthorized
        end
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_template_category
        @template_category = TemplateCategory.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def template_category_params
        params.require(:template_category).permit(:name)
      end

      def method_missing(method_name, *args, &block)
        return nil if method_name == :current_user
        super
      end
  end
end
