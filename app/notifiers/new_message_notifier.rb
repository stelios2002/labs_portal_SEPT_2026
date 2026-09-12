# To deliver this notification:
#
# NewMessageNotifier.with(record: @post, message: "New post").deliver(User.all)

class NewMessageNotifier < Noticed::Event
  deliver_by :action_cable do |config|
    config.channel = "NotificationsChannel"
    config.stream = ->{ recipient }
    config.message = -> { { text: message_text } }
  end

  notification_methods do
    def message_text
      "#{params[:message].user.name}: #{params[:message].body.truncate(50)}"
    end
  end
end
