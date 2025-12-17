class Job < QueueBase
  # uses project_manager_backend_development_queue
end

# app/models/cache_record.rb
class CacheRecord < CacheBase
  # uses project_manager_backend_development_cache
end

# app/models/cable_message.rb
class CableMessage < CableBase
  # uses project_manager_backend_development_cable
end