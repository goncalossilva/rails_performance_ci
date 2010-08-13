# This is the scheduling of the tests
# All operations regarding the necessary cron jobs and the interation with
# 'whenever' is done here
class Cron
  def initialize(name, frequency)
    @name = name
    @frequency = frequency
    
    update_schedule
    update_whenever
  end
  
  private
  
  def update_schedule
    template = ERB.new <<-EOC
set :output, File.expand_path("../log/cronjobs.log", __FILE__)
job_type :runner,  'cd :path && rails runner -e :environment ":task"'
<% App.all.each do |app| %>
every <%= @frequency %> do
  runner 'App.where(:name => "<%= @name %>").run_performance_benchmark'
end
<% end %>
    EOC
    
    File.open("#{Rails.root}/config/schedule.rb", 'w') { |f| f.write(template.result(binding)) }
  end
  
  # Set up the schedule, change whenever's configuration, trigger it
  def update_whenever    
    begin
      ::Whenever::CommandLine.execute({:update => true, :file => "#{Rails.root}/config/schedule.rb"})
    rescue SystemExit # whenever quits after updating cron jobs, we need to stop him
    end
  end
end
