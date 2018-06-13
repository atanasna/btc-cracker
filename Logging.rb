require 'logger'
require 'colorize'

module Logging
    LOG_MAIN = Logger.new('logs/main.log', 10, 10240000)
    LOG_RESULTS = Logger.new('logs/results.log')
end