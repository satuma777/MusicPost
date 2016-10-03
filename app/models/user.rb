class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable,
            :recoverable, :rememberable, :trackable
    has_many :sounds
    #↑複数形で書く。

    validates :name, presence:true
    #validates :email, presence:true,niqueness:true
    #↑ deviseのvalidatableによって以下と同じバリデーションが設定されているのでコメントアウトする
    validates :email, presence:true, uniqueness:true
    validates :password, presence:true
end
