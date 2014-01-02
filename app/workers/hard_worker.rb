class HardWorker
  include Sidekiq::Worker

  def perform(name, email)
    puts 'Doing hard work'

    100.times do |n|
        puts "name = #{name} email = #{email} #{n} #{Time.now}"
    end

  end
end