class User < ActiveRecord::Base
  include Tokenable

  validates_presence_of :email, :password, :full_name
  validates_uniqueness_of :email

  has_many :reviews, -> { order("created_at DESC") }

  has_secure_password validations: false

  has_many :queue_items, -> { order(:position) }
  has_many :following_relationships, class_name: "Relationship", foreign_key: :follower_id
  has_many :leading_relationships, class_name: "Relationship", foreign_key: :leader_id

  def normalize_queue_item_position
    queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes(position: index+1)
    end
  end

  def queued_video?(video)
    queue_items.map(&:video).include?(video)
  end

  def follows?(other_user)
    following_relationships.map(&:leader).include?(other_user)
  end

  def follow(other_user)
    following_relationships.create(leader: other_user) if can_follow?(other_user)
  end

  def can_follow?(other_user)
    !(self.follows?(other_user) || self == other_user)
  end

  def deactivate!
    update_column(:active, false)
  end
end