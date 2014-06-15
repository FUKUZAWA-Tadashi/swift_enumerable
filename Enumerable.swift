class Enumerable <T> : Generator, Sequence {

  var closure : () -> T?

  init (worker: () -> T?) {
    self.closure = worker
  }

  // construct from Generator
  convenience init <G: Generator where G.Element == T> (generator: G) {
    var gen = generator
    self.init(worker: ({ return gen.next() }))
  }

  // construct from Sequence
  convenience init <S: Sequence where S.GeneratorType.Element == T> (sequence: S) {
    self.init(generator: sequence.generate())
  }

  // function for protocol Generator
  func next () -> T? {
    return self.closure()
  }

  // function for protocol Sequence
  func generate () -> Enumerable<T> {
    return self
  }

  // take first n elements
  func take (n: Int) -> Enumerable<T> {
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
  func filter (judge: (T) -> Bool) -> Enumerable<T> {
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
  func map<V> (mapper: (T) -> V) -> Enumerable<V> {
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

  func toArray () -> Array<T> {
    var arr = T[]()
    while let x = self.closure() {
      arr.append(x)
    }
    return arr
  }

  func each (body: (T) -> ()) -> () {
    while let x = self.closure() {
      body(x)
    }
  }

  func each_with_index (body: (T, Int) -> ()) -> () {
    var index: Int = 0
    while let x = self.closure() {
      body(x, index++)
    }
  }

}

