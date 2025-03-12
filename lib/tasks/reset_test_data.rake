namespace :reset_test_data do
  desc "テストユーザーのデータをリセット（一般ユーザーのデータは残す）"
  task reset: :environment do
    test_user = User.find_by(email: "test@example.com")

    if test_user
      puts "🔄 テストユーザーのデータをリセット中..."

      # ✅ テストユーザーがオーナーのチームを削除
      Team.where(owner: test_user).destroy_all

      # ✅ テストユーザーが所属しているチームとの関連を削除
      test_user.teams.clear

      # ✅ テストユーザーが作成したアイテムを削除
      Item.where(user: test_user).destroy_all

      # ✅ テストユーザーを削除して再作成
      test_user.destroy!
      puts "🚨 既存のテストユーザーを削除しました！"

      # ✅ もう一度シードデータを作成
      Rake::Task["db:seed"].invoke

      puts "✅ テストデータをリセットしました！"
    else
      puts "⚠️ テストユーザーが見つかりませんでした。新しく作成します..."
      Rake::Task["db:seed"].invoke
    end
  end
end
