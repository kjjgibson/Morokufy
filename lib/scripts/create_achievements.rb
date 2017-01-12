def build_achievement(name, description, image_url)
  a = Achievement.find_or_initialize_by(name: name)
  a.description = description
  a.image_url = image_url
  a.save!
end

Achievement.transaction do
  build_achievement('Does it Work?', 'Successfully build your first Semaphore project', 'https://s3-ap-southeast-2.amazonaws.com/gameserver-morokufy/achievement_semaphore_passed_1.png')
  build_achievement('Testing the Waters', 'Successfully build five Semaphore projects', 'https://s3-ap-southeast-2.amazonaws.com/gameserver-morokufy/achievement_semaphore_passed_5.png')
  build_achievement('Testing Your Skill', 'Successfully build ten Semaphore projects', 'https://s3-ap-southeast-2.amazonaws.com/gameserver-morokufy/achievement_semaphore_passed_10.png')
  build_achievement('A Tester\'s Courage', 'Successfully build twenty Semaphore projects', 'https://s3-ap-southeast-2.amazonaws.com/gameserver-morokufy/achievement_semaphore_passed_20.png')
  build_achievement('Quality Assured', 'Successfully build forty Semaphore projects', 'https://s3-ap-southeast-2.amazonaws.com/gameserver-morokufy/achievement_semaphore_passed_40.png')
  build_achievement('Can\'t Test This!', 'Successfully build eighty Semaphore projects', 'https://s3-ap-southeast-2.amazonaws.com/gameserver-morokufy/achievement_semaphore_passed_80.png')
  build_achievement('Green for Miles', 'Successfully build two hundred Semaphore projects', 'https://s3-ap-southeast-2.amazonaws.com/gameserver-morokufy/achievement_semaphore_passed_200.png')

  build_achievement('It Worked On MY Machine', 'First failed Semaphore project build', 'https://s3-ap-southeast-2.amazonaws.com/gameserver-morokufy/achievement_semaphore_failed_1.png')
  build_achievement('Testing Your Patience', 'Ten failed Semaphore project builds', 'https://s3-ap-southeast-2.amazonaws.com/gameserver-morokufy/achievement_semaphore_failed_10.png')
end