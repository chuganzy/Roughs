express = require("express")
router = express.Router()
FlintoAPIManager = require("../common/FlintoAPIManager")
RoughsError = require("../common/RoughsError")
Project = require("../common/Project")

router.route("/projects/all").get((req, res, next) ->
  Project.find({}).sort("-registered_at").select("id title project_url icon_url creators registered_at device").exec((error, docs) ->
    if error
      next(error)
      return
    res.json(docs)
  )
)

router.route("/projects/:id").get((req, res, next) ->
  id = req.params.id
  if isNaN(id)
    next(RoughsError.INVALID_PROJECT_ID)
    return
  Project.findOne({
      id: id
  }, (error, doc) ->
    if error
      next(error)
      return
    if !doc
      next(RoughsError.PROJECT_NOT_FOUND)
      return
    res.json(doc)
  )
).delete((req, res, next) ->
  id = req.params.id
  if isNaN(id)
    next(RoughsError.INVALID_PROJECT_ID)
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
    next(RoughsError.INVALID_PROJECT_URL)
    return
  projectURL = FlintoAPIManager.modifyFlintoProjectURL(projectURL)

  Project.findOne({
      project_url: projectURL
  }, (error, doc) ->
    if doc
      next(RoughsError.PROJECT_ALREADY_EXIST)
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
  res.json(err)
).use((req, res, next) ->
  err = RoughsError.INVALID_API_METHOD
  res.status(err.status)
  res.json(err)
)

module.exports = router
