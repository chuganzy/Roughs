RoughsError = require("./RoughsError")

class FlintoAPIManager
  FLINTO_BASE_URL = "https://www.flinto.com"

  @isFlintoProjectURL: (url) ->
    regexp = new RegExp("^#{FLINTO_BASE_URL}/p/", "i")
    return regexp.test(url)

  @modifyFlintoProjectURL: (url) ->
    url = url.replace(/\/+$/, "")
    return url

  @getProjectObject: (url, handler) ->
    INVALID_PROJECT_URL_ERROR = new RoughsError("INVALID_PROJECT_URL")
    if !FlintoAPIManager.isFlintoProjectURL(url)
      handler(null, INVALID_PROJECT_URL_ERROR)
      return
    request = require("request")
    request.get({
        url: url
    }, (error, response, body) ->
      if error
        handler(null, error)
        return
      cheerio = require("cheerio")
      $ = cheerio.load(body)
      script = $("body script").first().text().trim()
      script = script.match(/\/{2}<!\[CDATA\[[\s\n]+var\s+\w+\s*=\s*([\S\s]*);[\s\n]+\/{2}]{2}>$/i)
      if !script or script.length < 1
        handler(null, INVALID_PROJECT_URL_ERROR)
        return
      string = script[1]
      # TODO: make more strictly
      string = string.replace(/"((\/prototypes\/[^"]+)|(\/assets\/[^"]+))"/ig, "\"#{FLINTO_BASE_URL}$1\"")
      object = JSON.parse(string)
      object.project_url = url
      handler(object, null)
    )
module.exports = FlintoAPIManager
