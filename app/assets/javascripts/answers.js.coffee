# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  editAnswer = (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).toggle();

  $('.answers').on 'click', '.edit-answer-link', editAnswer;

  App.cable.subscriptions.create('AnswersChannel', {
    connected: ->
      console.log 'Connected!';
      @perform 'follow'
      console.log 'follow'
    received: (data) ->
      $('.answers').append(data)
  })