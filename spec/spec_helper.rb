require 'awesome_print'

require './lib/clean-annotations'

class Object
  def rr data
    puts '- start: %s' % data.inspect
    ap data
    puts '- end'
  end
end

# basic config
RSpec.configure do |config|
  # Use color in STDOUT
  config.color = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # Use the specified formatter
  config.formatter = :documentation # :progress, :html, :json, CustomFormatterClass
end


