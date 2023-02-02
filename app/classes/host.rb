class Host

  PARTNERS = [
    {
      class: "AirbnbHost", 
      dig_code: [:reservation_code],
      code_indicators: ["yyy"]
    },
    {
      class: "BookingHost", 
      dig_code: [:reservation, :code],
      code_indicators: ["xxx"]
    }
  ]

  def initialize
    @name = "Default"
    @payload = {}
    @matchers = {}
  end

  def name
    @name
  end

  def payload
    @payload
  end

  def matchers
    @matchers
  end

  def parse
    {}.tap do |result|
      matchers.each do |key, values|
        (result[key] = {}).tap do |inner|
          values.each do |attr, dig|
            if ( str = payload.dig(*dig) ).present?
              assign_process(inner, attr, str)
            end
          end
        end
      end
    end
  end

  def assign_process(res, attr, str)
    res[attr] = str
  end

  def self.get_partner(hsh)
    partner = nil

    PARTNERS.each do |p|
      code = hsh.dig(*p[:dig_code])

      if code.present? && code.match(/(#{p[:code_indicators].join('|')})/i)
        partner = p[:class].constantize.new(hsh)
        break
      end
    end

    partner
  end

end