namespace :reset_test_data do
  desc "テストデータをリセット（テストユーザーの作成データ + 既存シードデータを削除し、再生成）"
  task reset: :environment do
    test_user = User.find_by(email: "test@example.com")

    if test_user
      puts "🔄 テストデータのリセットを開始..."

      # ✅ 【1】テストユーザーが作成したデータを削除
      puts "🚨 テストユーザーのデータを削除中..."
      test_user.owned_teams.destroy_all    # ✅ テストユーザーがオーナーのチームを削除
      test_user.teams.clear                # ✅ テストユーザーが参加しているチームから退出
      test_user.items.destroy_all          # ✅ テストユーザーが作成したアイテムを削除

      # ✅ 【2】シードデータに含まれるチームとアイテムを削除（ユーザーは削除しない）
      puts "🚨 既存のシードデータ（チーム & アイテム）を削除中..."
      seed_team_names = [
        "テスト大学 サッカーサークル",
        "テスト大学 米倉ゼミ",
        "岡部家おつかいリスト",
        "キッチンカー「CRAYON」",
        "ラーメン〜獅子舞家〜"
      ]
      Team.where(name: seed_team_names).destroy_all
      puts "✅ シードデータの削除が完了！"

      # ✅ 【3】シードデータで作成したユーザーも削除
      puts "🚨 シードデータのユーザーを削除中..."
      seed_user_emails = [
        "test@example.com", "kengo@example.com", "hana@example.com", "kyosuke@example.com",
        "rokubon@example.com", "shunsuke@example.com", "kana@example.com", "kuroneko@example.com",
        "sasaki@example.com", "tomoya@example.com", "okabe_t@example.com", "okabe_r@example.com",
        "sato@example.com", "shioya@example.com", "karasawa@example.com", "kukumori@example.com",
        "shishimai@example.com", "torigara@example.com", "yugiri@example.com", "morimori@example.com",
        "umai@example.com"
      ]
      User.where(email: seed_user_emails).destroy_all
      puts "✅ シードデータのユーザー削除が完了！"

      # ✅ 【4】シードデータを再作成
      puts "🌱 シードデータを再生成中..."
      Rake::Task["db:seed"].invoke

      puts "✅ テストデータのリセットが完了しました！"
    else
      puts "⚠️ テストユーザーが見つかりませんでした"
    end
  end
end
