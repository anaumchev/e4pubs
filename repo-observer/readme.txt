Title: Observer
Category: Design Pattern
Source: [SAVCBS'07](http://www.eecs.ucf.edu/~leavens/SAVCBS/2007/challenge.shtml) / [SC'14](http://se.inf.ethz.ch/people/polikarpova/sc/)
Abstract: Multiple observers cache the content of a subject object (design pattern).
Description:
Subject stores a collection of observers, each observer has a link back to the subject.
Each observer stores a cache that has to be always synchronized with the subject; the subject updates all observers on every change.
