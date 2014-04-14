class Destination
  include Mongoid::Document
  include Mongoid::Timestamps

  field :location, type: String, default: ""
  field :is_home, type: Boolean, default: false

  # Bi-directional relations with Path.
  belongs_to :path, inverse_of: :destinations

  # Fields that are required in order to have a valid destination.
  validates :location, :is_home, presence: true

end
