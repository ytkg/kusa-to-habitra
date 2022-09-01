# kusa-to-habitra
GitHub に草を生やしたら HabiTra に記録するスクリプト

## 使い方
### ローカルの場合
#### 環境変数の設定
```bash
cp .env.sample .env
vim .env
```

#### 実行
```bash
ruby app.rb
```
### GitHub Actionsの場合
#### 環境変数の設定
[Settings] -> [Sectets]に以下を登録
- HABITRA_ID: HabiTra の User ID
- HABITRA_PASSWORD: HabiTra の User password
- HABITRA_HABIT_ID: HabiTra の Habit ID
