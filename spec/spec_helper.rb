require 'active_support'

ActiveSupport::Dependencies.autoload_paths = [
    'app/controllers'
]

RSpec.configure do |config|
end
