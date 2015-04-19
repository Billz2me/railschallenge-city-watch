json.emergency do
  json.(emergency, *emergency.attributes.keys)
  json.responders emergency.responders.pluck(:name)
  json.full_response emergency.full_response?
end
