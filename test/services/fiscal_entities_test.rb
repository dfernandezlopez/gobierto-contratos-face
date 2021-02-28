require_relative "../test_helper"
require_relative "../../app/services/fiscal_entities"

class FiscalEntitiesTest < ActiveSupport::TestCase
  def entities_service
    FiscalEntities.new(1)
  end

  def test_import_new_entities
    VCR.use_cassette("dir3_entities") do
      response = entities_service.import_new_entities

      assert_equal(44, response.count)
      assert_kind_of Array, response
      assert_equal(JSON.parse(File.read("#{Rails.root}/test/support/files/fiscal_entities_all.rb")), response)
    end
  end
end
