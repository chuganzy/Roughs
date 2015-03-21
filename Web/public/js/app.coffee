app = angular.module("Roughs", ["ngDialog"])

class AppConfig
  constructor: ($compileProvider, ngDialogProvider) ->
    $compileProvider.debugInfoEnabled(false)
    ngDialogProvider.setDefaults({
      showClose: false
      className: 'ngdialog-theme-default ngdialog-theme-roughs'
    })

class ProjectListController
  constructor: (@$scope, @$http, @ngDialog) ->
    @_setUpScope()
    @_getAllProjects()

  _setUpScope: ->
    $scope = @$scope
    $http = @$http
    ngDialog = @ngDialog

    $scope.confirmDelete = (index) ->
      targetProject = $scope.projects[index]
      dialog = ngDialog.open({
        data: {
          title: "Delete Project"
          message: "Are you sure you want to delete “#{targetProject["title"]}” from the list?"
          okButtonTitle: "Delete"
        }
        template: "/template/AlertDialog.tmpl.html"
      })
      dialog.closePromise.then((data) ->
        if (!data.value or data.value is "$document")
          return
        $http.delete("/api/1/projects/#{targetProject["id"]}").success((data, status, headers, config) ->
          $scope.projects.splice(index, 1)
        )
      )

    $scope.newProject = ->
      dialog = ngDialog.open({
        data: {
          title: "New Project"
          placeholder: "Flinto Project URL"
          okButtonTitle: "Register"
        }
        template: "/template/InputDialog.tmpl.html"
      })
      dialog.closePromise.then((data) ->
        if (!data.value or data.value is "$document")
          return
        $http.post("/api/1/projects", {
          "project_url": data.value
        }).success((data, status, headers, config) ->
          $scope.projects.splice(0, 0, data)
        )
      )

  _getAllProjects: ->
    @$http.get("/api/1/projects/all").success((data, status, headers, config) =>
      @$scope.projects = data
    )

app.config(["$compileProvider", "ngDialogProvider", AppConfig])
app.controller("ProjectListController", ["$scope", "$http", "ngDialog", ProjectListController])
