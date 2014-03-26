window.Projects = new Meteor.Collection("Projects")
window.Tasks = new Meteor.Collection("Tasks")
ngMeteor = Package.ngMeteor.ngMeteor


ngMeteor.controller 'TodoCtrl', ['$scope', '$collection', '$ionicModal', '$rootScope', '$ionicSideMenuDelegate', '$ionicPopup',
  ($scope, $collection, $ionicModal, $rootScope, $ionicSideMenuDelegate, $ionicPopup) ->

    # Load or initialize projects
    $collection("Projects", $scope)
    $collection("Tasks", $scope)

    # A utility function for creating a new project
    # with the given projectTitle
    createProject = (projectTitle)->
      newProject =
        title: projectTitle
        active: false
      $scope.Projects.add(newProject)
      $scope.selectProject(newProject, $scope.Projects.length - 1)

    # Called to create a new project
    $scope.newProject = ()->
      $ionicPopup.prompt(
        title: 'New Project'
        subTitle: 'Name'
      ).then((res)->
        createProject(res) if res
      )

    # Grab the last active, or the first project
    $scope.activeProject = ()->
      activeProject = $scope.Projects[0]
      angular.forEach $scope.Projects, (v, k)->
        if v.active
          activeProject = v
      return activeProject

    # Called to select the given project
    $scope.selectProject = (project, index)->
      selectedProject = $scope.Projects[index]
      angular.forEach $scope.Projects, (v, k)->
        v.active = false
      selectedProject.active = true
      $scope.Projects.add($scope.Projects)
      $ionicSideMenuDelegate.toggleLeft()

    # Create our modal
    $ionicModal.fromTemplateUrl 'new-task', (modal)->
      $scope.taskModal = modal
    ,
      scope: $scope
      animation: 'slide-in-up'

    $scope.openModal = ->
      $scope.modal.show()
    $scope.closeModal = ->
      $scope.modal.hide()

    #Cleanup the modal when we're done with it!
    $scope.$on '$destroy', ->
      $scope.taskModal.remove()

    $scope.createTask = (task)->
      activeProject = $scope.activeProject()
      return if !activeProject || !task

      $scope.Tasks.add
        project: activeProject._id
        title: task.title

      $scope.taskModal.hide()

      task.title = ""

    $scope.deleteTask = (task)->
      $scope.Tasks.delete(task)

    $scope.newTask = ->
      $scope.taskModal.show()

    $scope.closeNewTask = ->
      $scope.taskModal.hide()

    $scope.toggleProjects = ->
      $ionicSideMenuDelegate.toggleLeft()

    # Try to create the first project, make sure to defer
    # this by using $timeout so everything is initialized
    # properly   
    $scope.Projects.ready ->
      if $scope.Projects.length == 0
        while true
          projectTitle = prompt('Your first project title:')
          if projectTitle
            createProject projectTitle
            break
]
