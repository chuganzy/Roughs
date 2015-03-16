// Generated by CoffeeScript 1.8.0
(function() {
  var app;

  app = angular.module("Roughs", ["ngDialog"]);

  app.config(function(ngDialogProvider) {
    return ngDialogProvider.setDefaults({
      showClose: false,
      className: 'ngdialog-theme-default ngdialog-theme-roughs'
    });
  });

  app.controller("ProjectListController", function($scope, $http, ngDialog) {
    $http.get("/api/1/projects/all").success(function(data, status, headers, config) {
      return $scope.projects = data;
    });
    $scope.confirmDelete = function(index) {
      var dialog, targetProject;
      targetProject = $scope.projects[index];
      dialog = ngDialog.open({
        data: {
          title: "Delete Project",
          message: "Are you sure delete “" + targetProject["title"] + "” from the list?",
          okButtonTitle: "Delete"
        },
        template: "/template/AlertDialog.tmpl.html"
      });
      return dialog.closePromise.then(function(data) {
        if (!data.value || data.value === "$document") {
          return;
        }
        return $http["delete"]("/api/1/projects/" + targetProject["id"]).success(function(data, status, headers, config) {
          return $scope.projects.splice(index, 1);
        });
      });
    };
    return $scope.newProject = function() {
      var dialog;
      dialog = ngDialog.open({
        data: {
          title: "New Project",
          praceholder: "Flinto Project URL",
          okButtonTitle: "Register"
        },
        template: "/template/InputDialog.tmpl.html"
      });
      return dialog.closePromise.then(function(data) {
        if (!data.value || data.value === "$document") {
          return;
        }
        return $http.post("/api/1/projects", {
          "project_url": data.value
        }).success(function(data, status, headers, config) {
          return $scope.projects.splice(0, 0, data);
        });
      });
    };
  });

}).call(this);

//# sourceMappingURL=app.js.map
