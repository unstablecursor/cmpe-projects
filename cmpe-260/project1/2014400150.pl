:- dynamic(student/2).
:- dynamic(available_slots/1).
:- dynamic(room_capacity/2).

student(1415926, ['ec102', 'cmpe160', 'math102', 'math202']).
student(5358979, ['ec102', 'cmpe240', 'cmpe230', 'math202', 'phys201', 'ee212', 'math102']).
student(3238462, ['phys201', 'ec102', 'math102', 'math202']).
student(6433832, ['ec102', 'cmpe160', 'phys201']).
student(7950288, ['math102']).

available_slots(['m-1', 'm-2', 'm-3', 'w-1', 'w-2', 'w-3', 'f-1', 'f-2', 'f-3']).

room_capacity('nh101', 1).
room_capacity('nh105', 3).
room_capacity('ef106', 5).

%Finds all students as a list.
all_students(StudentList):-
	findall(X, student(X,Y), StudentList).
%Finds all courses as a list.
all_courses(CourseList):-
    findall(Y, student(X,Y), CL), flatten(CL, Q), sort(Q, CourseList).

%Recursive count predicate 'counttt', used in student_count predicate.
counttt(_,[], 0) :- !.
counttt(X, [X|T], N) :- counttt(X, T, M), N is M + 1.
counttt(X, [H|T], N) :- not(X=H),counttt(X, T, N).

%Counts the students in certain course Z.
student_count(Z,StudentCount):-
	findall(Y, student(X,Y), CL), flatten(CL, Q), counttt(Z, Q, StudentCount).
%Recursive count predicate 'count_'  for count_cs predicate
count_(_, _, [], 0) :- !.
count_(X, Y, [X|T], N) :- count_(X, Y, T, M), N is M + 1.
count_(X, Y, [Y|T], N) :- count_(X, Y, T, M), N is M + 1.
count_(X, Y, [H|T], N) :- not(X=H),not(Y=H),count_(X,Y,T, N).
%Recursive count predicate 'count_cs' for counting common students. Uses 'count_' predicate.
count_cs(_, _, [], 0) :- !.
count_cs(X, Y, [H|T], N) :- count_(X, Y, H, W), (W = 2),count_cs(X, Y, T, M), N is M + 1.
count_cs(X, Y, [H|T], N) :- count_(X, Y, H, W), not(W = 2), count_cs(X, Y, T, N).
%Predicate for finding common student number(StudentCount) in course ID1 and course ID2 
common_students(ID1, ID2, StudentCount):-
	findall(Y, student(X,Y), CL), count_cs(ID1, ID2, CL, StudentCount).

%Iteration predicate 'itr' for error1  predicate.
itr(_, [], _, _, 0) :- !.
itr(S, [H|T], N, M, CO) :- nth0(2, H, Q),not(S=Q),itr(S, T, N, M, CO).
itr(S, [H|T], QQ, M, CO) :- nth0(2, H, Q),S=Q, nth0(0, H, QQ), CT=0,itr(S, T, N, M, CT),CO is CT + 1.
itr(S, [H|T], N, QQ, CO) :- nth0(2, H, Q),S=Q, nth0(0, H, QQ), CT=1, itr(S, T, N, M, CT), CO is CT + 1.
%Predicate for finding first error combination in description. Uses itr predicate.
error1(_,[], 0) :- !.
error1(FP,[H|T], G) :- itr(H, FP, N, M, CO),CO=2,common_students(N, M, SC), error1(FP, T, K), G is SC + K.
error1(FP,[H|T], G) :- itr(H, FP, N, M, CO),CO=0, error1(FP, T, K), G is K.
%Predicate for finding second error combination in description.
error2([],0):- !.
error2([H|T], N):-
	nth0(0, H, Cl),nth0(1, H, Ro), room_capacity(Ro, RoCap), student_count(Cl, CoCount), CoCount =< RoCap, error2(T, M), N is M.
error2([H|T], N):-
	nth0(0, H, Cl),nth0(1, H, Ro), room_capacity(Ro, RoCap), student_count(Cl, CoCount), CoCount > RoCap, error2(T, M), N is 1 + M.
%Finds number of conflicts(ErrorCount) in a final plan (FP).
conflict_for_plan(FP, ErrorCount):-
	available_slots(X), error1(FP,X, E1), error2(FP, E2), ErrorCount is E1 + E2.

%Finds room(Y) for certain course(X)
course_to_room(X, Y):- all_courses(CO), room_capacity(Y,H), member(X, CO), student_count(X, J), J =< H.
%Predicate 'lookup' for finding room-time conflicts.
lookup([[_,X,Y]|T], [_,X,Y]):-!.
lookup([[_,A,B]|T], [_,X,Y]):- lookup(T,[_,X,Y]).
%Predicate 'lookup2' for finding course-time conflicts for common students.
lookup2([[A,_,Z]|T], [X,_,Z]):-common_students(X,A,SC), not(SC=0).
lookup2([[A,_,C]|T], [X,_,Z]):- lookup2(T,[X,_,Z]).
%Appends a course(Course) to a final plan(FP) and finds new final plan(NewFP) satisfying conditions.
foo(FP, Course, NewFP):- course_to_room(Course, Room), available_slots(X), member(Slot, X), 
	not(lookup(FP, [Course, Room, Slot])),not(lookup2(FP,[Course, Room, Slot])),append(FP, [Course, Room, Slot], NewFP).
%Recursevely itaretes over courses and appends all to final plan. Starts w/ an empty final plan. 
itrFP([],[]) :-!.
itrFP([H|T], NewFP) :- itrFP(T, X),foo(X, H, NewFP).
%Generates the final plan(FinalPlan.)
final_plan(FinalPlan):-
	all_courses(CourseList), itrFP(CourseList, FinalPlan).
%Clears knowledge base
clear_knowledge_base :- 
	all_students(Q),length(Q, QQ),
	write(' Students deleted : '),write(QQ), nl,
	findall(X, room_capacity(X,_), T),length(T, TT),
	write(' Rooms deleted : '),write(TT), nl,
	available_slots(R), length(R, RR),
	write(' Slots deleted : '),write(RR), nl,
	retractall(student(_,_)), retractall(available_slots(_)),retractall(room_capacity(_,_)).






