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

  def self.all_to_obj
    # TODO refactor - did this quick and sloppy

    self.all.map do |c|
      creature_obj = {
        name: c.name,
        type: c.type,
        url: c.url,
        price: c.price,
        location: c.location,
        shadow_size: c.shadow_size,
        hemispheres: {
          north: {},
          south: {}
        },
        available_times: []
      }


        north_hash = {}
        south_hash = {}
        c.hemispheres.first.instance_variables.each do |var|
          north_hash[var.to_s.delete("@")] = c.hemispheres.first.instance_variable_get(var)
        end
        c.hemispheres.last.instance_variables.each do |var|
          south_hash[var.to_s.delete("@")] = c.hemispheres.last.instance_variable_get(var)
        end

        creature_obj[:hemispheres][:north] = north_hash
        creature_obj[:hemispheres][:south] =  south_hash
      c.available_times.each do |at|
        creature_obj[:available_times] << {
          time: at.time,
          start_time: at.start_time,
          end_time: at.end_time
        }
      end

      pp creature_obj
    end
  end

  def self.all_to_json
    creature_obj = self.all_to_obj
    File.write("./creatures.json",JSON.pretty_generate(creature_obj))
    # .map do |c|
    #   File.open("./creatures.json", "w") do |f|
    #     f.write(JSON.pretty_generate(c))
    #   end
    # end

  end

end