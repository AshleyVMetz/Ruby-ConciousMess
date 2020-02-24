class RipplesController < ApplicationController
  PAGE_SIZE = 10
  protect_from_forgery
  before_action :set_ripple, only: [ :show, :edit, :update, :destroy]

  # GET /ripples
  # GET /ripples.json
  def index
    page_param = params.fetch( :page, nil)
    oldest_page_num = (Ripple.all.size.to_f / PAGE_SIZE).ceil - 1
    curr_page_num = session[ :curr_page_num ] || 0
    page_num = nil
    
    if page_param == "newest"
       page_num = 0
    elsif page_param == "prev"
       page_num = [curr_page_num - 1, 0].max
    elsif page_param == "next"
       page_num = [curr_page_num + 1, oldest_page_num].min
    elsif page_param == "oldest"
       page_num = oldest_page_num
    else 
       page_num = curr_page_num
    end

    session[ :curr_page_num] = page_num
    @ripples = Ripple.order(created_at: :desc).offset(PAGE_SIZE * page_num).limit(PAGE_SIZE)
   end


  # GET /ripples/1
  # GET /ripples/1.json
  def show
  end

  # GET /ripples/new
  def new
    @ripple = Ripple.new
  end

  # GET /ripples/1/edit
  def edit
  end

  # POST /ripples
  # POST /ripples.json
  def create
    @ripple = Ripple.new(ripple_params)

    respond_to do |format|
      if @ripple.save
        format.html { redirect_to :ripples, notice: 'Ripple was successfully created.' }
        format.json { render :show, status: :created, location: @ripple }
      else
        format.html { render :new }
        format.json { render json: @ripple.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ripples/1
  # PATCH/PUT /ripples/1.json
  def update
    respond_to do |format|
      if @ripple.update(ripple_params)
        format.html { redirect_to @ripple, notice: 'Ripple was successfully updated.' }
        format.json { render :show, status: :ok, location: @ripple }
      else
        format.html { render :edit }
        format.json { render json: @ripple.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ripples/1
  # DELETE /ripples/1.json
  def destroy
    @ripple.destroy
    respond_to do |format|
      format.html { redirect_to ripples_url, notice: 'Ripple was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ripple
      @ripple = Ripple.find(params[ :id ])
    end

    # Only allow a list of trusted parameters through.
    def ripple_params
      params.require(:ripple).permit( :name, :website, :message)
    end
end
