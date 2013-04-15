require_relative '../libraries/redisio.rb'
require 'chef'

class RedisioHelpers
end

describe "Check the Config Suffix" do

  before(:each) do
    @redis = RedisioHelpers.new
    @redis.extend(Redisio::Helper)
  end

  context "has a byte suffix" do
    it "should have a convertable suffix" do
      ['100kb', '100mb', '100gb'].each do |suffix|
        @redis.has_convertable_suffix?(suffix).should be_true
      end
    end
  end

  context "has a metric suffix" do
    it "should have a convertable suffix" do
      ['100k', '100m', '100g'].each do |suffix|
        @redis.has_convertable_suffix?(suffix).should be_true
      end
    end
  end

  context "has a garbage suffix" do
    it "should not have a convertable suffix" do
      ['qwerty'].each do |suffix|
        @redis.has_convertable_suffix?(suffix).should be_false
      end
    end
  end

  context "is a number" do
    it "should not have a convertable suffix" do
      [1, 23, 345].each do |suffix|
        @redis.has_convertable_suffix?(suffix).should be_false
      end
    end
  end

end

describe "Convert the Config Suffix" do

  before(:each) do
    @redis = RedisioHelpers.new
    @redis.extend(Redisio::Helper)
  end

  context "is convertable" do
    it "should not return the same value" do
      ['100gb', '100mb', '100kb'].each do |suffix|
        @redis.convert_suffix(suffix).should_not == suffix
      end
    end
  end

  # Byte Suffix
  context "has kb suffix" do
    it "should return 1024*" do
        @redis.convert_suffix("100kb").should == (100 * 1024).to_s
    end
  end

  context "has mb suffix" do
    it "should return 1024**" do
        @redis.convert_suffix("100mb").should == (100 * 1024 * 1024).to_s
    end
  end

  context "has gb suffix" do
    it "should return 1024***" do
        @redis.convert_suffix("100gb").should == (100 * 1024 * 1024 * 1024).to_s
    end
  end

  # Metric Suffix
  context "has k suffix" do
    it "should return 1000*" do
        @redis.convert_suffix("100k").should == (100 * 1000).to_s
    end
  end

  context "has m suffix" do
    it "should return 1000**" do
        @redis.convert_suffix("100m").should == (100 * 1000 * 1000).to_s
    end
  end

  context "has g suffix" do
    it "should return 1000***" do
        @redis.convert_suffix("100g").should == (100 * 1000 * 1000 * 1000).to_s
    end
  end
end


describe "Check that Redis Server exists" do

  before(:each) do
    @redis = RedisioHelpers.new
    @redis.extend(Redisio::Helper)
    Mixlib::ShellOut.any_instance.stub(:run_command)
  end

  context "and is installed" do
    it "should have redis existing" do
      Mixlib::ShellOut.any_instance.stub(:exitstatus).and_return(0)
      @redis.redis_exists?().should be_true
    end
  end

end