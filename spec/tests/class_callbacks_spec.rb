require 'spec_helper'

###

class CcA
  attr_reader :var1
  attr_reader :var2

  define_callback :before
  define_callback :after
end

class CcB < CcA
  before do
    @var1 = [:foo]
  end
end

class CcC < CcB
  before do
    @var1.push :bar
  end

  after do |num|
    @var2 = num * 2
  end
end

class CcD < CcC

end

module CcE
  extend self

  @num = [1]

  define_callback :before
  define_callback :after

  before do
    @num.push 2
  end

  before do
    @num.push 3
  end

  after do
    @num.push 4
  end

  def num
    @num
  end
end

###

describe 'Class callbacks' do
  context 'is passing when' do
    it 'callback is executing in good order' do
      a = CcA.new
      a.run_callback :before
      expect(a.var1).to eq nil

      b = CcB.new
      b.run_callback :before
      expect(b.var1).to eq [:foo]

      c = CcC.new
      c.run_callback :before
      expect(c.var1).to eq [:foo, :bar]

      d = CcD.new
      d.run_callback :before
      expect(d.var1).to eq [:foo, :bar]
    end

    it 'callbacks are running in singletons' do
      CcE.run_callback :before
      expect(CcE.num).to eq [1, 2, 3]
      CcE.run_callback :after
      expect(CcE.num).to eq [1, 2, 3, 4]
    end

    it 'can pass parameters' do
      d = CcD.new
      d.run_callback :after, 3
      expect(d.var2).to eq 6
    end
  end
end

