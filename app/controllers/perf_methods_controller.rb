class PerfMethodsController < ApplicationController

  before_filter :get_app, :get_perf_benchmark, :get_perf_test, :get_perf_thread

  # GET /perf_methods/1
  # GET /perf_methods/1.xml
  def show
    @perf_method = @perf_thread.perf_methods.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @perf_method }
    end
  end
  
  def get_app
    @app = App.includes(:perf_benchmarks).find(params[:app_id])
  end
  
  def get_perf_benchmark
    @perf_benchmark = @app.perf_benchmarks.includes(:perf_tests).find(params[:perf_benchmark_id])
  end
  
  def get_perf_test
    @perf_test = @perf_benchmark.perf_tests.find(params[:perf_test_id])
  end
  
  def get_perf_thread
    @perf_thread = @perf_test.perf_threads.find(params[:perf_thread_id])
  end
end
