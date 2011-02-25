require "test_helper"

class ApplicationsControllerTest < ActionController::TestCase
  fixtures :applications
  
  def test_payload_should_be_parsed_correctly
    application   = Application.find_by_permalink("sample_rails3_app")
    commits_count = Commit.count
    
    assert_equal 1, application.commits.count
    
    payload =     
      {
        "before" => "",
        "repository" => {
          "url" => "http://github.com/goncalossilva/sample_rails3_app",
          "name" => "sample_rails3_app",
          "description" => "Sample Rails 3 application",
          "watchers" => 1,
          "forks" => 1,
          "private" => 0,
          "owner" => {
            "email" => "goncalossilva@gmail.com",
            "name" => "goncalossilva"
          }
        },
        "commits" => [
          {
            "id" => "f80be2f4f5cd87169b5dff6b5d0cc8da878e7127",
            "url" => "http://github.com/goncalossilva/sample_rails3_app/commit/f80be2f4f5cd87169b5dff6b5d0cc8da878e7127",
            "author" => {
              "email" => "goncalossilva@gmail.com",
              "name" => "goncalossilva"
            },
            "message" => "database.yml is not needed",
            "timestamp" => "2010-08-12T14:57:17-08:00"          
          },
          {
            "id" => "d6b9fb9cdfa4220e3b52134ec60ac4b1b2c21e6f",
            "url" => "http://github.com/goncalossilva/sample_rails3_app/commit/d6b9fb9cdfa4220e3b52134ec60ac4b1b2c21e6f",
            "author" => {
              "email" => "goncalossilva@gmail.com",
              "name" => "goncalossilva"
            },
            "message" => "updated readme",
            "timestamp" => "2010-08-11T17:56:17-08:00"          
          },
          {
            "id" => "57f0a94fefc27d40c3d8f2b7950cab109640a434",
            "url" => "http://github.com/goncalossilva/sample_rails3_app/commit/57f0a94fefc27d40c3d8f2b7950cab109640a434",
            "author" => {
              "email" => "goncalossilva@gmail.com",
              "name" => "goncalossilva"
            },
            "message" => "initial import",
            "timestamp" => "2010-08-11T14:57:17-08:00",
            "added" => [".gitignore", "Gemfile", "etc"]
          },
        ],
        "after" => "de8251ff97ee194a289832576287d6f8ad74e3d0",
        "ref" => "refs/heads/master"
    }
    
    post :github, :id => "sample_rails3_app", :token => "abcaabcaabcaabca", :payload => payload
    
    assert_equal 4, application.commits.count
    assert_equal commits_count+3, Commit.count
    
    payload["commits"].map do |commit_info|
      commit = Commit.find_by_sha1(commit_info["id"])
      
      assert_not_nil commit
      assert_equal commit_info["message"], commit.message
      assert_equal "#{commit_info["author"]["name"]} <#{commit_info["author"]["email"]}>", commit.author
      assert_equal Time.parse(commit_info["timestamp"]), commit.time
    end
  end
end
