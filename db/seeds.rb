require 'faker'

Faker::Config.locale = 'ja' # ✅ 日本語を適用！

puts "🚨 既存のシードデータを削除中..."

# テストユーザー & 関連データのみ削除
test_user = User.find_by(email: "test@example.com")
if test_user
  test_user.teams.destroy_all # 🔥 テストユーザーがオーナーのチームを削除
  test_user.items.destroy_all # 🔥 テストユーザーが登録したアイテムを削除
  test_user.destroy # 🔥 テストユーザー自体を削除
end

puts "✅ シードデータの削除が完了！"

# 📌 他の固定ユーザー作成（メールは仮）
users = {
  "テストユーザー" => "test@example.com",
  "けんご" => "kengo@example.com",
  "はなちゃん" => "hana@example.com",
  "京介" => "kyosuke@example.com",
  "六本坂 翔" => "rokubon@example.com",
  "しゅんすけ先輩" => "shunsuke@example.com",
  "かな" => "kana@example.com",
  "クロネコ" => "kuroneko@example.com",
  "佐々木先輩" => "sasaki@example.com",
  "ともや" => "tomoya@example.com",
  "岡部 友五郎" => "okabe_t@example.com",
  "岡部 りん" => "okabe_r@example.com",
  "佐藤 しおり" => "sato@example.com",
  "塩谷 甘奈" => "shioya@example.com",
  "辛沢 翔我" => "karasawa@example.com",
  "九苦森 珈琲" => "kukumori@example.com",
  "獅子舞店長" => "shishimai@example.com",
  "鳥柄 第一" => "torigara@example.com",
  "湯切 優秀" => "yugiri@example.com",
  "森盛 御飯" => "morimori@example.com",
  "馬井 茶秋" => "umai@example.com"
}

user_records = users.map do |name, email|
  user = User.create!(
    name: name,  # ✅ ここを `name` に修正
    email: email, 
    password: "password",
    password_confirmation: "password"
  )
  [name, user]  # ✅ `[名前, ユーザーオブジェクト]` の配列を作る
end.to_h  # ✅ `to_h` で `{名前 => ユーザーオブジェクト}` のハッシュに変換


# 📌 チーム作成 & メンバー登録
teams = {
  "テスト大学 サッカーサークル" => ["テストユーザー","けんご", "はなちゃん", "京介", "六本坂 翔", "しゅんすけ先輩", "かな"],
  "テスト大学 米倉ゼミ" => ["テストユーザー","クロネコ", "佐々木先輩", "ともや"],
  "岡部家おつかいリスト" => ["テストユーザー","岡部 友五郎", "岡部 りん"],
  "キッチンカー「CRAYON」" => ["テストユーザー","佐藤 しおり", "塩谷 甘奈", "辛沢 翔我", "九苦森 珈琲"],
  "ラーメン〜獅子舞家〜" => ["テストユーザー","獅子舞店長", "鳥柄 第一", "湯切 優秀", "森盛 御飯", "馬井 茶秋"]
}

team_records = {}

teams.each do |team_name, member_names|
  team = Team.create!(name: team_name, owner: user_records["テストユーザー"])
  team_records[team_name] = team # ← Hash に保存！

  member_names.each do |name|
    Membership.create!(user: user_records[name], team: team)
  end
end


# 📌 アイテム追加（すべて固定）
items = {
  "テスト大学 サッカーサークル" => [
    ["サッカーボール", "練習用", 2000, 10],
    ["スポーツドリンク", "毎月5箱はほしい", 1000, 5],
    ["ノート", "練習ノートに使う", 100, 1]
  ],
  "テスト大学 米倉ゼミ" => [
    ["ルーズリーフ", "ゼミのメモ用", 300, 2],
    ["ボールペン", "3色ボールペン", 150, 5],
    ["USBメモリ", "発表データ保存用", 2000, 1],
    ["付箋", "付箋メモセット", 400, 3],
    ["コーヒー豆", "長時間ゼミ用", 1200, 1]
  ],
  "岡部家おつかいリスト" => [
    ["牛乳", "朝食用", 250, 2],
    ["卵", "10個入り", 300, 1],
    ["しょうゆ", "料理用", 400, 1],
    ["トイレットペーパー", "12ロール入り", 500, 1]
  ],
  "キッチンカー「CRAYON」" => [
    ["たまねぎ", "仕込み用", 500, 5],
    ["鶏むね肉", "サンドイッチ用", 800, 3],
    ["フランスパン", "サンドイッチ用", 600, 4]
  ],
  "ラーメン〜獅子舞家〜" => [
    ["中華麺", "ラーメン用", 1000, 10],
    ["豚骨スープ", "仕込み用", 1500, 2],
    ["チャーシュー", "ラーメントッピング用", 1200, 5],
    ["メンマ", "ラーメントッピング用", 700, 4],
    ["ネギ", "薬味用", 500, 3],
    ["のり", "トッピング用", 300, 5],
    ["ゆで卵", "半熟卵", 400, 6]
  ]
}


# 📌 アイテム追加（すべて固定）
items.each do |team_name, item_list|
  team = team_records[team_name]
  
  item_list.each do |name, desc, price, qty|
    Item.create!(
      name: name,
      description: desc,
      price: price,
      quantity: qty,
      status: "unpurchased",
      user: team.users.sample,
      team: team
    )
  end
end


puts "🌱 シードデータの投入が完了しました！"
