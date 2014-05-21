# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#= require fading_colored_rows
$ ->
  $("a.edit-btn").click ->
    row_tr = $(this).parents("tr")
    row_tr.find(".edit-field,.update-btn").show()
    row_tr.find(".data-field").hide()
    row_tr.find(".memo-link").removeAttr("disabled")
    row_tr.find(".icon-field").each () ->
      $(this).children("a").children().toggleClass("hidden")
    $(this).toggle()
  $("button.memo-submit").click ->
    $(this).text($(this).data("disable-with")).attr("disabled", true)
    modal_number = $(".modal.in").attr("id").split("_")[1]
    $("tr").eq(modal_number).find("input[type=hidden]").val($(".modal.in textarea[name=memo-field]").val())
  $("input[type=submit]").click ->
    $('input[name=_method]').val($(this).data("method")) if $(this).data("method")
    $('form').attr('action',$(this).data("form-action")) if $(this).data("form-action")
  $("textarea[name=memo-field]").each ->
    modal_number = $(this).parents("div.modal").attr("id").split("_")[1]
    $(this).val( $("tr").eq(modal_number).find("input[type=hidden]").val())
  $("textarea[name=memo-field]").on "keyup", ->
    $(this).parent().siblings().find("button.memo-submit").text("Save").removeAttr("disabled")
  $(".project-dropdown").on "change", ->
    set_team_leads($(this))
  $(".modal").on "shown.bs.modal", ->
    $(this).find("textarea").trigger('autosize.resize')
  $(".memo-info").popover()
  set_team_leads($(".project-dropdown:last"))

set_team_leads = ($project_dropdown_obj) ->
  $team_leads_select = $project_dropdown_obj.parents("tr").find(".lead-dropdown")
  if $project_dropdown_obj.val() == ""
    $team_leads_select.empty()
    $team_leads_select.attr("disabled", true)
    return true
  $.getJSON "/projects/#{$project_dropdown_obj.val()}/leads.json", (data) ->
    $team_leads_select.empty()
    $team_leads_select.append('<option value></option>')
    if data.length == 0
      $team_leads_select.attr("disabled", true)
      return true
    for lead in data
      name = lead.display_name
      $team_leads_select.append("<option value=\"#{lead.id}\">"+name+'</option>')
    $team_leads_select.removeAttr("disabled")
