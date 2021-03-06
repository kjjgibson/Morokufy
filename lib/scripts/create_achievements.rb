def build_achievement(name, description, image_url)
  a = Achievement.find_or_initialize_by(name: name)
  a.description = description
  a.image_url = image_url
  a.save!
end

def create_numbered_achievements(achievement_details, description, image_name_prefix)
  achievement_details.each do |achievement_detail|
    d = description.gsub("%{number}", "#{achievement_detail[:number]}")
    if achievement_detail[:number] > 1
      d = "#{d}s"
    end

    build_achievement(achievement_detail[:name], d, "https://s3-ap-southeast-2.amazonaws.com/gameserver-morokufy/achievement_#{image_name_prefix}_#{achievement_detail[:number]}.png")
  end
end

Achievement.transaction do
  #============= Semaphore ================
  image_name_prefix = 'semaphore_passed'
  description = 'Successfully build %{number} Semaphore project'
  achievement_details = [{ number: 1, name: 'Does it Work?' },
                         { number: 5, name: 'Testing the Waters' },
                         { number: 10, name: 'Testing Your Skill' },
                         { number: 20, name: 'A Tester\'s Courage' },
                         { number: 40, name: 'Quality Assured' },
                         { number: 80, name: 'Can\'t Test This!' },
                         { number: 200, name: 'Green for Miles' }]
  create_numbered_achievements(achievement_details, description, image_name_prefix)

  image_name_prefix = 'semaphore_failed'
  description = '%{number} failed Semaphore project build'
  achievement_details = [{ number: 1, name: 'It Worked On MY Machine' },
                         { number: 5, name: 'Testing Your Patience' }]
  create_numbered_achievements(achievement_details, description, image_name_prefix)
  #========================================

  #============= BitBucket ================
  image_name_prefix = 'bitbucket_repo_push'
  description = 'Push to a BitBucket repo %{number} time'
  achievement_details = [{ number: 1, name: 'First Push' },
                         { number: 5, name: 'Pushing Uphill' },
                         { number: 10, name: 'Push the Button' },
                         { number: 20, name: 'Blind Pusher' },
                         { number: 40, name: 'Push Apprentice' },
                         { number: 80, name: 'Push Expert' },
                         { number: 200, name: 'Push Master' }]
  create_numbered_achievements(achievement_details, description, image_name_prefix)

  image_name_prefix = 'bitbucket_pr_created'
  description = 'Create %{number} PullRequest'
  achievement_details = [{ number: 1, name: 'Please Be Gentle' },
                         { number: 5, name: 'Review Me!' },
                         { number: 10, name: 'Criticism Welcome' },
                         { number: 20, name: 'Review Guru' },
                         { number: 40, name: 'Review My Sexy Code' },
                         { number: 80, name: 'Nothing to Say?' },
                         { number: 200, name: 'Look at this Perfect Code' }]
  create_numbered_achievements(achievement_details, description, image_name_prefix)

  image_name_prefix = 'bitbucket_pr_merged'
  description = 'Merge %{number} PullRequest'
  achievement_details = [{ number: 1, name: 'First Merge' },
                         { number: 5, name: 'Make Way for My Merge' },
                         { number: 10, name: 'Fork in the Road' },
                         { number: 20, name: 'Branch Shredder' },
                         { number: 40, name: 'No Conflicts Here' },
                         { number: 80, name: 'Merge Master' },
                         { number: 200, name: 'Merge Guru' }]
  create_numbered_achievements(achievement_details, description, image_name_prefix)
  #========================================

  #============= Jira ================
  image_name_prefix = 'jira_log_work'
  description = 'Log work in Jira %{number} time'
  achievement_details = [{ number: 1, name: 'Off to Work You Go' },
                         { number: 5, name: 'Workin\' 9 Till 5' },
                         { number: 10, name: 'On Time' },
                         { number: 20, name: 'Works Wonders' },
                         { number: 40, name: 'Working Bee' },
                         { number: 80, name: 'Busy Beaver' },
                         { number: 200, name: 'Lumberjack' }]
  create_numbered_achievements(achievement_details, description, image_name_prefix)
  #========================================

  #============= Heroku ================
  image_name_prefix = 'heroku_deploy'
  description = 'Deploy to a Heroku app %{number} time'
  achievement_details = [{ number: 1, name: 'First Deployment' },
                         { number: 5, name: 'Officer Cadet' },
                         { number: 10, name: 'Second Lieutenant' },
                         { number: 20, name: 'First Lieutenant' },
                         { number: 40, name: 'Captain' },
                         { number: 80, name: 'Colonel' },
                         { number: 200, name: 'Major General' }]
  create_numbered_achievements(achievement_details, description, image_name_prefix)
  #========================================
end