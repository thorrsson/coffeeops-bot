
# Description:
#   google books and web search script
#   Uses the deprecated unauthenticated google search APIs.. rate limited searchs :(
#
# Dependencies:
#
# Configuration:
#   None
#
# Commands:
#   hubot book me <keywords>
#   hubot web me <keywords>
#
# Author:
#   Tim Hunter <tim@thunter.ca>
#

module.exports = (robot) ->
  robot.respond /(book)( me)? (.*)/i, (msg) ->
    query = msg.match[3]
    # Using deprecated Google image search API
    q = v: '1.0', rsz: '8', q: query, safe: 'active'
    msg.http('https://ajax.googleapis.com/ajax/services/search/books')
      .query(q)
      .get() (err, res, body) ->
        if err
          msg.send "Encountered an error :( #{err}"
          return
        if res.statusCode isnt 200
          msg.send "Bad HTTP response :( #{res.statusCode}"
          return
        books_resp = JSON.parse(body)
        msg.robot.logger.info books_resp
        books = books_resp.responseData?.results
        msg.robot.logger.info books
        if books?.length > 0

          resp_string = ''
          resp_string_header = "Books Results Found\n==============\n"
          for result in books
            resp_string += result.titleNoFormatting + "\n" + result.unescapedUrl + "\n\n"
          msg.send resp_string_header + resp_string

  robot.respond /(web)( me)? (.*)/i, (msg) ->
    query = msg.match[3]
    # Using deprecated Google image search API
    q = v: '1.0', rsz: '8', q: query, safe: 'active'
    msg.http('https://ajax.googleapis.com/ajax/services/search/web')
      .query(q)
      .get() (err, res, body) ->
        if err
          msg.send "Encountered an error :( #{err}"
          return
        if res.statusCode isnt 200
          msg.send "Bad HTTP response :( #{res.statusCode}"
          return
        web_resp = JSON.parse(body)
        msg.robot.logger.info web_resp
        results = web_resp.responseData?.results
        if results?.length > 0
          resp_string = ''
          resp_string_header = "Web Results Found\n==============\n"
          for result in results
            resp_string += result.titleNoFormatting + "\n" + result.unescapedUrl + "\n\n"
          msg.send resp_string_header + resp_string











