# Rails style callbacks

class Class
  def class_callback name
    ivar = "@class_callbacks_#{name}"

    define_singleton_method(name) do |method_name=nil, &block|
      ref = caller[0].split(':in ').first

      self.instance_variable_set(ivar, {}) unless instance_variable_defined?(ivar)
      self.instance_variable_get(ivar)[ref] = method_name || block
    end
  end
end

class Object
  def class_callback name, *args
    ivar = "@class_callbacks_#{name}"

    list = self.class.ancestors
    list = list.slice 0, list.index(Object) if list.index(Object)

    list.reverse.each do |klass|
      if klass.instance_variable_defined?(ivar)
        mlist = klass.instance_variable_get(ivar).values
        mlist.each do |m|
          if m.is_a?(Symbol)
            send m, *args
          else
            instance_exec *args, &m
          end
        end
      end
    end
  end
end

# for controllers, execute from AppController to MainController
# class_callback :before
# before do
#    ...
# end
# before :method_name
# instance = new
# instance.class_callback :before
# instance.class_callback :before, @arg
