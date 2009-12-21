require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

$pop = PlainOptionParser.new do
  desc "set abc"
  cmd "test set abc" do |value|
    $abc = value
    $abc += flags["app"] if flags["app"]
  end
  
  desc "unset abc"
  cmd "test unset abc" do |client|
    $abc = false
  end
end

describe "PlainOptionParser" do
  it "should set abc" do
    $pop.start %w[test set abc 123]
    $abc.should == "123"
  end
  
  it "should unset abc" do
    $pop.start %w[test unset abc]
    $abc.should be_false
  end
  
  it "should take a flag" do
    $pop.start %w[test set abc 123 --app foo]
    $abc.should == "123foo"
  end
end
