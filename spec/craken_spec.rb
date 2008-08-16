RAILS_ROOT = "foo/bar/baz"
RAILS_ENV = "test"

require File.dirname(__FILE__) + "/../lib/craken"

describe Craken do

  include Craken

  describe "load_and_strip" do
    it "should load the user's installed crontab"
    it "should strip out preinstalled raketab commands associated with the project"
    it "should not strip out preinstalled raketab commands not associated with the project"
  end

  describe "append_tasks" do
    it "should add comments to the beginning and end of the rake tasks it adds to crontab"
    it "should ignore comments in the raketab string"
    it "should not munge the crontab time configuration"
    it "should add a cd command"
    it "should add the rake command"
    it "should add the rails environment value"
    it "should ignore additional data at the end of the configuration"
  end

  describe "install" do
    it "should create a temporary file for crontab"
    it "should run crontab"
    it "should delete the temporary file"
  end

end
