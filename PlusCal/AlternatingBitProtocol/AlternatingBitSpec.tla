----------------------- MODULE AlternatingBitSpec -----------------------
EXTENDS Integers, Sequences, TLC

CONSTANT Data

Messages == [data: Data, bit : {0,1}]

(* --fair algorithm abSpec {

    variables
        aVar \in {m \in Messages : m.bit = 1},
        bVar = aVar;   
    
    macro addDataToAVar(data) {
        aVar.data := data || aVar.bit := 1-aVar.bit
    }
    
    process(A = "A") {
        a:  while(TRUE) {
                await aVar.bit = bVar.bit;
                with(data \in Data){
                    addDataToAVar(data)
                }
            }
    }

    process(B = "B") {
        b:  while(TRUE){
                await aVar.bit /= bVar.bit;
                bVar := aVar
            }
    }
   

}*)
\* BEGIN TRANSLATION (chksum(pcal) = "71887f2" /\ chksum(tla) = "3d789315")
VARIABLES aVar, bVar

vars == << aVar, bVar >>

ProcSet == {"A"} \cup {"B"}

Init == (* Global variables *)
        /\ aVar \in {m \in Messages : m.bit = 1}
        /\ bVar = aVar

A == /\ aVar.bit = bVar.bit
     /\ \E data \in Data:
          aVar' = [aVar EXCEPT !.data = data,
                               !.bit = 1-aVar.bit]
     /\ bVar' = bVar

B == /\ aVar.bit /= bVar.bit
     /\ bVar' = aVar
     /\ aVar' = aVar

Next == A \/ B

Spec == /\ Init /\ [][Next]_vars
        /\ WF_vars(Next)

\* END TRANSLATION 

ABSpec_TypeOK == (aVar \in Messages) /\ (bVar \in Messages)

EqualityInvariant == (aVar.bit = bVar.bit) => (aVar = bVar)

VariablesChanging == 
    /\ []<>(aVar = bVar) 
    /\ []<>(aVar /= bVar) 

=============================================================================
\* Modification History
\* Last modified Tue Mar 19 15:09:35 CET 2024 by jeujeus
\* Created Thu Mar 14 12:31:59 CET 2024 by jeujeus
