#!/bin/bash

# GitHub Pages公開用のセットアップスクリプト
# 使用方法: ./setup-github.sh YOUR_GITHUB_USERNAME

if [ $# -eq 0 ]; then
    echo "使用方法: ./setup-github.sh YOUR_GITHUB_USERNAME"
    echo "例: ./setup-github.sh niwa-ryo"
    exit 1
fi

USERNAME=$1
REPO_NAME="acbo-docs"

echo "=== GitHub Pages セットアップ ==="
echo "GitHubユーザー名: $USERNAME"
echo "リポジトリ名: $REPO_NAME"
echo ""

# 初回コミット
echo "📝 ファイルをGitに追加..."
git add .
git commit -m "Initial commit: Add BO documentation HTML files"

# リモートリポジトリの設定
echo "🔗 リモートリポジトリを設定..."
git remote add origin "https://github.com/${USERNAME}/${REPO_NAME}.git"

echo ""
echo "=== 次のステップ ==="
echo "1. GitHubで新しいリポジトリを作成:"
echo "   https://github.com/new"
echo "   リポジトリ名: ${REPO_NAME}"
echo "   ※ Public リポジトリとして作成してください"
echo ""
echo "2. リポジトリ作成後、以下のコマンドを実行:"
echo "   git push -u origin main"
echo ""
echo "3. GitHub Pagesを有効化:"
echo "   - リポジトリの Settings → Pages"
echo "   - Source: GitHub Actions を選択"
echo ""
echo "4. 1-2分待つと以下のURLでアクセス可能:"
echo "   https://${USERNAME}.github.io/${REPO_NAME}/"
echo ""