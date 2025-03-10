namespace :reset_test_data do
  desc "テストユーザーのデータをリセット（一般ユーザーのデータは残す）"
  task reset: :environment do
    test_user = User.find_by(email: "test@example.com")
    if test_user
      puts "🔄 テストユーザーのデータをリセット中..."

      # ✅ テストユーザーがオーナーのチームを削除
      test_user.owned_teams.destroy_all

      # ✅ テストユーザーが所属しているチームから退出
      test_user.teams.clear

      # ✅ テストユーザーが作成したアイテムを削除
      test_user.items.destroy_all

      # ✅ もう一度テストデータを作成
      Rake::Task["db:seed"].invoke

      puts "✅ テストデータをリセットしました！"
    else
      puts "⚠️ テストユーザーが見つかりませんでした"
    end
  end
end
