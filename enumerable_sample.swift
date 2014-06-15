/*
**
**
**  sample programs of Enumerable
**
**
*/

import Enumerable



/*
** sample of filter(), map(), take(), toArray()
*/

var x = Enumerable(sequence: 1...100)
println(x.filter{$0 % 2 != 0}.map{$0 * 3}.take(10).toArray())

//=> [3, 9, 15, 21, 27, 33, 39, 45, 51, 57]




/*
** sample of map(), each()
*/

var y = Enumerable(sequence:1...5)
y.map{"'\($0)'"}.each {
  println($0)
}

//=> '1'
//=> '2'
//=> '3'
//=> '4'
//=> '5'




/*
** Enumerable is also a Sequence
*/

for x in Enumerable(sequence: 10...15) {
  println("* \(x) *")
}
//=> * 10 *
//=> * 11 *
//=> * 12 *
//=> * 13 *
//=> * 14 *
//=> * 15 *

for (i,x) in enumerate(Enumerable(sequence: "Hello")) {
  println("\(i): \(x)")
}
//=> 0: H
//=> 1: e
//=> 2: l
//=> 3: l
//=> 4: o


/*
** sample of each_with_index(), init(worker:), take()
*/

Enumerable(sequence: "World").each_with_index{ x,i in
  println("\(i): \(x)")
}
//=> 0: W
//=> 1: o
//=> 2: r
//=> 3: l
//=> 4: d

for x in (Enumerable<String>{return "yes"}).take(5) {
  println("say \(x)")
}
//=> say yes
//=> say yes
//=> say yes
//=> say yes
//=> say yes




/*
**
** sample program to create infinite list of Primes
**
** in Haskell:
**   sieve (x:xs) = x: sieve [y|y <- xs, y `mod` x /= 0]
**   primes = sieve [2..]
**
*/

func sieve (list: Enumerable<Int>) -> Enumerable<Int> {
  var prime: Int?
  var remains: Enumerable<Int>!
  return Enumerable<Int> (worker:
    ({
      if prime {
        return remains.next()
      } else {
        prime = list.next()
        remains = sieve(list.filter{$0 % prime! != 0})
        return prime
      }
    })
  )
}

var primes = sieve(Enumerable(sequence: 2...Int.max))

// print first 20 primes
println(primes.take(20).toArray())
//=> [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71]

