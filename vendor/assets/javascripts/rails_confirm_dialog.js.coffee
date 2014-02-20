#
# Rails 3+ with Twitter Bootstrap 2+ or Zurb Foundation 5+ Confirm Dialog Modal
# version 0.3
# (c) 2014 joe johnston [joe@simple10.com]
# released under the MIT license
#
# Dependencies:
#   jQuery
#
# Overview:
#   Override $.rails.allowAction to intercept clicked elements with data-confirm. If message is an object, use
#   jQuery.tmpl to populate and open a jQuery UI dialog. If message is a string, open a genric jQuery UI dialog.
#
# Example with Haml + Bootstrap 3:
#  = link_to 'Delete Account', destroy_user_path(current_user), data: { confirm: 'Are you sure?', confirm_modal: '#delete-user-modal' }, method: :delete
#  #delete-user-modal.modal.fade{tabindex: -1, role: 'dialog', 'aria-labelledby' => 'delete-user-modal-title', 'aria-hidden' => true}
#    .modal-dialog
#      .modal-content
#        .modal-header
#          %button.close{data: {dismiss: 'modal'}, 'aria-hidden' => true} &times;
#          %h4#delete-user-modal-title Are you sure?
#        .modal-body
#          %span.label.label-danger Warning
#          This cannot be undone.
#        .modal-footer
#          %button.btn.btn-danger{data: {confirm: 'true', dismiss: 'modal'} Yes, delete my account
#          %button.btn.btn-default{data: {dismiss: 'modal'}} Cancel

Confirm =
  initRailsHook: ->
    $.rails.allowAction = (elem) =>
      @allowAction(elem)

  allowAction: (elem) ->
    modal = elem.data('confirm-modal')
    return true unless modal
    $modal = $(modal)
    if $modal && $.rails.fire(elem, 'confirm')
      @showModal($modal, elem)
    return false

  confirmed: (elem) ->
    if $.rails.fire(elem, 'confirm:complete', [true])
      $.rails.allowAction = -> true
      elem.trigger('click')
      $.rails.allowAction = @allowAction

  showModal: ($modal, elem) ->
    if $modal.hasClass 'reveal-modal'
      # Foundation
      $modal.foundation 'reveal', 'open'
      $modal.find('[data-dismiss]').on('click', => $modal.foundation 'reveal', 'close')
    else
      # Bootstrap
      $modal.modal()
    $modal.find('[data-confirm]').on('click', => @confirmed(elem))

$ -> Confirm.initRailsHook()
