class Application < ActiveRecord::Base
  has_many :commits
  
  validates_format_of :permalink, :with => /\A[a-z0-9\-_]+\Z/
  
  def parse_payload(payload)
    payload_branch = payload["ref"].split("refs/heads/").last
    
    if payload_branch == branch
      payload_commits = payload["commits"].map { |commit|
        commits << Commit.create(        
          {:sha1 => commit["id"],
          :author => "#{commit["author"]["name"]} <#{commit["author"]["email"]}>",
          :message => commit["message"],
          :time => commit["timestamp"]}
        )
      }
    end
    
    commits << payload_commits
  end
  
  def root
    "#{self.class.root}/#{permalink}"
  end
  
  def self.root
    Rails.root + "vendor/apps"
  end
  
  def to_param
    permalink
  end
  
  private
  
  def generate_permalink(string)
    result = string.encode Encoding::ASCII, :undef => :replace, :replace => ""    
    result.gsub!(/[^\w_ \-]+/i, "")  # Remove unwanted chars.    
    result.gsub!(/[ \-]+/i,     "-") # No more than one of the separator in a row.    
    result.gsub!(/^\-|\-$/i,    "")  # Remove leading/trailing separator
    result.downcase
  end
end
