require 'spec_helper'

describe User do

   let(:init_stub) {stub_request(:post, "https://api.twitter.com/oauth/request_token").
    to_return(:body => "oauth_token=t&oauth_token_secret=s")}
   
  let(:access_stub) {stub_request(:post, "https://api.twitter.com/oauth/access_token").
    to_return(:body => "oauth_token=at&oauth_token_secret=as&screen_name=sn")}


  let(:settings_stub)   {stub_request(:get, 'https://api.twitter.com/1.1/account/settings.json').
                      to_return(:body => "{\"protected\":false,\"screen_name\":\"LeDeep7\",\"always_use_https\":true,\"language\":\"en\",\"trend_location\":[{\"url\":\"http:\\/\\/where.yahooapis.com\\/v1\\/place\\/1\",\"name\":\"Worldwide\",\"country\":\"\",\"placeType\":{\"name\":\"Supername\",\"code\":19},\"countryCode\":null,\"woeid\":1}],\"use_cookie_personalization\":true,\"sleep_time\":{\"start_time\":null,\"enabled\":false,\"end_time\":null},\"geo_enabled\":false,\"time_zone\":{\"tzinfo_name\":\"America\\/Los_Angeles\",\"name\":\"Pacific Time (US & Canada)\",\"utc_offset\":-28800},\"discoverable_by_email\":true}")}

  context '#initialize' do 
    it 'gets request token' do
      init_stub
      user = User.new
      init_stub.should have_been_requested
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
      init_stub      
      access_stub
      user = User.new
      user.authorize!('5423432')
      access_stub.should have_been_requested
    end
  end

  context '#settings' do
    it 'returns the user\'s settings' do 
      init_stub      
      user = User.new
      access_stub      
      user.authorize!('5423432')
      settings_stub
      user.settings.should eq({"protected" => false,
                               "screen_name" => "LeDeep7", 
                               "always_use_https" => true, 
                               "language" => "en", 
                               "trend_location" => [{"url" => "http://where.yahooapis.com/v1/place/1",
                                                   "name" => "Worldwide",
                                                   "country" => "", 
                                                   "placeType" => {"name"=>"Supername", "code" => 19}, 
                                                   "countryCode" => nil, "woeid" => 1}],
                               "use_cookie_personalization" => true,
                               "sleep_time" => {"start_time" => nil, "enabled" => false, "end_time" => nil}, 
                               "geo_enabled" => false,
                               "time_zone" => {"tzinfo_name" => "America/Los_Angeles", "name" => "Pacific Time (US & Canada)", "utc_offset" => -28800}, 
                               "discoverable_by_email" => true})
    end
  end

  context '#view_feed' do 
    it 'shows the users twitter feed, consisting of recent tweets by user and people who user follows' do 
      init_stub
      access_stub
      user = User.new
      user.authorize!('5423432')
      stub_request(:get, 'https://api.twitter.com/1.1/statuses/home_timeline.json'). 
                     to_return(:body => "[{\"created_at\":\"Thu Mar 21 17:48:45 +0000 2013\",\"id\":314795732509011968,\"id_str\":\"314795732509011968\",\"text\":\"Don't panic... #MarchMadness is not causing deja vu. @jemelehill joined Michael &amp; Hugh on First Take, and is BACK on ESPNews for NNL at 2pm!\",\"source\":\"web\",\"truncated\":false,\"in_reply_to_status_id\":null,\"in_reply_to_status_id_str\":null,\"in_reply_to_user_id\":null,\"in_reply_to_user_id_str\":null,\"in_reply_to_screen_name\":null,\"user\":{\"id\":362189733,\"id_str\":\"362189733\",\"name\":\"Numbers Never Lie\",\"screen_name\":\"ESPN_Numbers\",\"location\":\"\",\"description\":\"NNL is on ESPN2 at 2PM Monday-Friday.\",\"url\":null,\"entities\":{\"description\":{\"urls\":[]}},\"protected\":false,\"followers_count\":166264,\"friends_count\":165,\"listed_count\":1173,\"created_at\":\"Fri Aug 26 00:27:56 +0000 2011\",\"favourites_count\":10,\"utc_offset\":-18000,\"time_zone\":\"Quito\",\"geo_enabled\":false,\"verified\":false,\"statuses_count\":2622,\"lang\":\"en\",\"contributors_enabled\":false,\"is_translator\":false,\"profile_background_color\":\"C0DEED\",\"profile_background_image_url\":\"http:\\/\\/a0.twimg.com\\/profile_background_images\\/674909334\\/2f87c261be3f728a0ad5442d6cd44ef9.jpeg\",\"profile_background_image_url_https\":\"https:\\/\\/si0.twimg.com\\/profile_background_images\\/674909334\\/2f87c261be3f728a0ad5442d6cd44ef9.jpeg\",\"profile_background_tile\":true,\"profile_image_url\":\"http:\\/\\/a0.twimg.com\\/profile_images\\/2673487012\\/2f87c261be3f728a0ad5442d6cd44ef9_normal.jpeg\",\"profile_image_url_https\":\"https:\\/\\/si0.twimg.com\\/profile_images\\/2673487012\\/2f87c261be3f728a0ad5442d6cd44ef9_normal.jpeg\",\"profile_banner_url\":\"https:\\/\\/si0.twimg.com\\/profile_banners\\/362189733\\/1360622610\",\"profile_link_color\":\"0084B4\",\"profile_sidebar_border_color\":\"FFFFFF\",\"profile_sidebar_fill_color\":\"DDEEF6\",\"profile_text_color\":\"333333\",\"profile_use_background_image\":true,\"default_profile\":false,\"default_profile_image\":false,\"following\":true,\"follow_request_sent\":null,\"notifications\":null},\"geo\":null,\"coordinates\":null,\"place\":null,\"contributors\":null,\"retweet_count\":1,\"favorite_count\":0,\"entities\":{\"hashtags\":[{\"text\":\"MarchMadness\",\"indices\":[15,28]}],\"urls\":[],\"user_mentions\":[{\"screen_name\":\"jemelehill\",\"name\":\"Jemele Hill\",\"id\":35586563,\"id_str\":\"35586563\",\"indices\":[53,64]}]},\"favorited\":false,\"retweeted\":false,\"lang\":\"en\"},{\"created_at\":\"Thu Mar 21 17:48:08 +0000 2013\",\"id\":314795576824840193,\"id_str\":\"314795576824840193\",\"text\":\"Howard Bryant is a must listen on my podcast. Great stuff, I promise http:\\/\\/t.co\\/0PgWZ1qjyx\",\"source\":\"web\",\"truncated\":false,\"in_reply_to_status_id\":null,\"in_reply_to_status_id_str\":null,\"in_reply_to_user_id\":null,\"in_reply_to_user_id_str\":null,\"in_reply_to_screen_name\":null,\"user\":{\"id\":40891771,\"id_str\":\"40891771\",\"name\":\"Jason Whitlock\",\"screen_name\":\"WhitlockJason\",\"location\":\"Los Angeles\",\"description\":\"Columns @FOXSports.com Podcast @FOXSportsradio.com. The Wire explains my life perspective. Sarcasm-challenged should avoid my timeline.\",\"url\":\"http:\\/\\/t.co\\/8ovfPVjVWw\",\"entities\":{\"url\":{\"urls\":[{\"url\":\"http:\\/\\/t.co\\/8ovfPVjVWw\",\"expanded_url\":\"http:\\/\\/msn.foxsports.com\\/writer\\/Jason_Whitlock\",\"display_url\":\"msn.foxsports.com\\/writer\\/Jason_W\\u2026\",\"indices\":[0,22]}]},\"description\":{\"urls\":[]}},\"protected\":false,\"followers_count\":164238,\"friends_count\":172,\"listed_count\":5266,\"created_at\":\"Mon May 18 15:11:46 +0000 2009\",\"favourites_count\":17,\"utc_offset\":-25200,\"time_zone\":\"Mountain Time (US & Canada)\",\"geo_enabled\":false,\"verified\":true,\"statuses_count\":19887,\"lang\":\"en\",\"contributors_enabled\":false,\"is_translator\":false,\"profile_background_color\":\"022330\",\"profile_background_image_url\":\"http:\\/\\/a0.twimg.com\\/profile_background_images\\/115975316\\/twitter_background3.jpg\",\"profile_background_image_url_https\":\"https:\\/\\/si0.twimg.com\\/profile_background_images\\/115975316\\/twitter_background3.jpg\",\"profile_background_tile\":false,\"profile_image_url\":\"http:\\/\\/a0.twimg.com\\/profile_images\\/3401150359\\/fc98d4d9680d05bd223bf945cabf36bf_normal.jpeg\",\"profile_image_url_https\":\"https:\\/\\/si0.twimg.com\\/profile_images\\/3401150359\\/fc98d4d9680d05bd223bf945cabf36bf_normal.jpeg\",\"profile_banner_url\":\"https:\\/\\/si0.twimg.com\\/profile_banners\\/40891771\\/1353770520\",\"profile_link_color\":\"0084B4\",\"profile_sidebar_border_color\":\"A8C7F7\",\"profile_sidebar_fill_color\":\"C0DFEC\",\"profile_text_color\":\"333333\",\"profile_use_background_image\":true,\"default_profile\":false,\"default_profile_image\":false,\"following\":true,\"follow_request_sent\":null,\"notifications\":null},\"geo\":null,\"coordinates\":null,\"place\":null,\"contributors\":null,\"retweet_count\":0,\"favorite_count\":3,\"entities\":{\"hashtags\":[],\"urls\":[{\"url\":\"http:\\/\\/t.co\\/0PgWZ1qjyx\",\"expanded_url\":\"http:\\/\\/www.foxsportsradio.com\\/cc-common\\/podcast\\/single_page.html?podcast=jasonwhitlock_podcast\",\"display_url\":\"foxsportsradio.com\\/cc-common\\/podc\\u2026\",\"indices\":[69,91]}],\"user_mentions\":[]},\"favorited\":false,\"retweeted\":false,\"possibly_sensitive\":false,\"lang\":\"en\"}]")
      user.view_feed.should eq ["@ESPN_Numbers: Don't panic... #MarchMadness is not causing deja vu. @jemelehill joined Michael &amp; Hugh on First Take, and is BACK on ESPNews for NNL at 2pm!", "@WhitlockJason: Howard Bryant is a must listen on my podcast. Great stuff, I promise http://t.co/0PgWZ1qjyx"]
    end
  end



end