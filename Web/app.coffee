class AppManager
    express = require("express")
    constructor: ->

    setup: ->
        @app = express()
        @_setupModules()
        @_setupRoutes()
        @_setupErrors()

    _setupModules: ->
        path = require("path")
        favicon = require("serve-favicon")
        logger = require("morgan")
        cookieParser = require("cookie-parser")
        bodyParser = require("body-parser")
        compression = require("compression")

        app = @app
        app.set("views", path.join(__dirname, "views"))
        app.set("view engine", "jade")
#        app.use(favicon(__dirname + "/public/favicon.ico"));
        app.use(compression());
        app.use(logger("dev"));
        app.use(bodyParser.json());
        app.use(bodyParser.urlencoded({
            extended: true
        }))
        app.use(cookieParser());
        app.use(express.static(path.join(__dirname, "public")))

        info = require("./info.json")
        if info.basic_auth
            username = info.basic_auth.username
            password = info.basic_auth.password
            if username.length and password.length
                basicAuth = require("basic-auth-connect")
                app.use(basicAuth(username, password))

    _setupRoutes: ->
        routes = require("./routes/index")
        api = require("./routes/api")
        app = @app
        app.use("/", routes)
        app.use("/api/1", api)

    _setupErrors: ->
        app = @app
        app.use((req, res, next) ->
            err = new Error("Not Found")
            err.status = 404
            next(err)
        )

        app.use((err, req, res, next) ->
            res.status(err.status or 500)
            res.render("error", {
                title: require("./info.json").title
                message: err.message
                error: if app.get("env") is "development" then err else {}
            })
        )

appManager = new AppManager()
appManager.setup()

module.exports = appManager.app
