
struct BE_MapGenerator <G: Generator, V> : Generator {
  var gen: G
  var mapFunc: (G.Element) -> V
  init (generator: G, mapFunc: (G.Element) -> V) {
    self.gen = generator
    self.mapFunc = mapFunc
  }
  mutating func next() -> V? {
    if let x = gen.next() {
      return mapFunc(x)
    } else {
      return nil
    }
  }
}

struct BE_FilterGenerator <G: Generator> : Generator {
  var gen: G
  var filterFunc: (G.Element) -> Bool
  init (generator: G, filterFunc: (G.Element) -> Bool) {
    self.gen = generator
    self.filterFunc = filterFunc
  }
  mutating func next() -> G.Element? {
    while let x = gen.next() {
      if filterFunc(x) {
        return x
      }
    }
    return nil
  }
}

struct BE_TakeGenerator <G: Generator> : Generator {
  var gen: G
  var n: UInt
  init (generator: G, n: UInt) {
    self.gen = generator
    self.n = n
  }
  mutating func next() -> G.Element? {
    if n > 0 {
      --n
      return gen.next()
    } else {
      return nil
    }
  }
}



class BEnumerable <G: Generator> : Generator {
  var wrappedGen: [G]
  var generator: G {
    get { return wrappedGen[0] }
    set { wrappedGen[0] = newValue }
  }

  init (generator: G) {
    wrappedGen = [generator]
  }

  /*this cannot be compiled
  **  convenience init <S: Sequence where S.GeneratorType == G> (sequence: S) {
  **    self.init(sequence.generate())
  **  }
  */


  func next() -> G.Element? {
    return generator.next()
  }

  func toArray() -> Array<G.Element> {
    var arr = Array<G.Element>()
    while let x = generator.next() {
      arr.append(x)
    }
    return arr
  }

  func take(n: UInt) -> BEnumerable<BE_TakeGenerator<G>> {
    return BEnumerable<BE_TakeGenerator<G>>(generator: BE_TakeGenerator(generator: generator, n: n))
  }

  func map<V> (mapFunc: (G.Element) -> V) -> BEnumerable<BE_MapGenerator<G, V>> {
    return BEnumerable<BE_MapGenerator<G, V>>(generator: BE_MapGenerator(generator: generator, mapFunc: mapFunc))
  }

  func filter(filterFunc: (G.Element) -> Bool) -> BEnumerable<BE_FilterGenerator<G>> {
    return BEnumerable<BE_FilterGenerator<G>>(generator: BE_FilterGenerator(generator: generator, filterFunc: filterFunc))
  }
  
  func each (closure: (G.Element) -> ()) -> () {
    while let x = generator.next() {
      closure(x)
    }
  }

}


func enumerableFromSequence <S: Sequence> (seq: S) -> BEnumerable<S.GeneratorType> {
  return BEnumerable<S.GeneratorType>(generator: seq.generate())
}


/*
var x = enumerableFromSequence(1..0)
println(x.filter{$0 % 2 == 0}.map{$0 * 3}.take(5).toArray())
*/


/*
BEnumerable を class でなく struct で実装すると、
var x = enumerateSequence(1..10)
println(x.map{$0 * 2}.toArray())
// =>  error: immutable value of type 'BEnumerable<BE_MapGenerator<RangeGenerator<Int>, $T4>>' only has mutating members named 'toArray'
メソッドチェーンでエラーになる。
式の途中のstructは、immutable扱いになっているらしい。
*/

/*
class BEnumerable で
 var wrappedGen: G[]
を使わず
 var generator: G
とすると、
error: unimplemented IR generation feature non-fixed class layout
*/

