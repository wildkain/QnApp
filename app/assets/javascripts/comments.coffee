# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  App.cable.subscriptions.create({ channel: 'CommentsChannel', question_id: gon.question_id }, {
    connected: ->
      console.log 'Connected!';
      @perform 'follow'
      console.log 'CommentChannel connected!'
    received: (data) ->
      commentable_type = $.parseJSON(data['comment']).commentable_type.toLowerCase()
      commentable_id = $.parseJSON(data['comment']).commentable_id
      $('.comments').append(JST["templates/comment"](comment: $.parseJSON(data['comment'])))
  })