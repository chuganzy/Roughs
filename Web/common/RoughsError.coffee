class RoughsError
    @:: = new Error()
    @::constructor = @
    constructor: (@message) ->
        @status = 400

module.exports = RoughsError
