json.data do
  json.array! @payrolls do |payroll|
    json.partial! 'payroll', payroll: payroll
  end
end