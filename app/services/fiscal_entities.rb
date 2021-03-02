class FiscalEntities
  require "faraday"

  def initialize(level)
    @level = level
    @base_url = "https://face.gob.es/api/v2/administraciones"
    @items = []
    @dirs3_bd = Hash[FiscalEntity.pluck(:dir3, :id).collect { |x, y| [x, y] }]
  end

  def import_new_entities
    level_index = 1
    @log_file = "dir3_to_process"

    Rails.logger = Logger.new "#{Rails.root}/log/#{@log_file}.log"

    if @level
      get_dir3(@level)
    else
      5.times do
        get_dir3(level_index)
        level_index += 1
      end
    end

    format_array

    @items.each do |items|
      FiscalEntitiesWorker.perform_async(items, @dirs3_bd)
    end
  end

  private

  def format_array
    if @items.size >= 99
      distribute_arrays(100)
    else
      distribute_arrays(1)
    end
  end

  def distribute_arrays(number_items)
    @items = @items.each_slice(number_items).to_a
  end

  def get_dir3(level)
    @page = 1

    loop do
      response = call_api_v1(level)
      @items.concat(response.map { |i| i["codigo_dir"] }) unless response.empty?
      @page += 1
      break unless response.count.positive?
    end
  end

  def call_api_v1(level)
    begin
      JSON.parse(Faraday.get("#{@base_url}?nivel=#{level}&page=#{@page}").body)["items"]
    rescue StandardError => e
      puts e
      Rails.logger.error e
      execution_log_dir3
    end
  end

  def execution_log_dir3
    puts "These are the dir3 items to processs, see in this log: #{@log_file}"
    puts "All dir3s created and ignored can be seen in: items_dir3.log"
    Rails.logger.info "#######################################################################################################"
    Rails.logger.info "#######################################################################################################"
    Rails.logger.info "#######################################################################################################"
    Rails.logger.info "*************************************dir3 items to processs********************************************"
    Rails.logger.info @items.empty? ? "no item to process" : @items.each_slice(15).to_a.map { |a| a.push("\n") }.join("|")
    Rails.logger.info "*******************************************************************************************************"
  end
end
