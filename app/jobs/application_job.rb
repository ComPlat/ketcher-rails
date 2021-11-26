# upgrade, https://guides.rubyonrails.org/upgrading_ruby_on_rails.html#activejob-now-inherits-from-applicationjob-by-default
class ApplicationJob < ActiveJob::Base
end
