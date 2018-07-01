module Ketcherails
  class CommonTemplatesController < ::ApplicationController
    before_action :check_user_permissions
    before_action :set_common_template, only: %i(show edit update destroy)
    before_action :set_template_categories, only: [:new, :edit]
    layout 'ketcherails/application'
    helper CommonTemplatesHelper
    PER_PAGE = 10

    # GET /common_templates
    def index
      per_page = params[:per_page] || PER_PAGE

      @common_templates = CommonTemplate.order('updated_at DESC')
                                        .includes(:template_category)
                                        .page params[:page]
    end

    # GET /common_templates/1
    def show
    end

    # GET /common_templates/new
    def new
      @common_template = CommonTemplate.new
    end

    # GET /common_templates/1/edit
    def edit
    end

    # POST /common_templates
    def create
      list = common_template_params[:molfile].split('$$$$').reject do |item|
        item.blank?
      end
      if list.size > 1
        index = 0 # we use it outside of cycle, so forget `each_with_index`
        list = list.reject &:blank?
        list.each do |molfile|
          common_template = CommonTemplate.new(common_template_params)
          common_template.name = common_template.name + '_' + index.succ.to_s
          lines = molfile.lines
          lines.prepend("\n") unless lines[0].blank?
          lines.delete_at 1 # delete template file name
          common_template.molfile = lines.join
          common_template.status ||= 'approved'
          common_template.approved_at = Time.now
          common_template.save!

          index += 1
        end

        redirect_to common_templates_url,
                    notice: "Created #{index} templates."
      else
        @common_template = CommonTemplate.new(common_template_params)
        @common_template.make_icon params[:svg] if params[:svg].present?
        @common_template.status ||= 'approved'
        @common_template.approved_at = Time.now

        if @common_template.save
          redirect_to @common_template, notice: 'Common template was successfully created.'
        else
          render :new
        end
      end
    end

    # PATCH/PUT /common_templates/1
    def update
      @common_template.attributes = common_template_params
      @common_template.make_icon params[:svg] if params[:svg].present?
      if @common_template.save
        redirect_to @common_template,
                    notice: 'Common template was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /common_templates/1
    def destroy
      @common_template.destroy
      redirect_to common_templates_url,
                  notice: 'Common template was successfully destroyed.'
    end

private
    def check_user_permissions
      unless current_user && current_user.is_templates_moderator
        render :text => 'Unauthorized!', status: :unauthorized
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_common_template
      @common_template = CommonTemplate.find(params[:id])
    end

    def set_template_categories
      @template_categories = TemplateCategory.all
    end

    # Only allow a trusted parameter "white list" through.
    def common_template_params
      params.require(:common_template).permit(:name, :notes, :molfile,
        :template_category_id, :status)
    end

    def method_missing(method_name, *args, &block)
      return nil if method_name == :current_user
      super
    end
  end
end
