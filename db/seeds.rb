require 'faker'

Faker::Config.locale = 'ja' # ✅ 日本語を適用！

# 🌱 ユーザーを20人作成
users = 20.times.map do
  User.create!(
    name: Faker::Name.name,
    email: Faker::Internet.unique.email,
    password: "password"
  )
end

# 🌱 5つのチームを作成（オーナーはランダム）
teams = 5.times.map do
  owner = users.sample
  Team.create!(name: "#{Faker::Company.name} チーム", owner: owner)
end

# 🌱 各チームに `5〜7人` のメンバーを追加
teams.each do |team|
  members = users.sample(rand(5..7)) # ランダムな人数を選択
  members.each do |user|
    Membership.find_or_create_by!(user: user, team: team) # 重複を防ぐ
  end
end

# 🌱 各チームに `10個のアイテム` を登録
teams.each do |team|
  10.times do
    Item.create!(
      name: Faker::Food.dish, # ✅ 食べ物の名前
      description: Faker::Food.description, # ✅ 説明
      price: rand(100..2000), # ✅ 価格（100円〜2000円）
      quantity: rand(1..5), # ✅ 数量（1〜5個）
      status: %w[unpurchased purchased rejected].sample, # ✅ ランダムなステータス
      user: team.users.sample, # ✅ チームメンバーの誰かが登録
      team: team
    )
  end
end

puts "🌱 シードデータの投入が完了しました！"
