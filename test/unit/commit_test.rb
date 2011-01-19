# encoding: utf-8

require 'test_helper'

class CommitTest < ActiveSupport::TestCase
  def setup
    @c = commits(:sample_first_commit)
    @c.checkout
  end
  
  def teardown
    FileUtils.rm_rf(@c.application.root)
  end
  
  def test_should_create_repo_dir
    assert Dir.exists?(@c.application.root)
  end
  
  def test_should_import_repo_info
    assert_equal @c.sha1, "57f0a94fefc27d40c3d8f2b7950cab109640a434"
    assert_equal @c.message, "initial import"
    assert_equal @c.author, "Gonçalo Silva <goncalossilva@gmail.com>"
    assert_equal @c.time, Time.parse("2010-08-11 16:33:22 +0000")
  end
end

