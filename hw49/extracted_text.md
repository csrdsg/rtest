# Házi feladat

A házi feladatban a vendégmunkásokkal szembeni bérdiszkriminációt elemezzük. Töltse le
OSF-ről, majd nyissa meg a morg-2014-emp.csv adattáblát, amelyet órán is használ-
tunk, és hajtsa végre a következőket:

1) Számolja ki a log órát!
2) Tartsa meg azon embereket, akik vagy (i) külföldön születtek és nem amerikai
állampolgárok (Foreign Born, Not a US Citizen), vagy (ii) az USA-ban születtek
(Native, Born In US). Hozzon létre egy `native` nevű dummy változót, amely 0 az
előbbiekre, és 1 az utóbbiakra.

A következő oldalon folytatódik!

---

## Házi feladat (folyt.)

Vizsgáljuk a "Driver/sales workers and truck drivers" foglalkozási kategóriát
(occ2012=9130)!

3) Hogy néz ki a `native` dummy változó eloszlása ebben a foglalkozási kategóriában?
4) Végezzen el egy t-tesztet, amelyben azt teszteli, hogy különbözik-e a két csoport
(native) log átlagbére, vagy sem!
5) Futtasson egy regressziót, amelyben az `ln(órabér)`-t magyarázza a `native` dummy
változóval. Számoljon robusztus standard hibákkal! Értelmezze az eredményeket
(α, β és annak t-értéke, p-értéke és konfidenciaintervalluma, valamint R²)! (Az
output táblázatot másolja be a beadandó dokumentumba!)

A következő oldalon folytatódik!

---

## Házi feladat (folyt.)

6) Hasonlítsa össze a t-teszt során kiszámolt két átlagot és különbséget a
regresszióban kapott két paraméterrel! Hogyan kapcsolódnak azok egymáshoz? Az
eredmények alapján mi az elvi kapcsolat a futtatott t-teszt és az egyváltozós
regresszió között?

A következő oldalon folytatódik!

---

## Házi feladat (folyt.)

A külső érvényesség értékeléséhez vizsgáljunk egy másik foglalkozási kategóriát!

7) Futtasson egy újabb regressziót (az előzőhöz hasonlót), ám most használja a
"Surveying and mapping technicians" foglalkozási kategóriát (occ2012=1560).
Értelmezze az eredményeket (α, β és annak t-értéke, p-értéke és
konfidenciaintervalluma, valamint R²)! (Az output táblázatot másolja be a
beadandó dokumentumba!)

8) Mennyire különbözik a két foglalkozási csoportra futtatott regresszió β-ja? Hogyan
értékelné ez alapján a külső érvényességet?

9) A két regresszió eredményei közül melyiket tekinti megbízhatóbbnak? Miért?
Érveljen röviden! (Tipp: érdemes megnézni a regressziós output azon elemeit,
amelyekről tudja micsoda, de még nem foglalkozott vele a házi feladat eddigi
megoldása során.)

10) Mit gondol, a kapott eredmények mennyire jelentenek ténylegesen a
vendégmunkások elleni diszkriminációt? Érveljen röviden!
