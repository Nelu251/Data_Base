
## Laboratory 6

*Sarcini Practice*

**1.Sa se scrie o instructiune T-SQL, care ar popula coloana Adresa _ Postala _ Profesor 
 din tabelul profesori cu valoarea 'mun. Chisinau', unde adresa este necunoscuta.**
 
 ![photo1](https://github.com/nadiusa/Data_Base/blob/master/Lab6/lab6/lab6.1.PNG)
 
 **2. Sa se modifice schema tabelului grupe, ca sa corespunda urmatoarelor cerinte:
  a) Campul Cod_ Grupa sa accepte numai valorile unice si sa nu accepte valori necunoscute.
  b) Sa se tina cont ca cheie primara, deja, este definita asupra coloanei Id_ Grupa.**
  
  ![photo2](https://github.com/nadiusa/Data_Base/blob/master/Lab6/lab6/lab6.2.PNG)
  ![photo2.1](https://github.com/nadiusa/Data_Base/blob/master/Lab6/lab6/lab6.2.ix.PNG)
  
  **3. La tabelul grupe, sa se adauge 2 coloane noi Sef_grupa si Prof_Indrumator, ambele de tip INT. Sa se populeze campurile nou-create
 cu cele mai potrivite candidaturi in baza criteriilor de mai jos: 
 a) Seful grupei trebuie sa aiba cea mai buna reusita (medie) din grupa la toate formele de evaluare si la toate disciplinele. 
 Un student nu poate fi sef de grupa la mai multe grupe.
 b) Profesorul fndrumator trebuie sa predea un numar maximal posibil de discipline la grupa data. Daca nu exista o singura candidatur, 
 care corespunde primei cerinte, atunci este ales din grupul de candidati acel cu identificatorul (Id_Profesor) minimal.
 Un profesor nu poate fi indrumator la mai multe grupe.
 c) Sa se scrie instructiunile ALTER, SELECT, UPDATE necesare pentru crearea coloanelor in tabelul grupe, pentru 
 selectarea candidatilor si inserarea datelor.**
 
 ![photo3](https://github.com/nadiusa/Data_Base/blob/master/Lab6/lab6/lab6.3.1.PNG)
 ![photo3.1](https://github.com/nadiusa/Data_Base/blob/master/Lab6/lab6/lab6.3.2.PNG)
 
 **4. Sa se scrie o instructiune T-SQL, care ar mari toate notele de evaluare sefilor de grupe cu un punct.
      Nota maximala (10) nu poate fi marita.**
      
![photo41](https://github.com/nadiusa/Data_Base/blob/master/Lab6/lab6/lab6.4.1.PNG)
![photo42](https://github.com/nadiusa/Data_Base/blob/master/Lab6/lab6/lab6.4.2.PNG)

**5. Sa se creeze un tabel profesori_new, care include urmatoarele coloane: Id_Profesor, Nume _ Profesor, Prenume _ Profesor, Localitate, Adresa _ 1, Adresa _ 2. 
a) Coloana Id_Profesor trebuie sa fie definita drept cheie primara si, in baza ei, sa fie construit un index CLUSTERED.
b) Campul Localitate trebuie sa posede proprietatea DEFAULT= 'mun. Chisinau'. 
c) Sa se insereze toate datele din tabelul profesori si tabelul profesori_new. 
Sa se scrie, cu acest scop, un numar potrivit de instructiuni T-SQL. Datele trebuie sa fie transferate in felul urmator: 
Coloana-sursa     Coloana-destinatie 
Id Profesor       Id Profesor 
Nume Profesor     Nume Profesor 
Prenume Profesor  Prenume Profesor 
Adresa Postala Profesor  Localitate 
Adresa Postala Profesor Adresa 1
Adresa Pastala Profesor Adresa 2
In coloana Localitate sa fie inserata doar informatia despre denumirea localitatii din coloana-sursa Adresa_Postala_Profesor. 
In coloana Adresa_l, doar denumirea strazii. in coloana Adresa_2, sa se pastreze numarul casei si (posibil) a apartamentului.**

![photo5](https://github.com/nadiusa/Data_Base/blob/master/Lab6/lab6/lab6.5.11.PNG)
![photo52](https://github.com/nadiusa/Data_Base/blob/master/Lab6/lab6/lab6.5.22.PNG)

**6. Sa se insereze datele in tabelul orarul pentru Grupa= 'CIB171' (Id_ Grupa= 1) pentru ziua de luni.
 Toate lectiile vor avea loc iN blocul de studii 'B'. Mai jos, sunt prezentate detaliile de inserare:
 (ld_Disciplina = 107, Id_Profesor= 101, Ora ='08:00', Auditoriu = 202); 
 (Id_Disciplina = 108, Id_Profesor= 101, Ora ='11:30', Auditoriu = 501);
 (ld_Disciplina = 119, Id_Profesor= 117, Ora ='13:00', Auditoriu = 501);**
 
![photo6](https://github.com/nadiusa/Data_Base/blob/master/Lab6/lab6/lab6.6.PNG)

**7. Sa se scrie expresiile T-SQL necesare pentru a popula tabelul orarul pentru grupa INF171 , ziua de luni.  
Datele necesare pentru inserare trebuie sa fie colectate cu ajutorul instructiunii/instructiunilor SELECT si 
introduse in tabelul-destinatie, stiind ca: 
lectie #1 (Ora ='08:00', Disciplina = 'Structuri de date si algoritmi', Profesor ='Bivol Ion') 
lectie #2 (Ora ='11 :30', Disciplina = 'Programe aplicative', Profesor ='Mircea Sorin') 
lectie #3 (Ora ='13:00', Disciplina ='Baze de date', Profesor = 'Micu Elena')**

![photo71](https://github.com/nadiusa/Data_Base/blob/master/Lab6/lab6/lab6.7.1.PNG)
![photo72](https://github.com/nadiusa/Data_Base/blob/master/Lab6/lab6/lab6.7.2.PNG)

**8. Sa se scrie interogarile de creare a indecsilor asupra tabelelor din baza de date universitatea pentru a asigura o performanta sporita la executarea interogarilor SELECT din Lucrarea practica 4. Rezultatele optimizarii sa fie analizate in baza planurilor de executie, pana la si dupa crearea indecsilor. Indecsii nou-creati sa fie plasati fizic in grupul de fisiere userdatafgroupl (Crearea si intrefinerea bazei de date - sectiunea 2.2.2)**
![photo83](https://github.com/nadiusa/Data_Base/blob/master/Lab6/lab6/quiery1.ix.PNG)
![photo88](https://github.com/nadiusa/Data_Base/blob/master/Lab6/lab6/quiery1.ix.r.PNG)
![photo87](https://github.com/nadiusa/Data_Base/blob/master/Lab6/lab6/quiery2.ix.PNG)
![photo86](https://github.com/nadiusa/Data_Base/blob/master/Lab6/lab6/quiery2.ix.ep.PNG)
![photo85](https://github.com/nadiusa/Data_Base/blob/master/Lab6/lab6/quiery2.ix.ep.r.PNG)
![photo84](https://github.com/nadiusa/Data_Base/blob/master/Lab6/lab6/quiery2.ix.r.PNG)
![photo883](https://github.com/nadiusa/Data_Base/blob/master/Lab6/lab6/quiery3.ix.PNG)
![photo882](https://github.com/nadiusa/Data_Base/blob/master/Lab6/lab6/quiery3.ix.r.PNG)
![photo81](https://github.com/nadiusa/Data_Base/blob/master/Lab6/lab6/lab6.8.1.PNG)
![photo82](https://github.com/nadiusa/Data_Base/blob/master/Lab6/lab6/lab6.8.2.PNG)
![](https://github.com/nadiusa/Data_Base/blob/master/Lab6/lab6/8.PNG
![](https://github.com/nadiusa/Data_Base/blob/master/Lab6/lab6/88.PNG)











