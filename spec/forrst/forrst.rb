require File.expand_path('../../helper', __FILE__)

describe('Forrst') do

  it('Configure the client') do
    Forrst.configure do |client|
      client.access_token = '123'
      client.id           = 'id'
      client.secret       = 'secret'
    end

    Forrst.access_token.should === '123'
    Forrst.id.should           === 'id'
    Forrst.secret.should       === 'secret'
  end

end
