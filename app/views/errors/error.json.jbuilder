json.error do
  json.array! object.errors.full_messages do |error|
    json.message error
    json.object object.class.to_s
  end
end
