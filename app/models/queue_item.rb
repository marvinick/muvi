class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  delegate :category, to: :video # for a method def category
  delegate :title, to: :video, prefix: :video # for a method def video_title


  def rating
    review = Review.where(user_id: user.id, video_id: video.id).first
    review.rating if review
  end

  def category_name
    category.name # derived from def category
  end
end