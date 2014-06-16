Enumerableモジュール
====================

# Enumerable module for Swift

## 特徴

無限リスト、遅延評価を実現するコンテナクラス。

RubyのEnumerableの様に、メソッドチェーンを使える。


## Enumerableクラス
`class Enumerable<T> : Generator, Sequence`

Tは要素の型

### コンストラクタ

- `Enumerable(worker: () -> T?)`

 次の入力要素を取得するクロージャを登録。

- `Enumerable<G: Generator where G.Element == T>(generator: G)`

 次の入力要素を取得するジェネレータを登録。

- `Enumerable<S: Sequence where S.GeneratorType.Element == T> (sequence: S)`

 次の入力要素を取得するためのSequenceを登録。SequenceからGeneratorを生成して使用する。



### メソッドチェーン
これらのメソッドの戻り値は `Enumerable<T>` (または`Enumerable<V>`)

- `func take (n: Int) -> Enumerable<T>`

 最初のn個の要素を取り出す。

- `func filter (judge: (T) -> Bool) -> Enumerable<T>`

 各入力要素に judge() を適用して、trueを返した要素を残し、残りは捨てる。

- `func map<V> (mapper: (T) -> V) -> Enumerable<V>`

 各入力要素に mapper() を適用して、その戻り値を出力要素とする。




### Generatorプロトコルのメソッド
- `func next () -> T?`

 次の出力要素を生成する。

### Sequenceプロトコルのメソッド
- `func generate () -> Enumerable<T>`

 出力要素を生成するジェネレータを返す。




### その他
- `func toArray () -> Array<T>`

 全入力要素を配列に入れ、それを返す。

 無限リストだと無限ループになってしまうので注意。

- `func each (body: (T) -> ()) -> ()`

 全入力要素について、各要素を body() に適用する事を繰り返す。

- `func each_with_index (body: (T, Int) -> ()) -> ()`

 全入力要素について、各要素とそのインデックス(先頭が0)を body() に適用する事を繰り返す。

 Swiftの for (i, x) in enumerate(...) とは異なり、要素とインデックの順番が逆なので注意。Rubyと同じ。


## サンプルプログラム

enumerable_sample.swift にサンプルプログラムを収録しました。


## ライセンス

MITライセンスとします。
