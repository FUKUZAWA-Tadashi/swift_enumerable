public class Enumerable <T> : GeneratorType, SequenceType {

  private var closure : () -> T?

  public init (worker: () -> T?) {
    self.closure = worker
  }

  // construct from Generator
  public convenience init <G: GeneratorType where G.Element == T> (generator: G) {
    var gen = generator
    self.init(worker: ({ return gen.next() }))
  }

  // construct from Sequence
  public convenience init <S: SequenceType where S.Generator.Element == T> (sequence: S) {
    self.init(generator: sequence.generate())
  }

  // function for protocol GeneratorType
  public func next () -> T? {
    return self.closure()
  }

  // function for protocol Sequence
  public func generate () -> Enumerable<T> {
    return self
  }

  // take first n elements
  public func take (n: Int) -> Enumerable<T> {
    var count = n
    return Enumerable<T>(worker:
      ({
        if count > 0 {
          --count
          return self.closure()
        } else {
          return nil
        }
      })
    )
  }

  // select elements which judge() returns a true
  public func filter (judge: (T) -> Bool) -> Enumerable<T> {
    return Enumerable<T>(worker:
      ({
        while let x = self.closure() {
          if judge(x) {
            return x
          }
        }
        return nil
      })
    )
  }

  // apply mapper() to every element
  public func map<V> (mapper: (T) -> V) -> Enumerable<V> {
    return Enumerable<V>(worker:
      ({
        if let x = self.closure() {
          return mapper(x)
        } else {
          return nil
        }
      })
    )
  }

  // reduce
  public func reduce (operation: (T,T) -> T) -> T! {
    var v = self.closure()
    if v != nil {
      while let x = self.closure() {
        v = operation(v!, x)
      }
    }
    return v
  }

  // reduce with initital value
  public func reduce<V> (initValue:V, operation: (V,T) -> V) -> V {
    var v = initValue
    while let x = self.closure() {
      v = operation(v, x)
    }
    return v
  }

  public func toArray () -> Array<T> {
    var arr = [T]()
    while let x = self.closure() {
      arr.append(x)
    }
    return arr
  }

  public func each (body: (T) -> ()) -> () {
    while let x = self.closure() {
      body(x)
    }
  }

  public func each_with_index (body: (T, Int) -> ()) -> () {
    var index: Int = 0
    while let x = self.closure() {
      body(x, index++)
    }
  }

}

