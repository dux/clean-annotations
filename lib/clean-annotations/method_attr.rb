module MethodAttributes
  extend self

  @@GLOBAL_OPTS = {}
  @@METHOD_OPTS = {}

  def define klass, param_name, &block
    klass.define_singleton_method(param_name) do |*args|
      @@METHOD_OPTS[param_name] ||= []
      @@METHOD_OPTS[param_name].push block ? block.call(*args) : args[0]
    end

    klass.define_singleton_method(:method_added) do |name|
      return unless @@METHOD_OPTS.keys.first

      @@GLOBAL_OPTS[to_s] ||= {}
      @@GLOBAL_OPTS[to_s][name] = @@METHOD_OPTS.dup
      @@METHOD_OPTS.clear
    end
  end

  def get klass, method_name=nil
    return @@GLOBAL_OPTS[klass.to_s] unless method_name

    klass.ancestors.map(&:to_s).each do |a_klass|
      v = @@GLOBAL_OPTS[a_klass][method_name]
      return v if v
    end
  end
end

###

class Object
  def method_attr name=nil, &block
    if respond_to?(:const_missing) && respond_to?(:ancestors)
      if name.nil?
        return MethodAttributes.get(self) || {}
      end

      MethodAttributes.define self, name, &block
    else
      # instance
      base = MethodAttributes.get(self.class)
      name ? base[name] : base
    end
  end
end

# class Foo
#   method_attr :name
#   method_attr :param do |field, type=String, opts={}|
#     opts[:name] = field
#     opts[:type] ||= String
#     opts
#   end

#   name "Test method desc 1"
#   name "Test method desc 2"
#   param :email, :email
#   def test
#   end
# end

# Foo.method_attr
# {
#   test: {
#     name: [
#       "Test method desc 1",
#       "Test method desc 2"
#     ],
#     param: [
#       {
#         name: :email,
#         type: String
#       }
#     ]
#   }
# }
