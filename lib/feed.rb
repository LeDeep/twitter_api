class Feed

  def initialize(access_token)
    access_token = '218233348-tW216zddcfAE5omuCK9vdjQZ4NGtgOIkekU0QvxQ'
  end 


  def view_feed
    access_token(:get, 'https://api.twitter.com/1.1/statuses/home_timeline.json')
  end

end