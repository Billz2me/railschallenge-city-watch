json.emergencies @emergencies do |emergency|
  json.(emergency, *emergency.attributes.keys)
end

json.full_responses @full_responses
