Projects = new Meteor.Collection("Projects")
Tasks = new Meteor.Collection("Tasks")

Meteor.publish 'Projects', ->
  Projects.find({})

Meteor.publish 'Tasks', ->
  Tasks.find({})

Projects.allow
  insert: ->
    true
  update: ->
    true
  remove: ->
    true

Tasks.allow
  insert: ->
    true
  update: ->
    true
  remove: ->
    true
