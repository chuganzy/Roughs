class RoughsError
    @:: = new Error()
    @::constructor = @
    constructor: (@name, @status = 400) ->

RoughsError.INVALID_API_METHOD = new RoughsError("INVALID_API_METHOD", 404)
RoughsError.INVALID_PROJECT_ID = new RoughsError("INVALID_PROJECT_ID")
RoughsError.INVALID_PROJECT_URL = new RoughsError("INVALID_PROJECT_URL")
RoughsError.PROJECT_NOT_FOUND = new RoughsError("PROJECT_NOT_FOUND")
RoughsError.PROJECT_ALREADY_EXIST = new RoughsError("PROJECT_ALREADY_EXIST")

module.exports = RoughsError
