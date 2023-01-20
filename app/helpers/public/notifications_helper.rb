module Public::NotificationsHelper

  def unchecked_notifications
    @notifications=current_user.passive_notifications.where(checked: false)
  end

  def notification_form(notification)
    @post_comment = nil
    visitor = link_to notification.visitor.name, notification.visitor, style:"font-weight: bold;"
    your_post = link_to 'あなたの投稿', notification.post, style:"font-weight: bold;", remote: false
    
    case notification.action
      when "follow" then
        "#{visitor}があなたをフォローしました"
      when "favorite" then
        "#{visitor}が#{your_post}にいいね！しました"
      when "post_comment" then
        @post_comment=PostComment.find_by(id:notification.comment_id)&.content
        "#{visitor}が#{your_post}にコメントしました"
    end
  end

end
