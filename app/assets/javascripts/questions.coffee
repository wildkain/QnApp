# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  editQuestion = (e) ->
    e.preventDefault();
    $(this).hide();
    question_id = $(this).data('questionId')
    $('.edit-question-form').toggle();

  $('.question-block').on 'click', '.edit-question-link', editQuestion

  App.cable.subscriptions.create('QuestionsChannel', {
    connected: ->
      @perform 'follow'
    ,

    received: (data) ->
      alert data
  })

