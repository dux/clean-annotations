require_relative './clean-annotations/class_callbacks'

# do not load if allready defined

unless Object.respond_to?(:class_attribute)
  require_relative './clean-annotations/class_attribute'
end

unless Object.respond_to?(:method_attr)
  require_relative './clean-annotations/method_attr'
end
