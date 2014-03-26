class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  delegate :category, to: :video # for a method def category
  delegate :title, to: :video, prefix: :video # for a method def video_title

  validates_numericality_of :position, {only_integer: true}

  def rating
    review = Review.where(user_id: user.id, video_id: video.id).first
    review.rating if review
  end

  def rating=(new_rating)
    review = Review.where(user_id: user.id, video_id: video.id).first
    if review
      review.update_column(:rating, new_rating)
    else
      review = Review.new(user: user, video: video, rating: new_rating)
      review.save(validate: false)
    end
  end

  def category_name
    category.name # derived from def category
  end
end