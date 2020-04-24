class Creature
  attr_accessor :name, :url, :image_url, :type, :shadow_size, :price, :location, :available_times, :hemispheres
  @@all = []

  def initialize
    @available_times = []
    @hemispheres = []
  end

  def self.all
    @@all
  end

  def self.save(creature)
    @@all << creature
  end

  def self.create(creature_hash)
    creature = self.new
    creature.name = creature_hash[:name]
    creature.url = creature_hash[:url]
    creature.price = creature_hash[:price]
    creature.location = creature_hash[:location]
    creature.type = creature_hash[:type]
    creature.shadow_size = creature_hash[:shadow_size] || "NA"
    # creature.image_url = creature_hash[:image_url]

    self.save(creature)

    creature
  end

  def add_times(time_string)
    times = AvailableTime.multiple_times?(time_string) ?
      AvailableTime.split_times(time_string," & ") : [time_string]
    times.each do |t|
      available_time = AvailableTime.new(t)
      self.available_times << available_time
    end
  end

  def add_hemisphere(hemisphere_hash)
    self.hemispheres << Hemisphere.new(hemisphere_hash)
  end

  def self.find_by_name(name)
    self.all.find { |c| c.name == name}
  end


  # debug
    # def self.print_all
    #   puts self.all.size
    #   self.all.each do |c|
    #     puts "#{c.name} - #{c.location} - #{c.available_times.map {|t| t.time }}"
    #   end
    # end

end

