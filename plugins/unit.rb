require 'ruby_units/namespaced'

class Unit
  include Cinch::Plugin
  include Cinch::Formatting

  match /^([\d\.,\-]{1,})\s([a-zA-Z]{1,})\sto\s([a-zA-Z]{1,})$/, :use_prefix => false

  def execute(m, amount, unit, to_unit)
    old_unit = unit
    old_to_unit = to_unit
    unit = "tempC" if unit.downcase == "c"
    unit = "tempF" if unit.downcase == "f"
    unit = "tempK" if unit.downcase == "k"
    unit = "tempR" if unit.downcase == "r"
    to_unit = "tempC" if to_unit.downcase == "c"
    to_unit = "tempF" if to_unit.downcase == "f"
    to_unit = "tempK" if to_unit.downcase == "k"
    to_unit = "tempR" if to_unit.downcase == "r"

    begin
      newamount = RubyUnits::Unit.new(amount + " " + unit).convert_to(to_unit)
      debug "#{amount} #{unit} to #{to_unit} is #{newamount.to_s}"
      m.reply Format(:bold, "[unit]") + " #{amount} #{old_unit} is #{newamount.to_s.gsub("tempF", "F").gsub("tempC", "C").gsub("tempK", "K").gsub("tempR", "R")}"
    rescue ArgumentError
      m.reply Format(:bold, "[unit]") + " Not a valid unit."
    rescue
      m.reply Format(:bold, "[unit]") + " Something happened. Sorry about that."
    end

  end
end
