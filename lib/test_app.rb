# This is the test application itself, living in vendor/apps/
# All operations regarding this application (cloning from the repository,
# preparing the database, generating data, running tests, etc) are done
# in this class
class TestApp
  def initialize(path, repository)
    @path = path
    @dir = path.match(/(.*)\/\S*$/)[1]
    @repository = repository
  end
  
  # Check if the application is already in vendor/apps and create/update it
  # accordigly. If it's already there update Rails, otherwise install all the 
  # needed gems and create dummy-related information (data, routes, tests).
  def setup
    File.makedirs(@dir)
    exists = File.exists?("#{@path}/.git")
    
    if exists
      dir = @path
      cmd = "pull origin master"
    else
      dir = @dir
      cmd = "clone #{@repository}"
    end
    
    Dir.chdir(dir) { system("git #{cmd}") }
    update_gemfile
    
    if exists
      update_rails
    else
      install_gems
      setup_db
      setup_dummy
    end
  end
  
  def run_tests
    Dir.chdir(@path) { system("RAILS_ENV=test rake dummy:performance:test:all") }
  end
  
  def read_results
    results = Hash.new
    
    Dir["#{@path}/test/dummy/results/*.yml"].each do |file|
      name = file.chomp(File.extname(file))
    
      results.merge!({name => YAML.load_file(file)})
    end
    
    results
  end
  
  private
  
  # Remove everything related with rails, ruby-prof and dummy.
  # Re-add them afterwards with the necessary modifications for performance ci:
  # - rails comes from the git repository
  # - ruby-prof is wycats'
  # - all dummy generators are needed
  def update_gemfile
    gemfile = "#{@path}/Gemfile"
    
    content = File.read(gemfile)
    
    # Remove all references to these gems, we'll add them properly latter on
    %w(rails ruby-prof dummy_data dummy_routes dummy_performance_tests).each do |gem|
      content.gsub!(/^\s*gem ['"]#{gem}['"].*;?\n?/, '')
    end
    
    new_gemfile = File.open(gemfile, "w")
    new_gemfile.write(content)
    
    new_gemfile.write("# These gems are specific for the performance ci of Rails\n")
    new_gemfile.write("gem 'rails', :git => 'git://github.com/rails/rails.git'\n")
    new_gemfile.write("gem 'ruby-prof', :git => 'git://github.com/wycats/ruby-prof.git'\n")
    new_gemfile.write("gem 'test-unit'\n") if RUBY_VERSION >= "1.9"
    %w(sqlite3-ruby dummy_data dummy_routes dummy_performance_tests).each do |gem|
      new_gemfile.write("gem '#{gem}'\n")
    end
    
    new_gemfile.close
  end
  
  def install_gems
    Dir.chdir(@path) { system("bundle install") }
  end
  
  def setup_db
    db_yml = File.open("#{@path}/config/database.yml", "w")
    db_yml.write(YAML.dump({
    "development"=>{"adapter"=>"sqlite3", "database"=>"db/development.sqlite3", "pool"=>5, "timeout"=>5000}, 
    "test"=>{"adapter"=>"sqlite3", "database"=>"db/test.sqlite3", "pool"=>5, "timeout"=>5000}
    }))
    db_yml.close
    
    Dir.chdir(@path) { system("rake db:migrate && rake db:test:load") }
  end
  
  def update_rails
    Dir.chdir(@path) { system("bundle update rails") }
  end
  
  def setup_dummy
    cmd = ["rails generate dummy:data", 
    "rails generate dummy:routes", 
    "rails generate dummy:performance_tests",
    "rake dummy:data:import"]
    
    Dir.chdir(@path) { system("#{cmd[0]} && #{cmd[1]} && #{cmd[2]} && #{cmd[3]}") }
  end
end
