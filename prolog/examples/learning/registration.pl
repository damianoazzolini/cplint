/* Registration dataset from The ACE Data Mining System User's Manual
https://dtai.cs.kuleuven.be/ACE/doc/ACEuser-1.2.16.pdf

Downloaded from 
https://dtai.cs.kuleuven.be/static/ACE/doc/
*/

/** <examples>
?- induce_par([rand_train],P),test(P,[rand_test],LL,AUCROC,ROC,AUCPR,PR).
?- in(P),test(P,[all],LL,AUCROC,ROC,AUCPR,PR).
?- induce([rand_train],P),test(P,[rand_test],LL,AUCROC,ROC,AUCPR,PR).
*/

:-use_module(library(slipcover)).

:- if(current_predicate(use_rendering/1)).
:- use_rendering(c3).
:- use_rendering(lpad).
:- endif.

:-sc.

:- set_sc(depth_bound,false).
:- set_sc(neg_ex,given).
:- set_sc(megaex_bottom,7).
%:- set_sc(max_iter,2).
%:- set_sc(max_iter_structure,5).
:- set_sc(verbosity,3).

:- bg.
company(jvt,commercial).
company(scuf,university).
company(ucro,university).
course(cso,2,introductory).
course(erm,3,introductory).
course(so2,4,introductory).
course(srw,3,advanced).

job(J):-
	participant(J, _, _, _).
company(C):-
	participant(_, C, _, _).

party_yes :- party(yes).
party_no :- party(no).

company_type(T):-
	company(C),
	company(C, T).

not_company_type(commercial):-
  \+ company_type(commercial).

not_company_type(university):-
  \+ company_type(university).

course_len(C, L):-
	course(C, L, _).
	
course_type(C, T):-
	course(C, _, T).

:- end_bg.

:- in.
party(yes):0.5:-
  company_type(commercial).

party(no):0.5:-
  subscription(A),
  course_len(A,4),
  \+ company_type(commercial).
:- end_in.

fold(all,F):-
  findall(I,int(I),F).

:- fold(all,F),
   sample(4,F,FTr,FTe),
   assert(fold(rand_train,FTr)),
   assert(fold(rand_test,FTe)).


output(party/1).

input(job/1).
input(not_company_type/1).
input(company_type/1).
input(subscription/1).
input(course_len/2).
input(course_type/2).
input(company/1).
input(company/2).
input(participant/4).
input(course/3)/

determination(party/1,job/1).
determination(party/1,not_company_type/1).
determination(party/1,company_type/1).
determination(party/1,subscription/1).
determination(party/1,course_len/2).
determination(party/1,course_type/2).

%modeh(*,[party(yes),party(no)],
%  [party(yes),party(no)],
%  [job/1,company_type/1,subscription/1,course_len/2,course_type/2]).


modeh(*,party(yes)).
modeh(*,party(no)).

modeb(*,job(-#job)).
modeb(*,company_type(-#ctype)).
modeb(*,not_company_type(-#ctype)).
modeb(*,subscription(-sub)).
modeb(*,course_len(+sub,-#cl)).
modeb(*,course_type(+sub,-#ct)).

neg(party(M,yes)):- party(M,no).
neg(party(M,no)):- party(M,yes).

party(M,P):-
        participant(M,_, _, P, _).


begin(model(adams)).
participant(researcher,scuf,no,23).
subscription(erm).
subscription(so2).
subscription(srw).
end(model(adams)).

begin(model(blake)).
participant(president,jvt,yes,5).
subscription(cso).
subscription(erm).
end(model(blake)).

begin(model(king)).
participant(manager,ucro,no,78).
subscription(cso).
subscription(erm).
subscription(so2).
subscription(srw).
end(model(king)).

begin(model(miller)).
participant(manager,jvt,yes,14).
subscription(so2).
end(model(miller)).

begin(model(scott)).
participant(researcher,scuf,yes,94).
subscription(erm).
subscription(srw).
end(model(scott)).

begin(model(turner)).
participant(researcher,ucro,no,81).
subscription(so2).
subscription(srw).
end(model(turner)).