express = require("express")
router = express.Router()
mongoose = require("mongoose")
Schema = mongoose.Schema
FlintoAPIManager = require("../common/FlintoAPIManager")
RoughsError = require("../common/RoughsError")

projectScheme = new Schema({
  id: Number
  title: String
  project_url: String
  registered_at: Number
}, {
  strict: false
})
Project = mongoose.model("Project", projectScheme)
mongoose.connect(require("../info.json").mongo_db_uri)

router.route("/projects/all").get((req, res, next) ->
  Project.find({}).sort("-registered_at").select("-screens").exec((error, docs)->
    if error
      next(error)
      return
    res.json(docs)
  )
)

router.route("/projects/:id").get((req, res, next) ->
  id = req.params.id
  if isNaN(id)
    next(new RoughsError("INVALID_PROJECT_ID"))
    return
  Project.findOne({
      id: id
  }, (error, doc) ->
    if error
      next(error)
      return
    if !doc
      next(new RoughsError("PROJECT_NOT_FOUND"))
      return
    res.json(doc)
  )
).delete((req, res, next) ->
  id = req.params.id
  if isNaN(id)
    next(new RoughsError("INVALID_PROJECT_ID"))
    return
  Project.remove({
      id: id
  }, (error, docs) ->
    res.json(docs)
  )
)

router.route("/projects").post((req, res, next) ->
  projectURL = req.body.project_url
  if !projectURL
    next(new RoughsError("INVALID_PROJECT_URL"))
    return
  projectURL = FlintoAPIManager.modifyFlintoProjectURL(projectURL)

  Project.findOne({
      project_url: projectURL
  }, (error, doc) ->
    if doc
      next(new RoughsError("PROJECT_ALREADY_EXISTS"))
      return
    FlintoAPIManager.getProjectObject(projectURL, (object, error) ->
      if error
        next(error)
        return
      object["registered_at"] = Math.floor((new Date()).getTime() / 1000)
      project = new Project(object)
      project.save((error) ->
        if error
          next(error)
          return
        res.json(object)
      )
    )
  )
)

router.use((err, req, res, next) ->
  res.status(err.status)
  res.json({
    name: err.message
  })
).use((req, res, next) ->
  res.status(404)
  res.json({
    name: "API_METHOD_NOT_FOUNT"
  })
)

module.exports = router
