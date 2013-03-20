require 'spec_helper'
# let(:valid_stub) {stub_request (authorized_token)
 # user = User.new
 # User.authorize! ('5436547')
 

describe User do
  context '#initialize' do 
    it 'gets request token' 
      User.new
    
    end
  end
 
  context '#authorize_url' do
    it 'returns URL where user can authorize access to their account'
  end

  context '#authorize!' do
    it 'accepts the oauth verifier PIN as argument and then authorizes with twitter to get account'
  end

  context '#settings' do
    it 'returns the user\'s settings'
  end
end