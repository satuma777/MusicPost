class User < ActiveRecord::Base
    has_many :sounds
    #↑複数形で書く。

    validates :name, presence:true
    validates :email, presence:true,
                uniqueness:true
    #↑語尾に";"（セミコロン）などはいらない
end
