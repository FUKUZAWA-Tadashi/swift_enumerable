
public struct BE_MapGenerator <G: GeneratorType, V> : GeneratorType {
  var gen: G
  var mapFunc: (G.Element) -> V
  public init (generator: G, mapFunc: (G.Element) -> V) {
    self.gen = generator
    self.mapFunc = mapFunc
  }
  public mutating func next() -> V? {
    if let x = gen.next() {
      return mapFunc(x)
    } else {
      return nil
    }
  }
}

public struct BE_FilterGenerator <G: GeneratorType> : GeneratorType {
  var gen: G
  var filterFunc: (G.Element) -> Bool
  public init (generator: G, filterFunc: (G.Element) -> Bool) {
    self.gen = generator
    self.filterFunc = filterFunc
  }
  public mutating func next() -> G.Element? {
    while let x = gen.next() {
      if filterFunc(x) {
        return x
      }
    }
    return nil
  }
}

public struct BE_TakeGenerator <G: GeneratorType> : GeneratorType {
  var gen: G
  var n: UInt
  public init (generator: G, n: UInt) {
    self.gen = generator
    self.n = n
  }
  public mutating func next() -> G.Element? {
    if n > 0 {
      --n
      return gen.next()
    } else {
      return nil
    }
  }
}



public class BEnumerable <G: GeneratorType> : GeneratorType {
  var generator: G

  public init (generator: G) {
    self.generator = generator
  }

  /*this cannot be compiled
  **  public convenience init <S: SequenceType where S.Generator == G> (sequence: S) {
  **    self.init(sequence.generate())
  **  }
  */


  public func next() -> G.Element? {
    return generator.next()
  }

  public func toArray() -> Array<G.Element> {
    var arr = Array<G.Element>()
    while let x = generator.next() {
      arr.append(x)
    }
    return arr
  }

  public func take(n: UInt) -> BEnumerable<BE_TakeGenerator<G>> {
    return BEnumerable<BE_TakeGenerator<G>>(generator: BE_TakeGenerator(generator: generator, n: n))
  }

  public func map<V> (mapFunc: (G.Element) -> V) -> BEnumerable<BE_MapGenerator<G, V>> {
    return BEnumerable<BE_MapGenerator<G, V>>(generator: BE_MapGenerator(generator: generator, mapFunc: mapFunc))
  }

  public func filter(filterFunc: (G.Element) -> Bool) -> BEnumerable<BE_FilterGenerator<G>> {
    return BEnumerable<BE_FilterGenerator<G>>(generator: BE_FilterGenerator(generator: generator, filterFunc: filterFunc))
  }
  
  public func each (closure: (G.Element) -> ()) -> () {
    while let x = generator.next() {
      closure(x)
    }
  }

}


public func enumerableFromSequence <S: SequenceType> (seq: S) -> BEnumerable<S.Generator> {
  return BEnumerable<S.Generator>(generator: seq.generate())
}



/*
var x = enumerableFromSequence(1..<Int.max)
println(x.filter{$0 % 2 == 0}.map{$0 * 3}.take(5).toArray())
*/

