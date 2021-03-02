require_relative "../test_helper"
require_relative "../../app/workers/fiscal_entities_worker"

class FiscalEntitiesWorkerTest < Minitest::Test
  def setup
    Sidekiq::Testing.fake!
    Sidekiq::Queue.new.clear
  end

  def test_process_entities
    VCR.use_cassette("all_entities") do
      FiscalEntitiesWorker.perform_async(["E04585801"], { "L04390208" => 219371 })

      assert_equal 1, FiscalEntitiesWorker.jobs.size
      assert_equal [["E04585801"], { "L04390208" => 219371 }], FiscalEntitiesWorker.jobs.first["args"]
      assert_equal 3, FiscalEntitiesWorker.jobs.first["retry"]
      assert_equal "critical", FiscalEntitiesWorker.jobs.first["queue"]
      assert_equal "FiscalEntitiesWorker", FiscalEntitiesWorker.jobs.first["class"]
    end
  end
end
