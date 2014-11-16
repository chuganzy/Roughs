app = angular.module("Roughs", ["ngMaterial"])
app.controller("ProjectListController",
    ["$scope", "$http", "$mdDialog", "$mdToast", ($scope, $http, $mdDialog, $mdToast) ->
        showErrorDialog = (data) ->
            $mdDialog.show({
                templateUrl: "/components/ErrorDialog.tmpl.html"
                controller: "ErrorDialogController"
                locals: {
                    data: data
                }
            })
        $scope.projects = []
        $scope.postProject = (pURL) ->
            $http.post("/api/projects", {
                "project_url": pURL
            }).success((data, status, headers, config) ->
                $mdToast.show({
                    template: "<md-toast>Added \"#{data["title"]}\"</md-toast>"
                })
                $scope.projects.splice(0, 0, data)
            ).error((data, status, headers, config) ->
                showErrorDialog(data)
            )
        $scope.deleteProject = ($event, $index) ->
            $event.stopPropagation()
            $mdDialog.show({
                targetEvent: $event
                templateUrl: "/components/ComfirmDialog.tmpl.html"
                controller: "ConfirmDialogController"
                locals: {
                    title: "Remove Project"
                    message: "Are you sure remove this project?"
                }
            }).then(->
                console.log arguments
                project = $scope.projects[$index]
                $http.delete("/api/projects/#{project["id"]}").success((data, status, headers, config) ->
                    $mdToast.show({
                        template: "<md-toast>Removed \"#{project["title"]}\"</md-toast>"
                    })
                    $scope.projects.splice($index, 1)
                ).error(->
                    showErrorDialog(data)
                )
            , ->
                console.log arguments
            )
        $scope.openProject = ($index) ->
            project = $scope.projects[$index]
            window.open(project["project_url"], "_blank")
        $http.get("/api/projects/all").success((data, status, headers, config) ->
            $scope.projects = data
        ).error(->
            $mdDialog.show()
        )
    ])
app.controller("ConfirmDialogController", ($scope, $mdDialog, title, message) ->
    $scope.title = title
    $scope.message = message
    $scope.ok = ->
        $mdDialog.hide()
    $scope.cancel = ->
        $mdDialog.cancel()
)
app.controller("ErrorDialogController", ($scope, $mdDialog, data) ->
    $scope.message = data.name
    $scope.ok = ->
        $mdDialog.cancel()
)
