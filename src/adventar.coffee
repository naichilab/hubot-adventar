# Description
#   A hubot script that does the things
#
# Configuration:
#   LIST_OF_ENV_VARS_TO_SET
#
# Commands:
#   hubot hello - <what the respond trigger does>
#   orly - <what the hear trigger does>
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   naichilab <naichilab@live.jp>

cheerio = require 'cheerio'
request = require 'request'

module.exports = (robot) ->
  robot.respond /adventar(?: (\S+))?/, (msg) ->
    msg.send msg.match[0]
    msg.send msg.match[1]

    query = msg.match[1]

    #send HTTP request
    baseUrl = 'http://www.adventar.org'
    request baseUrl + '/', (_, res) ->

      #parse response body
      $ = cheerio.load res.body
      calendars = []
      $('.mod-calendarList .mod-calendarList-title a').each ->
        a = $ @
        url = baseUrl + a.attr('href')
        name = a.text()
        calendars.push { url, name }

      #filter calendars
      filtered = calendars.filter (c) ->
        if query? then c.name.match(new RegExp(query, 'i')) else true

      # format calendars
      message = filtered
        .map (c) ->
          "#{c.name} #{c.url}"
        .join '\n'

      msg.send message
