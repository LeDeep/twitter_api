

class User

  def initialize
    @consumer = OAuth::Consumer.new(CONSUMER_KEY, CONSUMER_SECRET, :site => "https://api.twitter.com")
    @request_token = @consumer.get_request_token(:oauth_callback => CALLBACK_URL)
  end


  def authorize_url
    @request_token.authorize_url(:oauth_callback => CALLBACK_URL)
  end
  
 
  def authorize!(oauth_verifier)
    @access_token = @request_token.get_access_token(:oauth_verifier => oauth_verifier)
  end


  def settings
    response = @access_token.get('https://api.twitter.com/1.1/account/settings.json')
    JSON.parse(response.body)

  end


  def view_feed
    timeline = @access_token.get('https://api.twitter.com/1.1/statuses/home_timeline.json')
    responses = JSON.parse(timeline.body)
    responses.map {|response| "@" + response['user']['screen_name'] + ": " + response['text']}
  end

  def tweet(update)
    post = @access_token.post('https://api.twitter.com/1.1/statuses/update.json', {:status => "#{update}"})
    message = JSON.parse(post.body)
    "@" + message['user']['screen_name'] + ": " + message['text']

  end

  def followers
    people = @access_token.get('https://api.twitter.com/1.1/followers/list.json')
    humans = JSON.parse(people.body)
    friends = humans['users']
    friends.map {|friend| "@" + friend['screen_name']} 
     
  end

  def following
    people = @access_token.get('https://api.twitter.com/1.1/friends/list.json')
    follows = JSON.parse(people.body)
    follows_users = follows["users"]
    follows_users.map {|follow_user| "@" + follow_user["screen_name"]}
  end

  def trending
    trends = @access_token.get("https://api.twitter.com/1.1/trends/place.json?id=1")
    trends_parse = JSON.parse(trends.body)
    hash_object = Hash[*trends_parse.flatten]
    subjects = hash_object["trends"]
    subjects.map {|subject| subject["name"]}
  end


end

