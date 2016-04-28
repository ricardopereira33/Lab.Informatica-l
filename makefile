#
#Makefile de exemplo para o projeto de LI1
#

all : testA testB testC testD testE doc tex/relatorio.pdf

src/TarefaA: src/TarefaA.hs
	ghc src/TarefaA.hs

src/TarefaB: src/TarefaB.hs
	ghc src/TarefaB.hs

src/TarefaC: src/TarefaC.hs
	ghc src/TarefaC.hs

src/TarefaD: src/TarefaD.hs
	ghc src/TarefaD.hs

src/TarefaE: src/TarefaE.hs
	ghc src/TarefaE.hs

testA: src/TarefaA
	cd tests; bash runtests.sh tA ../src/TarefaA

testB: src/TarefaB
	cd tests; bash runtests.sh tB ../src/TarefaB

testC: src/TarefaC
	cd tests; bash runtests.sh tC ../src/TarefaC

testD: src/TarefaD
	cd tests; bash runtests.sh tD ../src/TarefaD

testE: src/TarefaE
	cd tests; bash runtests.sh tE ../src/TarefaE

doc: docA docB docC docD docE

docA: src/TarefaA.hs
	haddock -h -o doc/TA src/TarefaA.hs

docB: src/TarefaB.hs
	haddock -h -o doc/TB src/TarefaB.hs

docC: src/TarefaC.hs
	haddock -h -o doc/TC src/TarefaC.hs

docD: src/TarefaD.hs
	haddock -h -o doc/TD src/TarefaD.hs

docE: src/TarefaE.hs
	haddock -h -o doc/TE src/TarefaE.hs

tex/relatorio.pdf: tex/relatorio.tex
	cd tex; pdflatex relatorio.tex; pdflatex relatorio.tex

clean: 
	rm -f tests/*.res
	rm -f src/TarefaA.hi src/TarefaA.o src/TarefaB.hi src/TarefaB.o src/TarefaC.hi src/TarefaC.o
	rm -f tex/relatorio.{aux,log,out,toc,lof}

realclean: clean
	rm -rf doc/TA doc/TB doc/TC src/TarefaA src/TarefaB src/TarefaC
	rm -f tex/relatorio.pdf
