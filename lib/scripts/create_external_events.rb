def build_external_event(name, description)
  e = ExternalEvent.find_or_initialize_by(name: name)
  e.description = description
  e.save!
end

ExternalEvent.transaction do
  build_external_event('SemaphoreBuildPassed', 'A successful Semaphore build')
  build_external_event('SemaphoreBuildFailed', 'A failed Semaphore build')
end