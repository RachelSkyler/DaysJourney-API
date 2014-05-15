class Destination
  include Mongoid::Document
  include Mongoid::Timestamps

  # latitude : 위도, longitude : 경도 
  field :description, type: String, default: ""
  field :refenence, type: String
  field :location_name, type: String
  field :latitude, type: String
  field :longitude, type: String
  field :is_home, type: Boolean, default: false

  # Bi-directional relations with Path.
  belongs_to :path, inverse_of: :destinations

  # Fields that are required in order to have a valid destination.
  validates :description, :latitude, :longitude, :is_home, presence: true

end
