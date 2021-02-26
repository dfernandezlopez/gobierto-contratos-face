class FiscalEntities
  require "faraday"

  def initialize(level)
    @level = level
    @base_url = "https://face.gob.es/api/v2/administraciones"
    @items = []
  end

  def import_new_entities
    level_index = 1

    if @level
      get_dir3(@level)
    else
      5.times do
        get_dir3(level_index)
        level_index += 1
      end
    end

    FiscalEntitiesWorker.perform_async(@items)
  end

  private

  def get_dir3(level)
    page = 1

    loop do
      response = call_api_v1(level, page)
      @items.concat(response.map { |i| i["codigo_dir"] }) unless response.empty?
      page += 1
      break unless response.count.positive?
    end
  end

  def call_api_v1(level, page)
    begin
      JSON.parse(Faraday.get("#{@base_url}?nivel=#{level}&page=#{page}").body)["items"]
    rescue StandardError => e
      puts e
      Rails.logger.error e
      execution_log
    end
  end
end
