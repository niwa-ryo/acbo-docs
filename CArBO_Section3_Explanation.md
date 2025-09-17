# CArBO: Cost Apportioned BO

## 1. CArBOの革新

### 従来手法の問題
- **EI**：コストを無視、高コスト点ばかり評価
- **EIpc**：最適解が高コストだと性能悪化

### CArBOの解決策
1. **初期設計**：安い点を多数配置して情報収集
2. **コストクーリング**：徐々にコスト制約を緩和
3. **結果**：同一予算で約40%のコスト削減

### 重要な理解
- コスト関数は未知でOK（オンライン学習）
- 100点生成するが評価は1点のみ
- 「安くて遠い」点が自動的に選ばれる仕組み
- 初期は情報収集、後期は最適化に集中

## 2. CArBOの核心：2段階戦略

**「初期は目的関数を無視してコスト効率的に情報収集、後期は徐々にコスト制約を緩和して最適解を探索」**

### フェーズ1：初期設計（予算0-12.5%）
- **目的**：探索空間の情報収集
- **方法**：目的関数を無視、コスト最優先で安い点を大量配置
- **結果**：同一予算で従来4点→15点の評価が可能

### フェーズ2：最適化（予算12.5-100%）
- **方法**：EI-cooling（α値が1.0→0.0へ減衰）
- **初期**：コスト重視（EIpc的）
- **後期**：精度重視（EI的）

### 時間軸での戦略変化

```mermaid
flowchart LR
    Init["初期設計フェーズ<br/>予算: 0-12.5%<br/>目的関数無視<br/>コスト最優先<br/>安い点を大量配置"]

    Early["最適化初期<br/>予算: 12.5-40%<br/>α ≈ 1.0<br/>EIpc的動作<br/>コスト重視"]

    Middle["最適化中期<br/>予算: 40-70%<br/>α ≈ 0.5<br/>バランス型<br/>コスト精度両立"]

    Late["最適化後期<br/>予算: 70-100%<br/>α ≈ 0.0<br/>EI的動作<br/>精度最優先"]

    Init -->|Algorithm 1| Early
    Early -->|EI-cooling| Middle
    Middle -->|EI-cooling| Late

    style Init fill:#bbdefb,stroke:#1976d2,stroke-width:3px
    style Early fill:#ffe0b2,stroke:#f57c00,stroke-width:3px
    style Middle fill:#e1bee7,stroke:#7b1fa2,stroke-width:3px
    style Late fill:#ffcdd2,stroke:#c62828,stroke-width:3px
```

## 2. コスト効率的な初期設計（Algorithm 1）

### 目的と前提
- **目的**：限られた予算内で、探索空間を均等にカバーする点集合を構築
- **重要な前提**：コスト関数は未知（評価して初めて判明）

### Algorithm 1の動作

```mermaid
flowchart TB
    Start([開始])
    Start --> Init["`**初期化**
    初期予算 = τinit（総予算の1/8）
    累積コスト = 0
    選択済み点 = [ ]`"]

    Init --> MainLoop{累積コスト < 初期予算？}

    MainLoop -->|はい| Step1[100個の候補を生成]
    MainLoop -->|いいえ| End([終了])

    Step1 --> Step2[99個を削減する処理]

    Step2 --> Reduction["`**削減ループ（99回繰り返し）**
    交互に削除：
    ・高コストな点を1個削除
    ・既存点に近い点を1個削除`"]

    Reduction --> Step3[最後の1点が残る<br/>「安くて遠い点」]

    Step3 --> Step4[残った1点を実際に評価<br/>モデルを訓練して時間測定]

    Step4 --> Step5[累積コストとモデルを更新]

    Step5 --> MainLoop

    style Start fill:#e8f5e9,stroke:#2e7d32,stroke-width:3px
    style End fill:#ffebee,stroke:#c62828,stroke-width:3px
    style MainLoop fill:#e1f5fe,stroke:#0277bd,stroke-width:3px
    style Step4 fill:#fce4ec,stroke:#c2185b,stroke-width:3px
    style Reduction fill:#fff9c4,stroke:#f57f17,stroke-width:2px
```

### 削除基準の詳細

#### 高コスト削除
- GPモデルで100点のコストを予測（実計算ではない）
- 最も高い予測値の点を削除
- データ不足時（最初の1-2反復）はランダム削除

#### 近接点削除
- 各候補と既存点の距離を計算
- 最も近い点を削除（空間を均等にカバーするため）

### 重要な理解ポイント

- **候補点の「座標」**：ハイパーパラメータの組み合わせ（例：learning_rate=0.01, layers=3）
- **「評価」**：実際にモデルを訓練して性能とコストを測定
- **100点の扱い**：生成（座標）→予測（ミリ秒）→削除（配列操作）→評価（1点のみ、数秒〜数分）

## 3. コストクーリング（EI-cooling）

### 定式化

$$
\text{EI-cool}(x) = \frac{\text{EI}(x)}{c(x)^{\alpha}}
$$

$$
\alpha = \frac{\tau - \tau_k}{\tau - \tau_{\text{init}}}
$$

ここで：
- $\tau$：総予算
- $\tau_k$：現在までの使用予算
- $\tau_{\text{init}}$：初期設計の予算
- $\alpha$：1.0 → 0.0 へ減衰するパラメータ

### 動作原理
- **α ≈ 1.0（初期）**：EIpc的、コスト効率最重視
- **α ≈ 0.5（中期）**：バランス型、コストと性能を両立
- **α ≈ 0.0（後期）**：純EI、コスト無視で最適解追求

## 4. 完全なアルゴリズム（Algorithm 2）

```mermaid
flowchart TB
    Start([開始])
    Start --> Init[初期化<br/>総予算の1/8を初期設計に割当]

    Init --> Phase1{初期設計予算内？}

    Phase1 -->|はい| InitDesign["`**Algorithm 1を実行**
    安い点を1つ選択して評価`"]

    InitDesign --> UpdatePhase1[予算を消費<br/>点を蓄積]

    UpdatePhase1 --> Phase1

    Phase1 -->|いいえ| BuildModel["`**GPモデル構築**
    目的関数モデル
    コストモデル`"]

    BuildModel --> Phase2{総予算内？}

    Phase2 -->|はい| CalcAlpha["`**α値を計算**
    残り予算に応じて
    1.0（初期）→ 0.0（後期）`"]

    CalcAlpha --> SelectNext["`**次の評価点を選択**
    EI-cooling獲得関数
    コストと性能のバランス`"]

    SelectNext --> EvaluatePoint["`**点を評価**
    実際にモデル訓練
    時間と精度を測定`"]

    EvaluatePoint --> UpdatePhase2["`**モデル更新**
    GPモデルを改善
    予算を消費`"]

    UpdatePhase2 --> Phase2

    Phase2 -->|いいえ| ReturnBest[最良の点を返す]

    ReturnBest --> End([終了])

    style Start fill:#e8f5e9,stroke:#2e7d32,stroke-width:3px
    style End fill:#ffebee,stroke:#c62828,stroke-width:3px
    style Phase1 fill:#e3f2fd,stroke:#1565c0,stroke-width:3px
    style Phase2 fill:#fff3e0,stroke:#ef6c00,stroke-width:3px
    style EvaluatePoint fill:#fce4ec,stroke:#c2185b,stroke-width:3px
    style CalcAlpha fill:#f3e5f5,stroke:#7b1fa2,stroke-width:2px
```