'use strict'

###*
 # @ngdoc service
 # @name blicblockApp.notification
 # @description
 # # notification
 # Service in the blicblockApp.
###
angular.module('blicblockApp')
  .service 'Notification', ['$timeout', ($timeout) ->
    class Notification
      constructor: ->
        @notices = []
        @errors = []

      wipe_notices: ->
        @remove('notice', notice.id) for notice in @notices

      wipe_errors: ->
        @remove('error', error.id) for error in @errors

      wipe_notifications: ->
        @wipe_notices()
        @wipe_errors()

      remove: (type, id) ->
        if type == 'error'
          @errors.splice(idx, 1) for idx, error of @errors when error.id == id
        else
          @notices.splice(idx, 1) for idx, notice of @notices when notice.id == id

      error: (message) ->
        return unless message
        console.error message
        id = @errors.length + 1
        @errors.push
          message: message
          id: id
        $timeout (=> @remove('error', id)), 3500

      notice: (message) ->
        return unless message
        id = @notices.length + 1
        @notices.push
          message: message
          id: id
        $timeout (=> @remove('notice', id)), 3500

    new Notification()
  ]
