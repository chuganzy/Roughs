express = require("express")
router = express.Router()
router.get("/", (req, res) ->
    info = require("../info.json")
    res.render("index", {
        title: info.title
    })
)
module.exports = router
