class Post < ApplicationRecord
  
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :hashtag_posts, dependent: :destroy
  has_many :hashtags, through: :hashtag_posts

  
  validates :body,presence:true,length:{maximum:200}
  
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
  
  after_create do 
      post = Post.find_by(id: id)
      hashtags = hashbody.scan(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/)
      hashtags.uniq.map do |hashtag|
        tag = Hashtag.find_or_create_by(hashname: hashtag.downcase.delete('#'))
        post.hashtags << tag
    end
  end
  
  before_update do
      post = Post.find_by(id: id)
      post.hashtags.clear
      hashtags = hashbody.scan(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/)
      hashtags.uniq.map do |hashtag|
        tag = Hashtag.find_or_create_by(hashname: hashtag.downcase.delete('#'))
        post.hashtags << tag
      end
  end
  
end
