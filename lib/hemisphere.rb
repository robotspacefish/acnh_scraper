class Hemisphere
  attr_accessor :january, :february, :march, :april, :may, :june, :july, :august, :september, :october, :november, :december

  def initialize(hemisphere_hash)
    @january = hemisphere_hash[:january]
    @february = hemisphere_hash[:february]
    @march = hemisphere_hash[:march]
    @april = hemisphere_hash[:april]
    @may = hemisphere_hash[:may]
    @june = hemisphere_hash[:june]
    @july = hemisphere_hash[:july]
    @august = hemisphere_hash[:august]
    @september = hemisphere_hash[:september]
    @october = hemisphere_hash[:october]
    @november = hemisphere_hash[:november]
    @december = hemisphere_hash[:december]
  end
end