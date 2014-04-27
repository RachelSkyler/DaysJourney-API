class Path
  include Mongoid::Document
  include Mongoid::Timestamps

  # Bi-directional relations with User and Destination.
  belongs_to :user, inverse_of: :paths
  has_many :destinations, validate: false, inverse_of: :path

end
