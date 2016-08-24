class Note < ActiveRecord::Base
    validates :title, presence: true
    validates :content, presence: true, length: {maximum: 200}
end
