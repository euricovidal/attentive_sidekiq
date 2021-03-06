module AttentiveSidekiq
  module Web
    VIEW_PATH = File.expand_path("../web/views", __FILE__)

    def self.registered(app)
      app.get("/disappeared-jobs") do
        @disappeared_jobs = AttentiveSidekiq::Disappeared.jobs
        erb File.read(File.join(VIEW_PATH, 'disappeared-list.erb'))
      end

      app.post("/disappeared-jobs/:jid/delete") do
        AttentiveSidekiq::Disappeared.remove(params['jid'])
        redirect "#{root_path}disappeared-jobs"
      end

      app.post("/disappeared-jobs/:jid/requeue") do
        AttentiveSidekiq::Disappeared.requeue(params['jid'])
        redirect "#{root_path}disappeared-jobs"
      end

    end
  end
end

Sidekiq::Web.register AttentiveSidekiq::Web
Sidekiq::Web.locales << File.expand_path(File.dirname(__FILE__) + "/web/locales")
Sidekiq::Web.tabs['disappeared_jobs'] = 'disappeared-jobs'
