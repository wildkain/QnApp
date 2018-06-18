# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on('turbolinks:load', ->
  editQuestion = (e) ->
    e.preventDefault();
    $(this).hide();
    question_id = $(this).data('questionId')
    $('.edit-question-form').toggle();

  $('.question-block').on 'click', '.edit-question-link', editQuestion

)