require 'sinatra'
STDOUT.sync = true

get '/' do
  [301, {'Location' => 'https://google.com' }, ['']]
end

