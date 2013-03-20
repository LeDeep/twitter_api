
class User


  def initialize
    @consumer = OAuth::Consumer.new(CONSUMER_KEY, CONSUMER_SECRET, :site => "https://api.twitter.com/")
    @request_token = @consumer.get_request_token(:oauth_callback => CALLBACK_URL)
  end


  def authorize_url
    @request_token.authorize_url(:oauth_callback => CALLBACK_URL)
  end
  
 
  def authorize!(oauth_verifier)
    @access_token = @request_token.get_access_token(:oauth_verifier => oauth_verifier)
  end

  def settings
   JSON.parse(access_token.get('https://api.twitter.com/1.1/account/settings.json'))
  end





end

