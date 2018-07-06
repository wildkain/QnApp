# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  addComment = (e) ->
    e.preventDefault();
    $(this).hide();
    resource_id = $(this).data('resourceId');
    resource_type = $(this).data('resourceType');
    $('.comments_form_for_'+ resource_type).show();
  $('.question-block').on 'click', '.comment-link', addComment;

  submitComment = (e) ->
    $(this).hide();
    $('.comment-link').show();
    resource_id = $(this).data('resourceId');
    resource_type = $(this).data('resourceType');
  $('.new_comment').on 'submit', '.submit-comment', submitComment;

  editComment = (e) ->
    e.preventDefault();
    $(this).hide();
    comment_id = $(this).data('commentId')
    console.log(comment_id);
    $('form#edit_comment_'+comment_id).show();

  $('.comment').on 'click', '#edit-comment', editComment;


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