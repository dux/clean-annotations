require 'spec_helper'

###

class A
  attr_reader :var

  class_callback :before
  class_callback :after
end

class B < A
  before do
    @var = :foo
  end
end

class C < B
  before do
    @var = :bar
  end

  after do |num|
    @var = num * 2
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
      expect(a.var).to be_nil

      b = B.new
      b.class_callback :before
      expect(b.var).to eq :foo

      c = C.new
      c.class_callback :before
      expect(c.var).to eq :bar

      d = De.new
      d.class_callback :before
      expect(d.var).to eq :bar
    end

    it 'can pass parameters' do
      d = De.new
      d.class_callback :after, 3
      expect(d.var).to eq 6
    end
  end
end

