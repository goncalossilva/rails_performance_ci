class Commit < ActiveRecord::Base
  belongs_to :application
  has_one :benchmark, :class_name => "Result::Benchmark"

  def checkout
    runner.run! "git clone #{application.uri} #{application.root}" unless Dir.exists?(application.root)

    runner.in_dir do
      runner.run! "git fetch origin"
      runner.run! "git checkout origin/#{application.branch}"
      runner.run! "git reset --hard #{sha1}"
      
      update_attributes(metadata)
    end
  end

  def metadata
    format = "---%nsha1: %H%nauthor: %an <%ae>%nmessage: >-%n  %s%ntime: %ci%n"
      
    result = runner.run_in_dir!("git show -s --pretty=format:\"#{format}\" #{sha1}")
    dump   = YAML.load(result.output)

    dump.update("time" => Time.parse(dump["time"]))
  end

  # TODO: this might be needed, else remove
  #def real_sha1
  #  @sha1 ||= sha1 == "HEAD" ? head : sha1
  #end
  #
  #def head
  #  runner.run!("git ls-remote --heads #{@repo.uri} #{@repo.branch}").
  #    output.split.first
  #end

  def runner
    @runner ||= CommandRunner.new(application.root, Rails.logger)
  end
end

