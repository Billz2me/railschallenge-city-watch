json.emergencies @emergencies do |emergency|
  json.(emergency, *emergency.attributes.keys)
end
