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
      script = script.match(/\/{2}<\!\[CDATA\[([\S\s]*)\/{2}\]{2}>$/i)
      if !script
        handler(null, INVALID_PROJECT_URL_ERROR)
        return
      script = script[0]
      eval(script)
      if !flviewerPrototypeBootstrapData
        handler(null, INVALID_PROJECT_URL_ERROR)
        return
      string = JSON.stringify(flviewerPrototypeBootstrapData)
      # TODO: make more strictly
      string = string.replace(/"(\/prototypes\/[^"]+)"/ig, "\"#{FLINTO_BASE_URL}$1\"")
      string = string.replace(/"(\/assets\/[^"]+)"/ig, "\"#{FLINTO_BASE_URL}$1\"")
      object = JSON.parse(string)
      object.project_url = url
      handler(object, null)
    )
module.exports = FlintoAPIManager
