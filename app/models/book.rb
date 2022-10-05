class Book < ApplicationRecord
  belongs_to :user
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :tags, dependent: :destroy

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def self.search_for(content, method)
    if method == 'perfect'
      Book.where(title: content)
    elsif method == 'forward'
      Book.where('title LIKE ?', content+'%')
    elsif method == 'backward'
      Book.where('title LIKE ?', '%'+content)
    else
      Book.where('title LIKE ?', '%'+content+'%')
    end
  end

  scope :latest, -> {order(created_at: :desc)}
  scope :rate_count, -> {order(rate: :desc)}
  
  def save_with(tag_names)
  ActiveRecord::Base.transaction do
    self.book_tags = tag_names.map { |name| Tag.find_or_initialize_by(name: name.strip) }
    save!
  end
  true

  rescue StandardError
  false
  end


end

