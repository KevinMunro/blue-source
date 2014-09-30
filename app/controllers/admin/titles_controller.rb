module Admin
  class TitlesController < ApplicationController
    before_action :require_login
    before_action :must_be_system_admin, except: %i(sub_departments employees)
    before_action :set_title, only: %i(show edit update destroy)

    # GET /titles
    # GET /titles.json
    def index
      @titles = Title.order(name: :asc)
    end

    # GET /titles/1.json
    def show
    end

    # GET /titles/new
    def new
      @title = Title.new
    end

    # GET /titles/1/edit
    def edit
    end

    # POST /titles
    # POST /titles.json
    def create
      @title = Title.new(title_params)

      respond_to do |format|
        if @title.save
          format.html { redirect_to admin_titles_path, flash: { success: t(:create_success, resource: resource_name) } }
          format.json { render action: 'show', status: :created, location: @title }
        else
          format.html { render action: 'new' }
          format.json { render json: admin_title_path(@title).errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /titles/1
    # PATCH/PUT /titles/1.json
    def update
      respond_to do |format|
        if @title.update(title_params)
          format.html { redirect_to admin_titles_path(@title), flash: { success: t(:update_success, resource: resource_name) } }
          format.json { head :no_content }
        else
          format.html { render action: 'edit' }
          format.json { render json: admin_title_path(@title).errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /titles/1
    # DELETE /titles/1.json
    def destroy
      @title.destroy
      respond_to do |format|
        format.html { redirect_to admin_titles_url, flash: { success: t(:delete_success, resource: resource_name) } }
        format.json { head :no_content }
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_title
      @title = Title.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_titles_url, flash: { error: t(:resource_not_found, resource: resource_name) }
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def title_params
      params.require(:title).permit(:name)
    end

    def resource_name
      'Title'
    end
  end
end
