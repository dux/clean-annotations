module RescueFromError
  extend self

  RESCUES ||= {}

  def included base
    def base.rescue_from what, &block
      raise ArgumemtError.new('Unsupported') if what.is_a?(Symbol) && what != :all

      key = [self, what].join('-')
      RESCUES[key] = block
    end
  end

  def resolve_rescue_from
    begin
      yield
    rescue => error
      for klass in self.class.ancestors
        key = [klass, error.class].join('-')

        if block = RESCUES[key]
          return instance_exec(error, &block)
        end
      end

      for klass in self.class.ancestors
        key = [klass, :all].join('-')

        if block = RESCUES[key]
          return instance_exec(error, &block)
        end
      end
    end
  end

  private
end