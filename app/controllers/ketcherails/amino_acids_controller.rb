module Ketcherails
  class AminoAcidsController < ::ApplicationController
    before_action :check_user_permissions
    before_action :set_amino_acid, only: %i(show edit update destroy)
    layout 'ketcherails/application'
    helper AminoAcidsHelper
    PER_PAGE = 10

    # GET /amino_acids
    def index
      per_page = params[:per_page] || PER_PAGE

      @amino_acids = AminoAcid.order('updated_at DESC')
                                            .page params[:page]
    end

    # GET /amino_acids/1
    def show
    end

    # GET /amino_acids/new
    def new
      @amino_acid = AminoAcid.new
    end

    # GET /amino_acids/1/edit
    def edit
    end

    # POST /amino_acids
    def create
      list = amino_acid_params[:molfile].split('$$$$').reject do |item|
        item.blank?
      end
      if list.size > 1
        index = 0 # we use it outside of cycle, so forget `each_with_index`
        list = list.reject &:blank?
        list.each do |molfile|
          amino_acid = AminoAcid.new(amino_acid_params)
          amino_acid.name = amino_acid.name + '_' + index.succ.to_s
          lines = molfile.lines
          lines.prepend("\n") unless lines[0].blank?
          lines.delete_at 1 # delete template file name
          amino_acid.molfile = lines.join
          amino_acid.status ||= 'approved'
          amino_acid.approved_at = Time.now
          amino_acid.save!

          index += 1
        end

        redirect_to amino_acids_url,
                    notice: "Created #{index} templates."
      else
        @amino_acid = AminoAcid.new(amino_acid_params)
        @amino_acid.make_icon params[:svg] if params[:svg].present?
        @amino_acid.status ||= 'approved'
        @amino_acid.approved_at = Time.now

        if @amino_acid.save
          redirect_to @amino_acid, notice: 'Atom abbreviation was successfully created.'
        else
          render :new
        end
      end
    end

    # PATCH/PUT /amino_acids/1
    def update
      @amino_acid.attributes = amino_acid_params
      @amino_acid.make_icon params[:svg] if params[:svg].present?
      if @amino_acid.save
        redirect_to @amino_acid,
                    notice: 'Atom abbreviation was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /amino_acids/1
    def destroy
      @amino_acid.destroy
      redirect_to amino_acids_url,
                  notice: 'Atom abbreviation was successfully destroyed.'
    end

private

    def check_user_permissions
      unless current_user && current_user.is_templates_moderator
        render :text => 'Unauthorized!', status: :unauthorized
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_amino_acid
      @amino_acid = AminoAcid.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def amino_acid_params
      params.require(:amino_acid).permit(:name, :rtl_name, :notes,
        :molfile, :status)
    end
  end
end
