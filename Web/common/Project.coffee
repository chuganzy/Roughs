mongoose = require("mongoose")
Schema = mongoose.Schema

projectScheme = new Schema({
  id: Number
  title: String
  project_url: String
  icon_url: String
  creators: [String]
  registered_at: Number
  device: String
}, {
  strict: false
  toObject: {
    virtuals: true
  }
  toJSON: {
    virtuals: true
  }
})

projectScheme.virtual('user_agent').get(->
  device = @.device
  if device.match(/android/)
    return "Mozilla/5.0 (Linux; Android 4.4.4; Nexus 5 Build/KTU84P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/38.0.2125.114 Mobile Safari/537.36"
  if device.match(/ipad/)
    return "Mozilla/5.0 (iPad; CPU OS 8_1 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Version/8.0 Mobile/12B410 Safari/600.1.4"
  return "Mozilla/5.0 (iPhone; CPU iPhone OS 8_1 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Version/8.0 Mobile/12B410 Safari/600.1.4"
)

Project = mongoose.model("Project", projectScheme)

module.exports = Project
