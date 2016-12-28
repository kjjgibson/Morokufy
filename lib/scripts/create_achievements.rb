def build_achievement(name, description, image_url)
  a = Achievement.find_or_initialize_by(name: name)
  a.description = description
  a.image_url = image_url
  a.save!
end

Achievement.transaction do
  build_achievement('Beginner Tester', 'Successfully build five Semaphore projects', 'https://pbs.twimg.com/profile_images/574917057721978881/fAhdRiwP.png')
end