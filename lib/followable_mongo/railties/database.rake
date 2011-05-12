namespace :mongo do
  namespace :followable do
    desc 'Update up_follows_count, down_follows_count, follows_count and follows_point'
    task :remake_stats => :environment do
      Mongo::Followable::Tasks.remake_stats(:log)
    end

    desc 'Set counters and point to 0 for uninitizized followable objects'
    task :init_stats => :environment do
      Mongo::Followable::Tasks.init_stats(:log)
    end

    desc 'Migrate follow data created by version < 0.7.0 to new follow data storage'
    task :migrate_old_follows => :environment do
      Mongo::Followable::Tasks.migrate_old_follows(:log)
    end
  end
end
