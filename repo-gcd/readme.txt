Title: Concurrent GCD
Category: Algorithm
Source: [ETAPS'15](http://etaps2015.verifythis.org/)
Abstract: Nondeterministic implementation of the Euclid's algorithm with termination guarantees
Description:
Find the GCD of two natural numbers using two execution threads, each of which only updates one variable; since AutoProof doesn't support concurrency, we model this aspect with nondeterminism and prove that the algorithm terminates assuming a fair scheduler.
