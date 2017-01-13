def build_achievement(name, description, image_url)
  a = Achievement.find_or_initialize_by(name: name)
  a.description = description
  a.image_url = image_url
  a.save!
end

def create_numbered_achievements(achievement_details, description, image_name_prefix)
  achievement_details.each do |achievement_detail|
    description = description.gsub('%{number}', achievement_detail[:number])
    if achievement_detail[:number] > 1
      description = "#{description}s"
    end

    build_achievement(achievement_detail[:name], description, "https://s3-ap-southeast-2.amazonaws.com/gameserver-morokufy/achievement_#{image_name_prefix}_#{achievement_detail[:number]}.png")
  end
end

Achievement.transaction do
  #============= Semaphore ================
  image_name_prefix = 'semaphore_passed'
  description = 'Successfully build %{number} Semaphore project'
  achievement_details = [{ number: 1, name: 'Does it Work?' }, #brown
                         { number: 5, name: 'Testing the Waters' }, #grey
                         { number: 10, name: 'Testing Your Skill' }, #amber
                         { number: 20, name: 'A Tester\'s Courage' }, #green
                         { number: 40, name: 'Quality Assured' }, #cyan
                         { number: 80, name: 'Can\'t Test This!' }, #Ingigo
                         { number: 200, name: 'Green for Miles' }] #purple
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
  achievement_details = [{ number: 1, name: '' },
                         { number: 5, name: '' },
                         { number: 10, name: '' },
                         { number: 20, name: '' },
                         { number: 40, name: '' },
                         { number: 80, name: '' },
                         { number: 200, name: '' }]
  create_numbered_achievements(achievement_details, description, image_name_prefix)

  image_name_prefix = 'bitbucket_pr_created'
  description = 'Create %{number} PullRequest'
  achievement_details = [{ number: 1, name: '' },
                         { number: 5, name: '' },
                         { number: 10, name: '' },
                         { number: 20, name: '' },
                         { number: 40, name: '' },
                         { number: 80, name: '' },
                         { number: 200, name: '' }]
  create_numbered_achievements(achievement_details, description, image_name_prefix)

  image_name_prefix = 'bitbucket_pr_merged'
  description = 'Merge %{number} PullRequest'
  achievement_details = [{ number: 1, name: '' },
                         { number: 5, name: '' },
                         { number: 10, name: '' },
                         { number: 20, name: '' },
                         { number: 40, name: '' },
                         { number: 80, name: '' },
                         { number: 200, name: '' }]
  create_numbered_achievements(achievement_details, description, image_name_prefix)
  #========================================

  #============= Jira ================
  image_name_prefix = 'jira_log_work'
  description = 'Log work in Jira %{number} time'
  achievement_details = [{ number: 1, name: '' },
                         { number: 5, name: '' },
                         { number: 10, name: '' },
                         { number: 20, name: '' },
                         { number: 40, name: '' },
                         { number: 80, name: '' },
                         { number: 200, name: '' }]
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