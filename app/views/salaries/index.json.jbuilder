json.data do
  json.array! @salaries do |salary|
    json.partial! 'salary', salary: salary
  end
end
