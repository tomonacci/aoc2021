import scala.io.StdIn
import scala.collection.immutable.ArraySeq
import scala.collection.mutable
import scala.collection.mutable.{PriorityQueue, Queue}

object Day23 {
  class Solver(r: Int) {
    // constants regarding the map
    val n = 11 + r * 4
    val coords = (1 to 11).map((1, _)) ++ Seq(3, 5, 7, 9).flatMap(x => (0 until r).map(y => (y + 2, x)))
    val edges = {
      val es = mutable.ArraySeq.fill(n)(ArraySeq.newBuilder[Int])
      ((0 until 11).sliding(2).map { case Seq(i, j) => (i, j) } ++ (1 to 4).flatMap { x =>
        val k = 11 + r * (x - 1)
        (0 until r).map(k + _).sliding(2).map { case Seq(i, j) => (i, j) } ++ Seq((2 * x, k))
      }).foreach { case (i, j) =>
        es(i) += j
        es(j) += i
      }
      ArraySeq.from(es.map(_.result()))
    }
    val rooms = ArraySeq.tabulate(5)(x => if (x == 0) ArraySeq() else ArraySeq.from((0 until r).map(_ + 11 + r * (x - 1))))
    //println(n, coords, edges, rooms)

    // predicates regarding the map
    def isHallway(i: Int) = i < 11
    def isRoom(i: Int, x: Int) = r * (x - 1) <= i - 11 && i - 11 < r * x
    def testIsRoom() = {
      Seq(
        (11, 1),
        (11, 2),
        (11, 3),
        (11, 4),
        (12, 1),
        (12, 2),
        (12, 3),
        (12, 4),
        (13, 1),
        (13, 2),
        (13, 3),
        (13, 4),
        (14, 1),
        (14, 2),
        (14, 3),
        (14, 4),
      ).foreach { case (i, x) => println((i, x, isRoom(i, x))) }
    }
    def isImmediatelyOutsideRoom(i: Int) = i == 2 || i == 4 || i == 6 || i == 8

    // accessors
    val p5s = ArraySeq.iterate(1L, n)(_ * 5)
    def ith5(m: Long, i: Int) = (m / p5s(i) % 5).toInt
    def testIth5() = {
      Seq(
        (3L, 0),
        (3L, 1),
        (3L, 2),
        (5L, 0),
        (5L, 1),
        (5L, 2),
        (8L, 0),
        (8L, 1),
        (8L, 2),
        (25L, 0),
        (25L, 1),
        (25L, 2),
        (25L, 3),
        (25L, 4),
      ).foreach { case (m, i) =>
        println((m, i, ith5(m, i)))
      }
    }
    def toBase5(xs: Seq[Int]) = xs.zip(p5s).map { case (x, p) => x * p }.sum
    def fromBase5(m: Long) = (0 until n).map(ith5(m, _))

    def solve(ls: Seq[String]): Option[Int] = {
      val m0 = toBase5(coords.map { case (y, x) => ls(y)(x) }.map(c => if (c == '.') 0 else c - 'A' + 1))
      val mFinal = toBase5(Seq.tabulate(n)(i => if (isHallway(i)) 0 else (i - 11) / r + 1))
      val energies = mutable.Map[Long, Int]()
      val pq = PriorityQueue((0, m0))
      while (!pq.isEmpty) {
        val (energy, m) = pq.dequeue()
        if (m == mFinal) {
          return Some(-energy)
        }
        if (!energies.contains(m)) {
          //println((fromBase5(m), -energy))
          energies(m) = energy
          (0 until n).foreach { i =>
            if (ith5(m, i) > 0) {
              val ds = mutable.Map(i -> 0)
              val q = Queue(i)
              while (!q.isEmpty) {
                val j = q.dequeue()
                edges(j).foreach { k =>
                  if (ith5(m, k) == 0 && !ds.contains(k)) {
                    ds(k) = ds(j) + 1
                    q.enqueue(k)
                  }
                }
              }
              ds.foreach { case (j, d) =>
                val m_ = m + ith5(m, i) * (p5s(j) - p5s(i))
                //println((j, d, fromBase5(m_)))
                if (d > 0 &&
                    (!isHallway(i) || isRoom(j, ith5(m, i)) && rooms(ith5(m, i)).map(ith5(m, _)).forall(x => x == 0 || x == ith5(m, i)) &&
                     !rooms(ith5(m, i)).exists(k => j < k && ith5(m, k) == 0) // Make sure it goes as deep as it can into the room... this makes a big performance difference!
                     ) &&
                    (isHallway(i) || isHallway(j) && !isImmediatelyOutsideRoom(j)) &&
                    !energies.contains(m_)) {
                  pq.enqueue((
                    energy - d * Math.pow(10, ith5(m, i) - 1).toInt,
                    m_,
                  ))
                }
              }
            }
          }
        }
      }
      None
    }
  }

  def part1: Unit = {
    val ls = Iterator.continually(StdIn.readLine()).takeWhile(_ != null).toSeq
    (new Solver(2).solve(ls)).foreach(println)
  }

  def part2: Unit = {
    val ls0 = Iterator.continually(StdIn.readLine()).takeWhile(_ != null).toSeq
    val ls = ls0.take(3) ++ Seq(
      "  #D#C#B#A#",
      "  #D#B#A#C#",
    ) ++ ls0.drop(3)
    (new Solver(4).solve(ls)).foreach(println)
  }

  def main(args: Array[String]) = {
    part2
  }
}
