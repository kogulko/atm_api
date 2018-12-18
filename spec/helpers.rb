require 'factory_bot'
require 'trailblazer/test'
require 'trailblazer/test/deprecation/operation/assertions'
module Helpers
  include FactoryBot::Syntax::Methods
  include Trailblazer::Test::Assertions
  include Trailblazer::Test::Operation::Assertions
  include Trailblazer::Test::Deprecation::Operation::Assertions

  def banknote_hash(face_value, quantity)
    { face_value: face_value, quantity: quantity }
  end
end
