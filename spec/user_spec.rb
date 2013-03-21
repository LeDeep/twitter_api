require 'spec_helper'
# let(:valid_stub) {stub_request (authorized_token)
 # user = User.new
 # User.authorize! ('5436547')
 

describe User do
  context '#initialize' do 
    it 'gets request token' do
      stub = stub_request(:post, "https://api.twitter.com/oauth/request_token").to_return(:body => "oauth_token=t&oauth_token_secret=s")
      user = User.new
      stub.should have_been_requested
    end
  end
 
  context '#authorize_url' do
    it 'returns URL where user can authorize access to their account' do 
      stub = stub_request(:post, "https://api.twitter.com/oauth/request_token").to_return(:body => "oauth_token=t&oauth_token_secret=s")
      user = User.new
      user.authorize_url.should eq "https://api.twitter.com/oauth/authorize?oauth_callback=oob&oauth_token=t"
    end
  end

  context '#authorize!' do
    it 'accepts the oauth verifier PIN as argument and then authorizes with twitter to get account' do 
      stub_request(:post, "https://api.twitter.com/oauth/request_token").to_return(:body => "oauth_token=t&oauth_token_secret=s")
      user = User.new
      stub = stub_request(:post, "https://api.twitter.com/oauth/access_token").to_return(:body => "oauth_token=at&oauth_token_secret=as&screen_name=sn")  
      user.authorize!('5423432')
      stub.should have_been_requested
    end
  end

  # context '#settings' do
  #   it 'returns the user\'s settings' do 
  #     stub_request(:post, "https://api.twitter.com/oauth/request_token").to_return(:body => "oauth_token=t&oauth_token_secret=s")
  #     user = User.new
  #     stub_request(:post, "https://api.twitter.com/oauth/access_token").to_return(:body => "oauth_token=at&oauth_token_secret=as&screen_name=sn")  
  #     user.authorize!('5423432')
  #     stub_request(:get, 'https://api.twitter.com/1.1/account/settings.json')#.to_return(:body => "{\"protected\":false,\"screen_name\":\"LeDeep7\",\"always_use_https\":true,\"language\":\"en\",\"trend_location\":[{\"url\":\"http:\\/\\/where.yahooapis.com\\/v1\\/place\\/1\",\"name\":\"Worldwide\",\"country\":\"\",\"placeType\":{\"name\":\"Supername\",\"code\":19},\"countryCode\":null,\"woeid\":1}],\"use_cookie_personalization\":true,\"sleep_time\":{\"start_time\":null,\"enabled\":false,\"end_time\":null},\"geo_enabled\":false,\"time_zone\":{\"tzinfo_name\":\"America\\/Los_Angeles\",\"name\":\"Pacific Time (US & Canada)\",\"utc_offset\":-28800},\"discoverable_by_email\":true}")
  #     user.settings.should eq ""
  #   end
  # end

end