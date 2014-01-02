require 'rubygems'
require 'daemons'

Daemons.run(File.expand_path('../../lib/set_newest20.rb', __FILE__))
