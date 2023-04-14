json.data do
  json.array! @periods do |period|
    json.partial! 'period', period: period
  end
end