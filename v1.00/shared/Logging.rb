require 'logger'
require 'colorize'

module Logging
    LOG_CLIENT_MAIN = Logger.new('../logs/client_main.log', 10, 10240000)
    LOG_SERVER_MAIN = Logger.new('../logs/server_main.log', 10, 10240000)
    LOG_RESULTS = Logger.new('../logs/results.log')
end