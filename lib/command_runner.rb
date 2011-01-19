class CommandRunner
  class Error < StandardError; end

  Result = Struct.new(:success, :output)

  def initialize(directory, logger)
    @directory = directory
    @logger = logger
  end

  def run(command)
    cmd = normalize(command)

    @logger.debug(cmd)

    output = ""
    IO.popen(cmd, "r") { |io| output = io.read }

    Result.new($?.success?, output.chomp)
  end

  def run!(command)
    result = run(command)

    unless result.success
      @logger.error(result.output.inspect)
      raise Error, "Failed to run '#{command}'"
    end

    result
  end
  
  def run_in_dir(command, &block)
    in_dir { run(command) }
  end

  def run_in_dir!(command, &block)
    in_dir { run!(command) }
  end
  
  def in_dir(&block)
    cd(@directory, &block)
  end
  
  private
  
  def cd(dir)
    @dir = dir
    yield
  ensure
    @dir = nil
  end
  
  def normalize(cmd)
    if @dir
      "(cd #{@dir} && #{cmd} 2>&1)"
    else
      "(#{cmd} 2>&1)"
    end
  end
end
