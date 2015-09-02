class Picture < ActiveRecord::Base

  has_attached_file :picture, styles: {large: "1000x1000", medium: "675x675", small: "500x500", thumb: "200x200>"}
  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\Z/

  has_many :comments, dependent: :destroy

  belongs_to :user

  validates :description, presence: true
  validates_attachment_presence :picture

end
