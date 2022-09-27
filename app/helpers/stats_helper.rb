module StatsHelper


  def stats_clients_chart(records)
    clients_count = records.map { |record| [record.display_time, record.clients_count] }
    [{ name: 'Number of customers', data: clients_count }]
  end
end
