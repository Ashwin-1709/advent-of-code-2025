## Advent of Code 2025
This winter I am trying to learn `lua` with AoC 2025!

Happy Holidays!

```
       SEASONS GREETINGS and the best for the NEW YEAR!
                                               ._...._.
                       \ .*. /                .::o:::::.
                        (\o/)                .:::'''':o:.
                         >*<                 `:}_>()<_{:'
                        >0<@<             @    `'//\\'`    @
                       >>>@<<*          @ #     //  \\     # @
                      >@>*<0<<<      .__#_#____/'____'\____#_#_.
                     >*>>@<<<@<<     [_________________________]
                    >@>>0<<<*<<@<     |=_- .-/\ /\ /\ /\--. =_-|
                   >*>>0<<@<<<@<<<    |-_= | \ \ \ \ \ \\-|-_=-|
                  >@>>*<<@<>*<<0<*<   |_=-=| / // // // / |_=-_|
    \*/          >0>>*<<@<>0><<*<@<<  |=_- | `-'`-'`-'`-' |=_=-|
.___\U//__.    >*>>@><0<<*>>@><*<0<<  | =_-| o          o |_==_|
 \ | | \  |  >@>>0<*<<0>>@<<0<<<*<@<  |=_- | !     (    ! |=-_=|
  \| | _(UU)_ >((*))_>0><*<0><@<<<0<*<|-,-=| !    ).    ! |-_-=|
 \ \| || / //||.*.*.*.|>>@<<*<<@>><0<<|=_,=| ! __(:')__ ! |=_==|
 \_|_|&&_// ||*.*.*.*|_\db//_   (\_/)-|     /^\=^=^^=^=/^\| _=_|
  ""|'.'.'.|~~|.*.*.*|      |  =('Y')=|=_,//.------------.\\_,_|
    |'.'.'.|  |^^^^^^|______|  ( ~~~ )|_,_/(((((((())))))))\_,_|
    ~~~~~~~ ""       `------'  `w---w'|_____`------------'_____|
________________________________________________________________
```

### Solutions
#### Day 1
Brute force the answer
#### Day 2
Break down each operation into $x$ full circles and $y$ partial moves.
#### Day 3
We can find the optimal joltage for each bank using dynamic programming in $O(n * m)$ where $n$ is the length of the bank and $m$ is the number of batteries required to power the bank.
#### Day 4
Brute force the simulation till no more rolls can be removed.
#### Day 5
Brute force check each range whether the ingredient id belongs to it. For the second part we can sort the ranges by $l$ and keep on merging ranges if there is an overlap.
#### Day 7
For the first part, we can do a simple bfs from the starting position $(sx, sy)$ and count the number of splits while also ensuring we do not process the same cell twice.

For the second part, we can use dynamic programming to count the number of timelines. Let $dp(x, y)$ be number of timelines originating from $(x, y)$. The transitions are as follows:
- If character at $(x + 1, y)$ is `.` then $dp(x, y) = dp(x + 1, y)$
- If we have to split at $(x + 1, y)$ then $dp(x, y) = dp(x + 1, y - 1) + dp(x + 1, y + 1)$