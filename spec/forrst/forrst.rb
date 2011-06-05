require File.expand_path('../../helper', __FILE__)

describe('Forrst') do

  it('Retrieve a set of statistics') do
    stats = Forrst.statistics

    stats[:calls].should === 2
    stats[:limit].should === 10000
  end

end
