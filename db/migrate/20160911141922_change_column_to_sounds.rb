class ChangeColumnToSounds < ActiveRecord::Migration
#↑すでにあるカラムの変更では、コマンドラインで"rails g migration ChangeColumnTo<モデル名>"と打ってこのマイグレーションファイルを作る
    # 変更後の状態
    def up
        change_column :sounds, :upfile, :string
    end

    # 変更前の状態
    def down
        change_column :sounds, :upfile, :binary
    end
end
