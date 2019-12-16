require 'spec_helper'

class Foo
  method_attr :name
  method_attr :generic
  method_attr :param do |field, type=String, opts={}|
    opts[:name] = field
    opts[:type] ||= String
    opts
  end

  name "Test method desc 1"
  name "Test method desc 2"
  generic :foo, :bar, 123
  generic :baz, 456, [1, 2, 3]
  param :email, :email
  def foo
  end

  def bar
  end
end

describe 'Method attributes' do
  context 'is not returning' do
    it 'for non existant methods' do
      expect(Foo.method_attr[:baz]).to eq nil
    end

    it 'for existant methods but not linked' do
      expect(Foo.method_attr[:bar]).to eq nil
    end
  end

  context 'is returning hash and' do
    it 'allows two types of access' do
      expect(Foo.method_attr[:foo][:name].class).to eq Array
      expect(Foo.new.method_attr(:foo)[:name].class).to eq Array
    end

    it 'has expeced attributes' do
      data = Foo.method_attr[:foo]
      expect(data[:name][0][0]).to eq 'Test method desc 1'
      expect(data[:param][0][:name]).to eq :email
      expect(data[:param][0][:type]).to eq String
    end

    it 'has right list attributes' do
      data = Foo.method_attr[:foo]
      expect(data[:name][0][0]).to eq 'Test method desc 1'
      expect(data[:name][1][0]).to eq 'Test method desc 2'
    end

    it 'has valid generic unprocessed arguments' do
      data = Foo.method_attr[:foo][:generic]
      expect(data[0]).to eq [:foo, :bar, 123]
      expect(data[1]).to eq [:baz, 456, [1, 2, 3]]
    end
  end
end
