require 'json'
require 'nokogiri'
require 'date'

module ExchangeRate

  SOURCE = 'Eurofxref'

  def ExchangeRate.at(date, to, from)

    begin
      p_date = Date.parse(date)
    rescue ArgumentError, TypeError
      p_date = Date.today
    end

    if not to or not from
      return 0.0
    end

    Parser.send SOURCE, p_date, to, from
  end
end

module Parser
  # This module creates a namespace such that one can restrict the scope of inclusions
  def Parser.Eurofxref(date, to, from)
    # This shall retrieve the relevant xml document and return the result
    # As reference, everything must be converted via the Euro
    f = File.open("eurofx.xml")
    doc = Nokogiri::XML(f)
    f.close()

    doc = doc.element_children[0].element_children[2].element_children
    # return doc
    doc = doc.select { |x| Date.parse(x.attribute('time')) <= date }

    to_val = doc[0].element_children.select { |x| x.attribute('currency').value.eql? to }
    from_val = doc[0].element_children.select { |x| x.attribute('currency').value.eql? from }
    from_val[0].attribute('rate').value.to_f / to_val[0].attribute('rate').value.to_f
  end
end

# puts ExchangeRate.at(0,0,0)
# 3.25
