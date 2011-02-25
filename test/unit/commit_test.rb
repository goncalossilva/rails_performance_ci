# encoding: utf-8

require 'test_helper'

class CommitTest < ActiveSupport::TestCase
  fixtures :applications, :commits
  
  def setup
    @c = Commit.find_by_sha1("57f0a94fefc27d40c3d8")
    @c.checkout    
  end
  
  def teardown
    FileUtils.rm_rf(@c.application.root)
  end
  
  def test_should_create_repo_dir
    assert Dir.exists?(@c.application.root)
  end
  
  def test_should_import_repo_info
    assert_equal "57f0a94fefc27d40c3d8f2b7950cab109640a434", @c.sha1
    assert_equal "initial import", @c.message
    assert_equal "Gonçalo Silva <goncalossilva@gmail.com>", @c.author
    assert_equal Time.parse("2010-08-11 16:33:22 +0000"), @c.time
  end
end

