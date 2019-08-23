
domain(rocket).

sequence_task(24,[move(r2, paris, london), move(r1, lyon, paris)],_,_).

sequence_task(23,[move(r2, paris, london), move(r2, london, paris)],_,_).

sequence_task(22,[move(r2, paris, london), move(r2, london, jfk)],_,_).

sequence_task(21,[move(r2, paris, london), move(r1, lyon, paris), move(r2, london, paris)],_,_).

sequence_task(20,[move(r2, paris, london), move(r1, lyon, paris), move(r2, london, jfk)],_,_).

sequence_task(19,[move(r2, paris, london), move(r1, lyon, paris), move(r1, paris, london)],_,_).

sequence_task(18,[move(r2, paris, london), move(r1, lyon, paris), move(r2, london, paris), move(r1, paris, london)],_,_).

sequence_task(17,[move(r2, paris, london), move(r1, lyon, paris), move(r2, london, paris), move(r1, paris, lyon)],_,_).

sequence_task(16,[move(r2, paris, london), move(r1, lyon, paris), move(r2, london, paris), move(r1, paris, jfk)],_,_).

sequence_task(15,[move(r2, paris, london), move(r1, lyon, paris), move(r2, london, paris), move(r1, paris, lyon), load(c1, r1, lyon)],_,_).

sequence_task(14,[move(r2, paris, london), move(r1, lyon, paris), move(r2, london, paris), move(r1, paris, lyon), load(c2, r1, lyon)],_,_).

sequence_task(13,[move(r2, paris, london), move(r1, lyon, paris), move(r2, london, paris), move(r1, paris, lyon), load(c3, r1, lyon)],_,_).

sequence_task(12,[move(r2, paris, london), move(r1, lyon, paris), move(r2, london, paris), move(r1, paris, lyon), load(c1, r1, lyon), load(c2, r1, lyon)],_,_).

sequence_task(11,[move(r2, paris, london), move(r1, lyon, paris), move(r2, london, paris), move(r1, paris, lyon), load(c1, r1, lyon), load(c3, r1, lyon)],_,_).

sequence_task(10,[move(r2, paris, london), move(r1, lyon, paris), move(r2, london, paris), move(r1, paris, lyon), load(c1, r1, lyon), load(c4, r1, lyon)],_,_).

sequence_task(9,[move(r2, paris, london), move(r1, lyon, paris), move(r2, london, paris), move(r1, paris, lyon), load(c1, r1, lyon), load(c2, r1, lyon), load(c3, r1, lyon)],_,_).

sequence_task(8,[move(r2, paris, london), move(r1, lyon, paris), move(r2, london, paris), move(r1, paris, lyon), load(c1, r1, lyon), load(c2, r1, lyon), load(c4, r1, lyon)],_,_).

sequence_task(7,[move(r2, paris, london), move(r1, lyon, paris), move(r2, london, paris), move(r1, paris, lyon), load(c1, r1, lyon), load(c3, r1, lyon), load(c4, r1, lyon)],_,_).

sequence_task(6,[move(r2, paris, london), move(r1, lyon, paris), move(r2, london, paris), move(r1, paris, lyon), load(c1, r1, lyon), load(c2, r1, lyon), load(c3, r1, lyon), load(c4, r1, lyon)],_,_).

sequence_task(5,[move(r2, paris, london), move(r1, lyon, paris), move(r2, london, jfk), move(r1, paris, lyon), load(c1, r1, lyon), load(c2, r1, lyon), load(c3, r1, lyon), load(c4, r1, lyon)],_,_).

sequence_task(4,[move(r2, paris, london), move(r2, london, paris), load(c1, r1, lyon), move(r1, lyon, paris), unload(c1, r1, paris), move(r1, paris, lyon), load(c2, r1, lyon), load(c3, r1, lyon)],_,_).

sequence_task(3,[move(r2, paris, london), move(r2, london, paris), load(c1, r1, lyon), move(r1, lyon, paris), unload(c1, r1, paris), move(r1, paris, lyon), load(c2, r1, lyon), load(c3, r1, lyon), load(c4, r1, lyon)],_,_).

sequence_task(2,[move(r2, paris, london), move(r2, london, paris), load(c1, r1, lyon), load(c2, r1, lyon), move(r1, lyon, paris), unload(c1, r1, paris), unload(c2, r1, paris), move(r1, paris, lyon), load(c3, r1, lyon)],_,_).

sequence_task(1,[move(r2, paris, london), move(r2, london, paris), load(c1, r1, lyon), load(c2, r1, lyon), move(r1, lyon, paris), unload(c1, r1, paris), unload(c2, r1, paris), move(r1, paris, lyon), load(c4, r1, lyon)],_,_).

