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

  context '#tweet' do 
    it 'allows a user to post tweets and send tweets to other members of twitter' do 
      init_stub
      access_stub
      user = User.new
      user.authorize!('5423432')
      update = 'this is a tweet'
      stub_request(:post, 'https://api.twitter.com/1.1/statuses/update.json').with(:body => {"status" => "this is a tweet"}).to_return(:body => "{\"user\":{\"id\":218233348,\"profile_sidebar_fill_color\":\"DDEEF6\",\"default_profile\":false,\"follow_request_sent\":false,\"following\":false,\"screen_name\":\"LeDeep7\",\"profile_image_url\":\"http:\\/\\/a0.twimg.com\\/profile_images\\/1452808466\\/image_normal.jpg\",\"verified\":false,\"profile_background_color\":\"C0DEED\",\"utc_offset\":-28800,\"created_at\":\"Sun Nov 21 19:57:34 +0000 2010\",\"listed_count\":0,\"name\":\"Deep Marreddy\",\"is_translator\":false,\"url\":null,\"profile_background_image_url\":\"http:\\/\\/a0.twimg.com\\/profile_background_images\\/173943987\\/ChicagoAtNight1.jpg\",\"protected\":false,\"profile_link_color\":\"0084B4\",\"entities\":{\"description\":{\"urls\":[]}},\"statuses_count\":116,\"notifications\":false,\"profile_use_background_image\":true,\"default_profile_image\":false,\"profile_background_image_url_https\":\"https:\\/\\/twimg0-a.akamaihd.net\\/profile_background_images\\/173943987\\/ChicagoAtNight1.jpg\",\"profile_text_color\":\"333333\",\"id_str\":\"218233348\",\"lang\":\"en\",\"favourites_count\":25,\"location\":\"NorCAL\",\"profile_image_url_https\":\"https:\\/\\/twimg0-a.akamaihd.net\\/profile_images\\/1452808466\\/image_normal.jpg\",\"followers_count\":26,\"contributors_enabled\":false,\"profile_sidebar_border_color\":\"C0DEED\",\"time_zone\":\"Pacific Time (US & Canada)\",\"friends_count\":76,\"geo_enabled\":false,\"description\":\"Under Construction...\",\"profile_background_tile\":false},\"retweeted\":false,\"retweet_count\":0,\"created_at\":\"Thu Mar 21 22:18:37 +0000 2013\",\"in_reply_to_status_id\":null,\"geo\":null,\"in_reply_to_screen_name\":null,\"in_reply_to_user_id\":null,\"in_reply_to_status_id_str\":null,\"favorited\":false,\"coordinates\":null,\"in_reply_to_user_id_str\":null,\"id_str\":\"314863646595510274\",\"entities\":{\"user_mentions\":[],\"urls\":[],\"hashtags\":[]},\"contributors\":null,\"truncated\":false,\"text\":\"this is a tweet\",\"place\":null,\"source\":\"\\u003Ca href=\\\"http:\\/\\/www.epicodus.com\\\" rel=\\\"nofollow\\\"\\u003Eepicodus7\\u003C\\/a\\u003E\",\"id\":314863646595510274}")
      user.tweet(update)
      user.tweet(update).should eq "@LeDeep7: this is a tweet"
    end
  end

  context '#followers' do
    it 'gives a list of everyone who is following you' do
      init_stub
      access_stub
      user = User.new
      user.authorize!('5423432')
        stub_request(:get, "https://api.twitter.com/1.1/followers/list.json").
         to_return(:body => "{\"users\":[{\"id\":4612661,\"id_str\":\"4612661\",\"name\":\"Arun Agrawal\",\"screen_name\":\"arunagw\",\"location\":\"Stockholm\",\"description\":\"Rails Core Contributor, Web Developer, Ruby, Ruby On Rails.\",\"url\":\"https:\\/\\/github.com\\/arunagw\",\"entities\":{\"url\":{\"urls\":[{\"url\":\"https:\\/\\/github.com\\/arunagw\",\"expanded_url\":null,\"indices\":[0,26]}]},\"description\":{\"urls\":[]}},\"protected\":false,\"followers_count\":1740,\"friends_count\":787,\"listed_count\":87,\"created_at\":\"Sat Apr 14 15:52:43 +0000 2007\",\"favourites_count\":35,\"utc_offset\":19800,\"time_zone\":\"New Delhi\",\"geo_enabled\":true,\"verified\":false,\"statuses_count\":6244,\"lang\":\"en\",\"status\":{\"created_at\":\"Thu Mar 21 21:21:16 +0000 2013\",\"id\":314849212665835520,\"id_str\":\"314849212665835520\",\"text\":\"Not be able to reset password of @Spotify !\",\"source\":\"\\u003ca href=\\\"http:\\/\\/tapbots.com\\/software\\/tweetbot\\/mac\\\" rel=\\\"nofollow\\\"\\u003eTweetbot for Mac\\u003c\\/a\\u003e\",\"truncated\":false,\"in_reply_to_status_id\":null,\"in_reply_to_status_id_str\":null,\"in_reply_to_user_id\":null,\"in_reply_to_user_id_str\":null,\"in_reply_to_screen_name\":null,\"geo\":null,\"coordinates\":null,\"place\":{\"id\":\"d1321d539a0a18ff\",\"url\":\"https:\\/\\/api.twitter.com\\/1.1\\/geo\\/id\\/d1321d539a0a18ff.json\",\"place_type\":\"city\",\"name\":\"Nacka\",\"full_name\":\"Nacka, Stockholm\",\"country_code\":\"SE\",\"country\":\"Sweden\",\"polylines\":[],\"bounding_box\":{\"type\":\"Polygon\",\"coordinates\":[[[18.106542,59.231369],[18.388745,59.231369],[18.388745,59.369374],[18.106542,59.369374]]]},\"attributes\":{}},\"contributors\":null,\"retweet_count\":0,\"favorite_count\":0,\"entities\":{\"hashtags\":[],\"urls\":[],\"user_mentions\":[{\"screen_name\":\"Spotify\",\"name\":\"Spotify\",\"id\":17230018,\"id_str\":\"17230018\",\"indices\":[33,41]}]},\"favorited\":false,\"retweeted\":false,\"lang\":\"en\"},\"contributors_enabled\":false,\"is_translator\":false,\"profile_background_color\":\"EDECE9\",\"profile_background_image_url\":\"http:\\/\\/a0.twimg.com\\/profile_background_images\\/667547488\\/8c441857532b3b7f189b59e2a1540376.jpeg\",\"profile_background_image_url_https\":\"https:\\/\\/si0.twimg.com\\/profile_background_images\\/667547488\\/8c441857532b3b7f189b59e2a1540376.jpeg\",\"profile_background_tile\":false,\"profile_image_url\":\"http:\\/\\/a0.twimg.com\\/profile_images\\/3384559391\\/b0ca2b36b1636f818fc4a95b24f07f85_normal.jpeg\",\"profile_image_url_https\":\"https:\\/\\/si0.twimg.com\\/profile_images\\/3384559391\\/b0ca2b36b1636f818fc4a95b24f07f85_normal.jpeg\",\"profile_banner_url\":\"https:\\/\\/si0.twimg.com\\/profile_banners\\/4612661\\/1353221771\",\"profile_link_color\":\"088253\",\"profile_sidebar_border_color\":\"FFFFFF\",\"profile_sidebar_fill_color\":\"E3E2DE\",\"profile_text_color\":\"634047\",\"profile_use_background_image\":true,\"default_profile\":false,\"default_profile_image\":false,\"following\":false,\"follow_request_sent\":false,\"notifications\":false}],\"next_cursor\":1430145937506376908,\"next_cursor_str\":\"1430145937506376908\",\"previous_cursor\":0,\"previous_cursor_str\":\"0\"}")      
      user.followers.should eq ["@arunagw"]
    end
  end

 context '#following' do
    it 'gives a list of everyone you are following' do
      init_stub
      access_stub
      user = User.new
      user.authorize!('5423432')
      stub_request(:get, 'https://api.twitter.com/1.1/friends/list.json').to_return(:body => "{\"users\":[{\"id\":4206131,\"id_str\":\"4206131\",\"name\":\"PeepCode\",\"screen_name\":\"peepcode\",\"location\":\"Seattle, USA\",\"description\":\"We research the latest in website programming so you don't have to! Achieve alpha-geek enlightenment with PeepCode.\",\"url\":\"http:\\/\\/peepcode.com\",\"entities\":{\"url\":{\"urls\":[{\"url\":\"http:\\/\\/peepcode.com\",\"expanded_url\":null,\"indices\":[0,19]}]},\"description\":{\"urls\":[]}},\"protected\":false,\"followers_count\":10062,\"friends_count\":835,\"listed_count\":596,\"created_at\":\"Wed Apr 11 16:32:33 +0000 2007\",\"favourites_count\":512,\"utc_offset\":-28800,\"time_zone\":\"Pacific Time (US & Canada)\",\"geo_enabled\":false,\"verified\":false,\"statuses_count\":1391,\"lang\":\"en\",\"status\":{\"created_at\":\"Thu Mar 21 21:58:42 +0000 2013\",\"id\":314858634284769280,\"id_str\":\"314858634284769280\",\"text\":\"@mkrisher On the way in April! Thanks!\",\"source\":\"\\u003ca href=\\\"http:\\/\\/twitter.com\\/download\\/iphone\\\" rel=\\\"nofollow\\\"\\u003eTwitter for iPhone\\u003c\\/a\\u003e\",\"truncated\":false,\"in_reply_to_status_id\":314858418798206977,\"in_reply_to_status_id_str\":\"314858418798206977\",\"in_reply_to_user_id\":7152,\"in_reply_to_user_id_str\":\"7152\",\"in_reply_to_screen_name\":\"mkrisher\",\"geo\":null,\"coordinates\":null,\"place\":null,\"contributors\":null,\"retweet_count\":0,\"favorite_count\":0,\"entities\":{\"hashtags\":[],\"urls\":[],\"user_mentions\":[{\"screen_name\":\"mkrisher\",\"name\":\"Michael Krisher\",\"id\":7152,\"id_str\":\"7152\",\"indices\":[0,9]}]},\"favorited\":false,\"retweeted\":false,\"lang\":\"en\"},\"contributors_enabled\":false,\"is_translator\":false,\"profile_background_color\":\"00C4DF\",\"profile_background_image_url\":\"http:\\/\\/a0.twimg.com\\/profile_background_images\\/692718339\\/d2aa0526d1ddc1534bdb076a76aaa287.gif\",\"profile_background_image_url_https\":\"https:\\/\\/si0.twimg.com\\/profile_background_images\\/692718339\\/d2aa0526d1ddc1534bdb076a76aaa287.gif\",\"profile_background_tile\":true,\"profile_image_url\":\"http:\\/\\/a0.twimg.com\\/profile_images\\/1973603871\\/facebook-timeline-ICON_normal.png\",\"profile_image_url_https\":\"https:\\/\\/si0.twimg.com\\/profile_images\\/1973603871\\/facebook-timeline-ICON_normal.png\",\"profile_link_color\":\"0095C3\",\"profile_sidebar_border_color\":\"000000\",\"profile_sidebar_fill_color\":\"EFEFEF\",\"profile_text_color\":\"333333\",\"profile_use_background_image\":true,\"default_profile\":false,\"default_profile_image\":false,\"following\":true,\"follow_request_sent\":false,\"notifications\":false}],\"next_cursor\":1428817083877334777,\"next_cursor_str\":\"1428817083877334777\",\"previous_cursor\":0,\"previous_cursor_str\":\"0\"}")
      user.following.should eq ["@peepcode"]
    end
  end
end