import BadEnumerable

var x = enumerableFromSequence(1..<Int.max)
println(x.filter{$0 % 2 == 0}.map{$0 * 3}.take(5).toArray())

struct BE_SieveGenerator <U: GeneratorType where U.Element == Int> : GeneratorType {
  var list: U
  var remain: BE_SieveGenerator<BE_FilterGenerator<U>>?

  init (list: U) {
    self.list = list
    self.remain = nil
  }
  mutating func next() -> Int? {
    if var r = remain {
      return r.next()
    } else if let prime = list.next() {
      remain = BE_SieveGenerator<BE_FilterGenerator<U>>(list: BE_FilterGenerator<U>(generator: self.list){$0 % prime != 0})
      return prime
    } else {
      return nil
    }
  }
}


var primes = BEnumerable(generator: BE_SieveGenerator(list: (2...Int.max).generate()))
// println(primes.take(10).toArray())
println(primes.next())

