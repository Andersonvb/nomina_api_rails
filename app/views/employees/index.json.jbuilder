json.data do
  json.array! @employees do |employee|
    json.partial! 'employee', employee: employee
  end
end