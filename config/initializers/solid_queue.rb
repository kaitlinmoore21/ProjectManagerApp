
Rails.application.config.after_initialize do
  if defined?(SolidQueue::Record)
    SolidQueue::Record.establish_connection :queue
  end
end
