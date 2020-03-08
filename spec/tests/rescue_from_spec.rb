class RescueParent
  include RescueFromError

  rescue_from :all do
    $rescue = :from_all
  end
end

class RescueTest < RescueParent
  rescue_from ArgumentError do
    $rescue = :from_argument
  end

  def foo
    raise ArgumentError.new('bad foo')
  end

  def bar
    raise StandardError.new('bad bar')
  end
end

###

describe 'rescue_from' do
  it 'captures argument error' do
    RescueTest.new.instance_eval do
      resolve_rescue_from do
        foo
      end
    end

    expect($rescue).to eq(:from_argument)
  end

  it 'captures standard error' do
    RescueTest.new.instance_eval do
      resolve_rescue_from do
        bar
      end
    end

    expect($rescue).to eq(:from_all)
  end
end