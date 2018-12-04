## Laboratory 9

*Sarcini Practice*

**1. Sa se creeze proceduri stocate in baza exercitiilor (2 exercitii) din capitolul 4. Parametrii de intrare trebuie sa corespunda criteriilor din clauzele WHERE ale exercitiilor respective**

![](https://github.com/nadiusa/Data_Base/blob/master/Lab9/Lab9photos/procedure1.a.PNG)

![](https://github.com/nadiusa/Data_Base/blob/master/Lab9/Lab9photos/procedure1.b.PNG)

**2. Sa se creeze o procedura stocata, care nu are niciun parametru de intrare si poseda un parametru de iesire. Parametrul de iesire   trebuie sa returneze numarul de studenti, care nu au sustinut cel putin o forma de evaluare (nota mai mica de 5 sau valoare NULL).**

![](https://github.com/nadiusa/Data_Base/blob/master/Lab9/Lab9photos/procedure2.PNG)

**3. Sa se creeze o procedura stocata, care ar insera in baza de date informatii despre un student nou. In calitate de parametri de intrare sa serveasca datele personale ale studentului nou si Cod_ Grupa. Sa se genereze toate intrarile-cheie necesare in tabelul studenti_reusita. Notele de evaluare sa fie inserate ca NULL.**

![](https://github.com/nadiusa/Data_Base/blob/master/Lab9/Lab9photos/procedure3.PNG)

**4. Fie ca un profesor se elibereaza din functie la mijlocul semestrului. Sa se creeze o procedura stocata care ar reatribui inregistrarile din tabelul studenti_reusita unui alt profesor. Parametri de intrare: numele Si prenumele profesorului vechi, numele Si prenumele profesorului nou, disciplina. In cazul in care datele inserate sunt incorecte sau incomplete, sa se afiseze un mesaj de avertizare.**

![](https://github.com/nadiusa/Data_Base/blob/master/Lab9/Lab9photos/procedure4.PNG)

![](https://github.com/nadiusa/Data_Base/blob/master/Lab9/Lab9photos/procedure4b.PNG)

**5. Sa se creeze o procedura stocata care ar forma o lista cu primii 3 cei mai buni studenti la o disciplina, Si acestor studenti sa le fie marita nota la examenul final cu un punct (nota maximala posibila este 10). In calitate de parametru de intrare, va servi denumirea disciplinei. Procedura sa returneze urmatoarele campuri: Cod_ Grupa, Nume_Prenume_Student, Disciplina, Nota _ Veche, Nota _ Noua.**


**6. Sa se creeze functii definite de utilizator in baza exercitiilor (2 exercitii) din capitolul 4. Parametrii de intrare trebuie sa corespunda criteriilor din clauzele WHERE ale exercitiilor respective.**

![](https://github.com/nadiusa/Data_Base/blob/master/Lab9/Lab9photos/function6a.PNG)

![](https://github.com/nadiusa/Data_Base/blob/master/Lab9/Lab9photos/function6b.PNG)

**7. Sa se scrie functia care ar calcula varsta studentului. Sa se defineasca urmatorul format al functiei: <numeJ uncfie>(<Data _ Nastere_ Student>).**
  
  ![](https://github.com/nadiusa/Data_Base/blob/master/Lab9/Lab9photos/function7.PNG)
  
**8. Sa se creeze o functie definita de utilizator, care ar returna datele referitoare la reusita unui student. Se defineste urmatorul format al functiei:<nume Juncfie> (<Nume_Prenume_Student>). Sa fie afisat tabelul cu urmatoarele campuri: Nume_Prenume_Student, Disticplina, Nota, Data_Evaluare.**
  
  ![](https://github.com/nadiusa/Data_Base/blob/master/Lab9/Lab9photos/function8.PNG)
  
  **9. Se cere realizarea unei functii definite de utilizator, care ar gasi cel mai sarguincios sau cel mai slab student dintr-o grupa. Se defineste urmatorul format al functiei: numeJuncfie (Cod_ Grupa, is_good). Parametrul is_good poate accepta valorile "sarguincios" sau "slab", respectiv.Functia sa returneze un tabel cu urmatoarele campuri Grupa, Nume_Prenume_Student, Nota Medie , is_good. Nota Medie sa fie cu precizie de 2 zecimale.**
  
 ![](https://github.com/nadiusa/Data_Base/blob/master/Lab9/Lab9photos/function9a.PNG)
 
 ![](https://github.com/nadiusa/Data_Base/blob/master/Lab9/Lab9photos/function9b.PNG)
 
  


