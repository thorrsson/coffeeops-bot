
# Description:
#   google books search script
#
# Dependencies:
#
# Configuration:
#   None
#
# Commands:
#   hubot book me <keywords>
#
# Author:
#   Tim Hunter <tim@thunter.ca>
#

module.exports = (robot) ->
  googleApiKey = process.env.HUBOT_GOOGLE_TOKEN
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

          resp_string_header = "Books Found\n==============\n"
          resp_string = ("#{book.titleNoFormatting} :> #{shortenURL(book.unescapedUrl, msg)} \n" for book in books)
          msg.robot.logger.info resp_string
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
        msg.robot.logger.info results
        if results?.length > 0

          resp_string_header = "Web Results Found\n==============\n"
          resp_string = ("#{result.titleNoFormatting}  :>> \n      #{shortenURL(result.unescapedUrl, msg)} \n" for result in results)
          msg.robot.logger.info resp_string_header + resp_string
        msg.send resp_string_header + resp_string



shortenURL = (url, msg) ->
  data = "{\"longUrl\": \"#{url}\"}"
  googleApiKey = process.env.HUBOT_GOOGLE_TOKEN
  msg.http("https://www.googleapis.com/urlshortener/v1/url?key=" + googleApiKey)
    .header('Content-Type', 'application/json')
    .post(data) (err, res, body) ->
      if err
        msg.send "Encountered an error :( #{err}"
        return
      if res.statusCode isnt 200
        msg.send "Bad HTTP response :( #{res.statusCode}"
        return

      resp_hash = JSON.parse(body)
      resp_hash.id






