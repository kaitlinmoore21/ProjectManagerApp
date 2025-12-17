class QueueBase < ActiveRecord::Base
  self.abstract_class = true
  connects_to database: { writing: :queue }
end

# Base class for the cache database
class CacheBase < ActiveRecord::Base
  self.abstract_class = true
  connects_to database: { writing: :cache }
end

# Base class for the cable database
class CableBase < ActiveRecord::Base
  self.abstract_class = true
  connects_to database: { writing: :cable }
end