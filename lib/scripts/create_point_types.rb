def create_point_type(name)
  p = PointType.find_or_initialize_by(name: name)
  p.expires = false
  p.spendable = false
  p.save!
end

PointType.transaction do
  create_point_type('Points')
  create_point_type('Exp')
end