// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.


$(document).ready(function(){
  add_option_listeners()

  $(".edit_scq_btn").on("click", function(){
    $(this).parent().parent().parent().find(".hidden_scq_text_edit").css("display", 'initial');
    // $(".hidden_scq_text_edit").css("display", "initial")
  })

  $(".old-question-modal-link").on("click", function(){
    console.log($(this).parent().find(".hidden").html());
    $("#main-modal-body").html("").html($(this).parent().find(".hidden").html())
  })

})

function fill_topic_options (options){
  var element = $("#filterrific_with_topic_id").html("<option value>- Any -</option>");
  for (var i=0; i<options.length; i++){
    $('<option/>' ,{
      'value' : options[i][1],
      'html'  : options[i][0],
    }).appendTo($(element))
  }
}

function fill_chapter_options (options) {
  var element = $("#filterrific_with_chapter_id").html("<option value>- Any -</option>");
  for (var i=0; i<options.length; i++){
    $('<option/>' ,{
      'value' : options[i][1],
      'html'  : options[i][0],
    }).appendTo($(element))
  }
}

function fill_subject_options (options) {
  var element = $("#filterrific_with_subject_id").html("<option value>- Any -</option>");
  for (var i=0; i<options.length; i++){
    $('<option/>' ,{
      'value' : options[i][1],
      'html'  : options[i][0],
    }).appendTo($(element))
  }
}

function get_chapter_topics (chapter_id) {
  $.ajax({
    url: '/chapters/'+chapter_id+'/get_topics_list.json',
    dataType: 'json',
    type: 'GET',
    success: function(data){
      test(data)
      fill_topic_options(data)
    }
  });
}

function get_subject_chapters (subject_id) {
  $.ajax({
    url: '/subjects/'+subject_id+'/get_chapters_list.json',
    type: 'GET',
    dataType: 'json',
    success: function(data){
      fill_chapter_options(data)
    }
  });
}

function get_standard_subjects (standard_id) {
  $.ajax({
    url: '/standards/'+standard_id+'/get_subjects_list.json',
    type: 'GET',
    dataType: 'json',
    success: function(data){
      fill_subject_options(data)
    }
  });
}

function add_option_listeners (){

  $('#filterrific_with_standard_id').on('change', function(){
    get_standard_subjects($(this).val())
  });

  $('#filterrific_with_chapter_id').on('change', function(){
    get_chapter_topics($(this).val())
  });

  $('#filterrific_with_subject_id').on('change', function(){
    get_subject_chapters($(this).val())
  });
}