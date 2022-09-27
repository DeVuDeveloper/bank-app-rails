module StatsHelper
  def stats_amount_chart(records)
    total_amount = records.map { |record| [record.display_time, record.total_amount] }
    [{ name: 'Business volume', data: total_amount }]
  end

  def stats_clients_chart(records)
    clients_count = records.map { |record| [record.display_time, record.clients_count] }
    [{ name: 'Number of customers', data: clients_count }]
  end
end
