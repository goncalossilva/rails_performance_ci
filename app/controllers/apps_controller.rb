class AppsController < ApplicationController
  # GET /apps
  # GET /apps.xml
  def index
    @apps = App.includes(:perf_benchmarks).all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @apps }
    end
  end

  # GET /apps/1
  # GET /apps/1.xml
  def show
    @app = App.includes(:perf_benchmarks).find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @app }
    end
  end

  # GET /apps/new
  # GET /apps/new.xml
  def new
    @app = App.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @app }
    end
  end

  # GET /apps/1/edit
  def edit
    @app = App.find(params[:id])
  end

  # POST /apps
  # POST /apps.xml
  def create
    @app = App.new(params[:app])

    respond_to do |format|
      if @app.save
        format.html { redirect_to(@app, :notice => 'App was successfully created.') }
        format.xml  { render :xml => @app, :status => :created, :location => @app }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @app.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /apps/1
  # PUT /apps/1.xml
  def update
    @app = App.find(params[:id])

    respond_to do |format|
      if @app.update_attributes(params[:app])
        format.html { redirect_to(@app, :notice => 'App was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @app.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /apps/1
  # DELETE /apps/1.xml
  def destroy
    @app = App.find(params[:id])
    @app.destroy

    respond_to do |format|
      format.html { redirect_to(apps_url) }
      format.xml  { head :ok }
    end
  end
  
  def compare
    @app = App.find(params[:id])
    prev_commit = params[:commit1]
    curr_commit = params[:commit2]
    
    @prev_benchmark = @app.perf_benchmarks.where(:commit => prev_commit).first
    @curr_benchmark = @app.perf_benchmarks.where(:commit => curr_commit).first
    
    if @prev_benchmark and @curr_benchmark
      @differences = PerfDifference.includes(
        :prev_method => {:perf_thread => {:perf_test => {:perf_benchmark => :app}}}, 
        :curr_method => {:perf_thread => {:perf_test => {:perf_benchmark => :app}}}
      ).find_all_by_prev_commit_and_curr_commit(prev_commit, curr_commit)
      
      if @differences.empty?
        Process.fork do
          @curr_benchmark.differences(@prev_benchmark)
        end
      end
    else
      flash[:notice] = "Both commits need to be valid."
    end
  end
end
