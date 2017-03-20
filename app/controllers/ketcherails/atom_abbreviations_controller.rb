module Ketcherails
  class AtomAbbreviationsController < ::ApplicationController
    before_action :check_user_permissions
    before_action :set_atom_abbreviation, only: %i(show edit update destroy)
    layout 'ketcherails/application'
    helper AtomAbbreviationsHelper
    PER_PAGE = 10

    # GET /atom_abbreviations
    def index
      per_page = params[:per_page] || PER_PAGE

      @atom_abbreviations = AtomAbbreviation.order('updated_at DESC')
                                            .page params[:page]
    end

    # GET /atom_abbreviations/1
    def show
    end

    # GET /atom_abbreviations/new
    def new
      @atom_abbreviation = AtomAbbreviation.new
    end

    # GET /atom_abbreviations/1/edit
    def edit
    end

    # POST /atom_abbreviations
    def create
      list = atom_abbreviation_params[:molfile].split('$$$$').reject do |item|
        item.blank?
      end
      if list.size > 1
        index = 0 # we use it outside of cycle, so forget `each_with_index`
        list = list.reject &:blank?
        list.each do |molfile|
          atom_abbreviation = AtomAbbreviation.new(atom_abbreviation_params)
          atom_abbreviation.name = atom_abbreviation.name + '_' + index.succ.to_s
          lines = molfile.lines
          lines.prepend("\n") unless lines[0].blank?
          lines.delete_at 1 # delete template file name
          atom_abbreviation.molfile = lines.join
          atom_abbreviation.status ||= 'approved'
          atom_abbreviation.approved_at = Time.now
          atom_abbreviation.save!

          index += 1
        end

        redirect_to atom_abbreviations_url,
                    notice: "Created #{index} templates."
      else
        @atom_abbreviation = AtomAbbreviation.new(atom_abbreviation_params)
        @atom_abbreviation.make_icon params[:svg] if params[:svg].present?
        @atom_abbreviation.status ||= 'approved'
        @atom_abbreviation.approved_at = Time.now

        if @atom_abbreviation.save
          redirect_to @atom_abbreviation, notice: 'Atom abbreviation was successfully created.'
        else
          render :new
        end
      end
    end

    # PATCH/PUT /atom_abbreviations/1
    def update
      @atom_abbreviation.attributes = atom_abbreviation_params
      @atom_abbreviation.make_icon params[:svg] if params[:svg].present?
      if @atom_abbreviation.save
        redirect_to @atom_abbreviation,
                    notice: 'Atom abbreviation was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /atom_abbreviations/1
    def destroy
      @atom_abbreviation.destroy
      redirect_to atom_abbreviations_url,
                  notice: 'Atom abbreviation was successfully destroyed.'
    end

private

    def check_user_permissions
      unless current_user && current_user.is_templates_moderator
        render :text => 'Unauthorized!', status: :unauthorized
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_atom_abbreviation
      @atom_abbreviation = AtomAbbreviation.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def atom_abbreviation_params
      params.require(:atom_abbreviation).permit(:name, :rtl_name, :notes,
        :molfile, :status)
    end
  end
end
