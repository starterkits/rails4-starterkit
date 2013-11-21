# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file.
#
# Read Sprockets README (https:#github.com/sstephenson/sprockets#sprockets-directives) for details
# about supported directives.
#
#= require jquery_2
#= require jquery_ujs
#= require bootstrap
#= require jquery.turbolinks
#= require turbolinks
#= require nprogress
#= require nprogress-turbolinks
#= require rails_confirm_dialog

# Add error class to .avatar images if they fail to load
# See avatar.scss and _avatar.html.haml
#= require imagesloaded
#= require avatar.errors
