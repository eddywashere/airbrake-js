jsonifyNotice = require('../util/jsonify_notice.coffee')


cbCount = 0

report = (notice, opts) ->
  cbCount++

  cbName = "airbrakeCb" + String(cbCount)
  global[cbName] = (resp) ->
    if console?.debug?
      console.debug("airbrake: error #%s was reported: %s", resp.id, resp.url)
    delete global[cbName]

  payload = encodeURIComponent(jsonifyNotice(notice))
  url = "https://api.airbrake.io/api/v3/projects/#{opts.projectId}/create-notice?key=#{opts.projectKey}&callback=#{cbName}&body=#{payload}"

  document = global.document
  head = document.getElementsByTagName('head')[0]
  script = document.createElement('script')
  script.src = url
  removeScript -> head.removeChild(script)
  script.onload = removeTag
  script.onerror = removeTag

  head.appendChild(script_tag);


module.exports = report
