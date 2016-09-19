class User < ActiveRecord::Base
    validates :name, presence:true

    validates :email, presence:true,
                uniqueness:true
    #↑語尾に";"（セミコロン）などはいらない
end
