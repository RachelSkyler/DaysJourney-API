class Path
  include Mongoid::Document
  include Mongoid::Timestamps

  # default_scope { order('paths.created_at DESC') }

  # Bi-directional relations with User and Destination.
  belongs_to :user, inverse_of: :paths
  has_many :destinations, validate: false, inverse_of: :path

  def self.new_today_path(user_id)
    new_path = Path.new(user_id: user_id)
    result = {path: nil}

    new_home = nil
    homes = Destination.find_by(is_home: true)

    if homes.kind_of?(Array)
      homes.each do |home|  
        new_home = get_new_home(new_path, home)
      end
    else
      new_home = get_new_home(new_path, homes)
    end

    unless new_home.nil? 
      new_path.destinations.push(new_home)
      
      result = {path: new_path}
    end
  
    result
  end

  def self.has_today_path?(user_id)
    today = get_today
    latest_path = Path.where(user_id: user_id).last
    latest_created_at = latest_path.created_at
    result = {is_created_at_today: true, path: latest_path}

    today_info = [today[:day], today[:month], today[:year]]
    today_info.each do |e| 
      is_include = [latest_created_at.day, latest_created_at.month, latest_created_at.year].include? (e) 
      unless is_include
        result[:is_created_at_today] = false
        result[:path] = nil
        break
      end
    end
    
    result 
  end

  private

  def self.get_new_home(new_path, home)
    new_home = nil
    if home.path.user.id == new_path.user_id
      new_home = Destination.new(
        path_id: new_path.id,
        description: home.description,
        reference: home.reference,
        location_name: home.location_name,
        latitude: home.latitude,
        longitude: home.longitude,
        is_home: home.is_home
      )
    end

    new_home
  end

  def self.get_today
    Time.zone = 'Seoul'
    now = Time.zone.now
    result = {day: now.day, month: now.month, year:now.year}

    result
  end
end
