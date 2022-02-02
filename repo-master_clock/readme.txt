Title: Master clock
Category: Invariant
Source: [MPC'04](http://research.microsoft.com/en-us/projects/specsharp/friends.pdf) / [SC'14](http://se.inf.ethz.ch/people/polikarpova/sc/)
Abstract: A number of slave clocks are loosly synchronized to a master.
Description:
Master clock has two methods: tick (which increments time) and reset (which resets time to zero). 
Slave clock stores a cache, which should be no greater than master's current time. 
The slaves should be synchronized as rarely as possible, i.e. only after a reset.
