# コスト考慮型ベイズ最適化 論文解説

このリポジトリは、コスト考慮型ベイズ最適化（Cost-aware Bayesian Optimization）に関する主要論文の解説ドキュメントを提供しています。

## 📚 収録論文

- **ACBO** - Adaptive Cost-aware Bayesian Optimization
- **PBGI** - Pandora's Box Gittins Index
- **CAStoP** - Cost-aware Stopping for Bayesian Optimization
- **CArBO** - Cost Apportioned Bayesian Optimization

## 🌐 GitHub Pagesで公開

このリポジトリはGitHub Pagesで自動的に公開されます。

### セットアップ手順

1. **GitHubでリポジトリを作成**
   - リポジトリ名: `acbo-docs` (任意)
   - Public リポジトリとして作成

2. **ローカルからpush**
   ```bash
   git remote add origin https://github.com/YOUR_USERNAME/acbo-docs.git
   git add .
   git commit -m "Initial commit"
   git push -u origin main
   ```

3. **GitHub Pagesを有効化**
   - リポジトリの Settings → Pages
   - Source: GitHub Actions を選択

4. **アクセスURL**
   ```
   https://YOUR_USERNAME.github.io/acbo-docs/
   ```

## 📁 ファイル構成

- `index.html` - トップページ
- `ACBO_Explanation.html` - ACBO論文解説
- `PBGI_Explanation.html` - PBGI論文解説
- `CAStop_Explanation.html` - CAStoP論文解説
- `CArBO_Section3_Explanation_fixed.html` - CArBO論文解説
- `.github/workflows/deploy.yml` - 自動デプロイ設定

## 🚀 更新方法

HTMLファイルを編集後：
```bash
git add .
git commit -m "Update documentation"
git push
```

pushすると自動的にGitHub Pagesが更新されます（1-2分かかります）。

## 📝 ライセンス

学術目的での使用を推奨します。