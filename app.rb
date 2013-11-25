require 'socket'
$stdout.sync = true

port = (ENV['PORT'] || 2000).to_i
server = TCPServer.new(port)

def end_of_request?(string)
  string =~ /\r\n\r\n\Z/
end

def read_http(socket)
  request = socket.read(14)

  while !end_of_request?(request)
    request << socket.read(1)
  end
  
  request
end

def parse_path(request)
  head, body = request.split("\r\n\r\n")
  req, headers = head.split("\r\n")
  method, path, version = req.split(/\s/)
  path
end

puts "listening on #{port}"

loop do
  Thread.start(server.accept) do |client|
    case parse_path(read_http(client))
    when "/empty"
      #causes (52) Empty reply from server in curl
    when "/", "/help"
      client.puts "HTTP/1.1 200 OK\r\nUsage:\r\n* /empty - trigger empty response from server"
    end
    client.close
  end
end
