余計なおまけ
============

Enumerableはclosureを使用して実装していますが、当初はGeneratorを使用していました。
これを BadEnumerable.swift として残してあります。

一応そこそこは動いていますが、プログラムの見通しが悪く、ちょっと変更しようとすると すぐどこかでエラーが発生したりします。

特にSwiftの型システムが不備で、protocolにジェネリックを使用できない仕様のせいで、型の整合性を取るのに大変苦労します。



Haskellにおいて2行で書ける素数列生成プログラム

```haskell
sieve (x:xs) = x: sieve [y|y <- xs, y `mod` x /= 0]
primes = sieve [2..]
```

これと同じアルゴリズムを実現しようとすると、コンパイルエラーやら実行時エラーやらで
うまく動きません。

最終的なものを badEnumerable_sieve.swift として置いておきましたが、実行しようとすると
`Segmentation fault: 11`
でコンパイラが死んでしまいます。

ちゃんと動作するプログラムにする事は可能なのでしょうか？


最終的なEnumerableの実装では、Generatorを使わずclosureにしてみましたが、型システムの呪縛から
逃れる事が出来て、素数列発生プログラムも(Haskell程ではないにしても)簡潔に書けました。

enumerable_sample.swift の最後に入っています。

