$(document).on('turbolinks:load', ->

  $('.vote').bind 'ajax:success', (e) ->

    $(this).parent().parent().parent().find('.vote_counter').html(e.detail[0])
    $(this).parent().parent().parent().find('.vote_error').html('')
  $('.vote').bind 'ajax:error', (e) ->
    $(this).parent().parent().parent().find('.vote_error').html(e.detail[0])
)