require 'spec_helper'

###

class A
  class_attribute :layout, 'default'
  class_attribute(:time) { Time.now.to_i }
end

class B < A
  layout 'main'
end

class C < B
  time :foo
end

class D
end

###

describe 'Class attribute' do
  context 'is faling when' do
    it 'gets from bad class' do
      expect(D.respond_to?(:layout)).to eq false
      expect { D.layout }.to raise_exception NoMethodError
    end
  end

  context 'is passing when' do
    it 'defines valid vars for :layout' do
      expect(A.layout).to eq 'default'
      expect(B.layout).to eq 'main'
      expect(C.layout).to eq 'main'
    end

    it 'defines valid vars in :time' do
      now = Time.now.to_i

      expect(A.time).to eq now
      expect(B.time).to eq now
      expect(C.time).to eq :foo
    end

    it 'can access varibles from an instance' do
      c = C.new
      expect(c.class.layout).to eq 'main'
      expect(c.class_attribute(:layout)).to eq 'main'
    end
  end
end
