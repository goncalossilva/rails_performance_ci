class PerfTestsController < ApplicationController
  
  before_filter :get_app, :get_perf_benchmark
  
  # GET /perf_tests/1
  # GET /perf_tests/1.xml
  def show
    @perf_test = @perf_benchmark.perf_tests.includes(:perf_threads).find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @perf_test }
    end
  end
  
  def get_app
    @app = App.includes(:perf_benchmarks).find(params[:app_id])
  end
  
  def get_perf_benchmark
    @perf_benchmark = @app.perf_benchmarks.find(params[:perf_benchmark_id])
  end
end
