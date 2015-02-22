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

  def ExchangeRate.currencies()
    # Gets a list of all the currencies
    Parser.send "#{SOURCE}_cur"
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
    last_elem = doc.last
    doc = doc.select { |x| Date.parse(x.attribute('time')) <= date }
    if doc.length == 0
      doc = last_elem
    else
      doc  = doc[0]
    end

    to_val = doc.element_children.select { |x| x.attribute('currency').value.eql? to }
    from_val = doc.element_children.select { |x| x.attribute('currency').value.eql? from }

    to_val[0].attribute('rate').value.to_f / from_val[0].attribute('rate').value.to_f
  end

  def Parser.Eurofxref_cur
    f = File.open("eurofx.xml")
    doc = Nokogiri::XML(f)
    f.close()

    doc = doc.element_children[0].element_children[2].element_children

    doc[0].element_children.map { |x| x.attribute('currency').value }
  end
end

