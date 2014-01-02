require 'faye'

bayeux = Faye::RackAdapter.new(:mount => '/faye', :timeout => 25)
bayeux.listen(9292)


# class ServerAuth
#   def incoming(message, callback)
#     # Let non-subscribe messages through
#     unless message['channel'] == '/meta/subscribe'
#       return callback.call(message)
#     end

#     # Get subscribed channel and auth token
#     # subscription = message['subscription']
#     # msg_token    = message['ext'] && message['ext']['authToken']

#     # Find the right token for the channel
#     # registry = JSON.parse(File.read('./tokens.json'))
#     # token    = registry[subscription]

#     # Add an error if the tokens don't match
#     # if token != msg_token
#     #   message['error'] = 'Invalid subscription auth token'
#     # end

#     # Call the server back now we're done
#     callback.call(message)
#   end
# end

# bayeux.add_extension(ServerAuth.new)


# class ClientAuth
#   def outgoing(message, callback)
#     # Again, leave non-subscribe messages alone
#     unless message['channel'] == '/meta/subscribe'
#       return callback.call(message)
#     end

#     # Add ext field if it's not present
#     message['ext'] ||= {}

#     # Set the auth token
#     message['ext']['authToken'] = 'rt6utrb'

#     # Carry on and send the message to the server
#     callback.call(message)
#   end
# end

# client.add_extension(ClientAuth.new)


# bayeux = Faye::RackAdapter.new(:mount => '/faye', :timeout => 25)

# bayeux.bind(:handshake) do |client_id|
#   puts "handshake #{client_id}  #{Time.now}"
# end


# require 'eventmachine'

# EM.run {
#   client = Faye::Client.new('http://localhost:9292/faye')

#   client.subscribe('/foo') do |message|
#     puts message.inspect
#   end

#   client.publish('/foo', 'text' => 'Hello world')
# }

