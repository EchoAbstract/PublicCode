#!/usr/bin/env ruby

$hasColor = true
begin
    require 'smart_colored'
rescue LoadError
    $hasColor = false
end

#require 'pry'

def safeToI(val)
  if (val == "")
    return -1
  else
    return val.to_i
  end
end

def mouseBattery
  battery = `ioreg -c BNBMouseDevice | grep Percent | tail -1| sed 's/.* = //'`
  return safeToI(battery)
end

def keyboardBattery
  battery = `ioreg -c AppleBluetoothHIDKeyboard | grep BatteryPercent | tail -1| sed 's/.* = //'`
  return safeToI(battery)
end

def trackpadBattery
  battery = `ioreg -c BNBTrackpadDevice | grep BatteryPercent | tail -1| sed 's/.* = //'`
  return safeToI(battery)
end

def systemBattery
  systemAmounts = `ioreg -n AppleSmartBattery | grep Capacity | head -2`;

  ## Pull out each of the two lines, 1: maxCapacity, 2: currentCapacity
  values = systemAmounts.split("\n").map do |line|
    line.gsub(/^.*\s+=\s+/, '')
  end

  systemBatteryCapacity = -1
  if (values.length >= 2)
    systemBatteryCapacity = (values[1].to_f/values[0].to_f)*100
  end

  #binding.pry

  return systemBatteryCapacity
  
end

def formatOutput(level)

  # if (level < 0)
  #   return "Disconnected".colored.black.bold
  # elsif (level < 33)
  #   return "         #{level}%".colored.red
  # elsif (level < 66)
  #   return "         #{level}%".colored.yellow
  # else
  #   return "         #{level}%".colored.green
  # end
  if (level > 99) then level = 99; end
  lev = "%02d%%         " % level
  if !$hasColor
      if level < 0
          return "Disconnected"
      else
          return lev
      end
  end

  if (level < 0)
    return "Disconnected".colored.black.bold
  elsif (level < 33)
    return lev.to_s.colored.red
  elsif (level < 66)
    return lev.to_s.colored.yellow
  else
    return lev.to_s.colored.green
  end

end

# puts "System Battery:     #{formatOutput(systemBattery)}"
# puts "Trackpad Battery:   #{formatOutput(trackpadBattery)}"
# puts "Mouse Battery:      #{formatOutput(mouseBattery)}"
# puts "Keyboard Battery:   #{formatOutput(keyboardBattery)}"

puts "System Battery:     #{formatOutput(systemBattery)} Trackpad Battery:   #{formatOutput(trackpadBattery)}"
puts "Mouse Battery:      #{formatOutput(mouseBattery)} Keyboard Battery:   #{formatOutput(keyboardBattery)}"
