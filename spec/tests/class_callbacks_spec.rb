require 'spec_helper'

###

class A
  attr_reader :var1
  attr_reader :var2

  class_callback :before
  class_callback :after
end

class B < A
  before do
    @var1 = [:foo]
  end
end

class C < B
  before do
    @var1.push :bar
  end

  after do |num|
    @var2 = num * 2
  end
end

class De < C

end

###

describe 'Class callbacks' do
  context 'is passing when' do
    it 'callback is executing in good order' do
      a = A.new
      a.class_callback :before
      expect(a.var1).to eq nil

      b = B.new
      b.class_callback :before
      expect(b.var1).to eq [:foo]

      c = C.new
      c.class_callback :before
      expect(c.var1).to eq [:foo, :bar]

      d = De.new
      d.class_callback :before
      expect(d.var1).to eq [:foo, :bar]
    end

    it 'can pass parameters' do
      d = De.new
      d.class_callback :after, 3
      expect(d.var2).to eq 6
    end
  end
end

