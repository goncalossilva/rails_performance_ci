class PerfBenchmarksController < ApplicationController
  before_filter :get_app
  
  # GET /perf_benchmarks
  # GET /perf_benchmarks.xml
  def index
    @perf_benchmarks = @app.perf_benchmarks.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @perf_benchmarks }
    end
  end

  # GET /perf_benchmarks/1
  # GET /perf_benchmarks/1.xml
  def show
    @perf_benchmark = @app.perf_benchmarks.includes(:perf_tests).find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @perf_benchmark }
    end
  end

  # DELETE /perf_benchmarks/1
  # DELETE /perf_benchmarks/1.xml
  def destroy
    @perf_benchmark = @app.perf_benchmarks.find(params[:id])
    @perf_benchmark.destroy

    respond_to do |format|
      format.html { redirect_to(app_perf_benchmarks_url) }
      format.xml  { head :ok }
    end
  end
  
  def get_app
    @app = App.find(params[:app_id])
  end
end
