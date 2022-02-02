Title: Composite
Category: Design Pattern
Source: [SAVCBS'08](http://www.eecs.ucf.edu/~leavens/SAVCBS/2008/challenge.shtml) / [SC'14](http://se.inf.ethz.ch/people/polikarpova/sc/)
Abstract: A tree with a consistency constraint between parent and children nodes.
Description:
Each tree node stores a collection of its children and its parent; the client is allowed to modify any intermediate node.
A value in each node should be the maximum of all children's values; to maintain the invariant after a modification a node notifies its parent. 
