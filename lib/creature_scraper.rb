class CreatureScraper
  attr_accessor :doc, :type, :hemisphere

  def initialize(path, c_type, h_type)
    @doc = Nokogiri::HTML(open(path))
    @type = c_type
    @hemisphere = h_type
  end

  def self.scrape
    base_path = "https://animalcrossing.fandom.com/wiki/"
    fish_path = "Fish_(New_Horizons)"
    bug_path = "Bugs_(New_Horizons)"
    CreatureScraper.new("#{base_path}#{fish_path}", :fish, "north").call
    CreatureScraper.new("#{base_path}#{fish_path}", :fish, "south").call
    CreatureScraper.new("#{base_path}#{bug_path}", :bug, "north").call
    CreatureScraper.new("#{base_path}#{bug_path}", :bug, "south").call
  end

  def call
    rows.each do |row_doc|
      creature = nil
      if @hemisphere == "south"
        # creature already exists because northern hemisphere has already been set
        creature = Creature.find_by_name(row_doc[0].text.lstrip.gsub("\n", "").downcase)
      else
        case @type
          when :bug
            creature = Creature.create(scrape_bug_row(row_doc))
          when :fish
            creature = Creature.create(scrape_fish_row(row_doc))
        end
      end

      # only add times on first scrape for each creature (northern hemisphere)
      if @hemisphere == "north"
        # index is set depending on creature type because fish have an extra
        # column for shadow size

        time = scrape_time(row_doc, @type == :fish ? 5 : 4)
        creature.add_times(time)

      end

      creature.add_hemisphere(scrape_hemisphere(row_doc, @type == :fish ? 6 : 5))
    end
  end

  private
    def rows
      title = ''

      if @hemisphere == "north"
        title = "Northern"
      else
        title = "Southern"
      end

      table = @doc.xpath("//div[@title='#{title} Hemisphere']").css('table.sortable')
      @rows ||= table.css("tr").collect { |row| row.css("td") }.filter { |array| !array.empty? }
    end

    def scrape_fish_row(row)
      {
        c_type: :fish,
        :name => row[0].text.lstrip.gsub("\n", "").downcase,
        :url => row[0].css("a").attribute("href").value,
        :price => row[2].text.lstrip.gsub("\n", ""),
        :location => row[3].text.lstrip.gsub("\n", ""),
        :shadow_size => row[4].text.lstrip.gsub("\n", ""),
        # :time => row[5].text.lstrip.gsub("\n", "")
      }
    end

    def scrape_bug_row(row)
      {
        c_type: :bug,
        :name => row[0].text.lstrip.gsub("\n", "").downcase,
        :url => row[0].css("a").attribute("href").value,
        :price => row[2].text.lstrip.gsub("\n", ""),
        :location => row[3].text.lstrip.gsub("\n", ""),
        # :time => row[4].text.lstrip.gsub("\n", ""),
      }
    end

    def scrape_time(row, index)
      row[index].text.lstrip.gsub("\n", "")
    end

    def scrape_hemisphere(row, start_index)
      {
        h_type: @hemisphere,
        january: row[start_index].text.lstrip.gsub("\n", "") == "-" ? false : true,
        february: row[start_index+1].text.lstrip.gsub("\n", "") == "-" ? false : true,
        march: row[start_index+2].text.lstrip.gsub("\n", "") == "-" ? false : true,
        april: row[start_index+3].text.lstrip.gsub("\n", "") == "-" ? false : true,
        may: row[start_index+4].text.lstrip.gsub("\n", "") == "-" ? false : true,
        june: row[start_index+5].text.lstrip.gsub("\n", "") == "-" ? false : true,
        july: row[start_index+6].text.lstrip.gsub("\n", "") == "-" ? false : true,
        august: row[start_index+7].text.lstrip.gsub("\n", "") == "-" ? false : true,
        september: row[start_index+8].text.lstrip.gsub("\n", "") == "-" ? false : true,
        october: row[start_index+9].text.lstrip.gsub("\n", "") == "-" ? false : true,
        november: row[start_index+10].text.lstrip.gsub("\n", "") == "-" ? false : true,
        december: row[start_index+11].text.lstrip.gsub("\n", "") == "-" ? false : true
      }
    end
end