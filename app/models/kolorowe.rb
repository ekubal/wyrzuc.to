class Kolorowe < ActiveRecord::Base

geocoded_by :ulica   # can also be an IP address
after_validation :geocode  
end
