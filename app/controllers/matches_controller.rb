class MatchesController < ApplicationController
  before_action :authenticate_user!

  def index
    my_course_ids = current_user.course_ids
    my_interest_ids = current_user.interest_ids

    @matches = User.where.not(id: current_user.id)
                    .left_joins(:enrollments, :user_interests)
                    .where(
                      "enrollments.course_id IN (:courses) OR user_interests.interest_id IN (:interests)",
                      courses: my_course_ids.presence || [0],
                      interests: my_interest_ids.presence || [0]
                    )
                    .distinct
  end
end