# 10. hét: Többváltozós regresszió

**A prezentációt készítette: Tőkés László**

*Bevezetés az empirikus közgazdaságtanba*

*2025/26/1*

---

## Prezentáció a Békés-Kézdi-féle adatelemzés könyvhöz

![ADATELEMZÉS könyvborító](https://raw.githubusercontent.com/tokesl/gda-public/main/presentations/images/ch10_multivariate_regression/cover.png)

- Alinea Kiadó, 2024
- [gabors-data-analysis.com](https://gabors-data-analysis.com)
    - Adatok és kódok elérhetőek itt: [gabors-data-analysis.com/data-and-code/](https://gabors-data-analysis.com/data-and-code/)
- Prezentáció a 10. fejezethez

---

## Bevezetés

- Emlékeztető: 4. házi feladat → korreláció szálláshelyek ára és központtól vett távolsága között.
- Az ár függ a távolságtól: `price_E = 151 - 12 * distance`
    - A közelség miatt drágábbak a szálláshelyek?
    - Valószínűleg igen. De csak részben.
- A szálláshelyek ára a minősítésüktől is függ: `price_E = -17 + 43 * stars`
- Azt is látjuk továbbá, hogy a közelebb lévő szálláshelyek jellemzően jobbak is: `Corr(distance, stars) = -0.177`.
- Mi a baj tehát az első regresszióval?
    - Megoldás: többváltozós regresszió.

---

## Motiváció

Hogyan tudnánk felhasználni az adatokat arra, hogy megtaláljuk azokat a szállodákat, amelyek az összes jellemzőjükhöz képest olcsónak számítanak?

---

## Többváltozós lineáris regresszió: mikor és miért?

Három okból végezhetünk az egyváltozós helyett többváltozós regresszióelemzést:
- Több kapcsolati mintázatot szeretnénk feltárni.
- Minél jobb predikciót szeretnénk készíteni → szeretnénk a szóródás nagyobb részét megmagyarázni.
- Szeretnénk ok-okozati kapcsolatot feltárni → szeretnénk jobban összehasonlítható megfigyeléseket összehasonlítani.

---

## Többváltozós lineáris regresszió: alapok

- A többváltozós regresszióelemzés y átlagát egynél több x változó függvényeként tárja fel: `yE = f(x1, x2, ...)`
- A többváltozós lineáris regresszió y átlagát a magyarázó változók lineáris függvényeként specifikálja.
  `yE = β0 + β1x1 + β2x2 + ... + βkxk`
- Alapja: y különböző értékeit x különböző értékei szerint és z hasonló értékei mellett hasonlítjuk össze (4. hét).
    - további feltételes összevetés; feltételes összehasonlítás

---

## Két magyarázó változó esete

`yE = β0 + β1x1 + β2x2`

- `β1` megmutatja, hogy átlagosan mennyivel nagyobb y értéke azoknál a megfigyeléseknél, amelyeknél x1 egy egységgel nagyobb, míg x2 azonos értékű.
- `β2` megmutatja, hogy átlagosan mennyivel nagyobb y értéke azoknál a megfigyeléseknél, amelyeknél x2 egy egységgel nagyobb, míg x1 azonos értékű.
- Összehasonlítja azokat a megfigyeléseket, amelyek az egyik magyarázó változóban azonosak annak érdekében, hogy megmutassa a másik magyarázó változóhoz tartozó különbségeket.

A két magyarázó változó esete vizuálisan egy lineáris sík illesztését jelenti:

![Lineáris sík](https://raw.githubusercontent.com/tokesl/gda-public/main/presentations/images/ch10_multivariate_regression/3d_plane.png)
*Kép forrása: Datacadamia.*

- Még mindig a hibák négyzetösszegét minimalizáljuk:
  `min Σ(yi - β0 - β1xi1 - β2xi2)^2`
- K változó esetén egy K dimenziós lineáris síkot illesztünk.

---

### Feladat: 1. feladat
1) Futtasson egy regressziót, ahol az árat magyarázza a távolsággal és az értékeléssel! Értelmezze a kapott együtthatókat!

---

## A kihagyott változók miatti torzítás

### Többváltozós vs. egyváltozós regresszió

Hasonlítsuk össze az egyváltozós regresszió meredekségi együtthatóját (β) a többváltozóséval (β1):

- Egyváltozós: `yE = α + βx1`
- Többváltozós: `yE = β0 + β1x1 + β2x2`

β és β1 összehasonlításához futtassuk x2 regresszióját x1-en (x – x regreszió):
`x2E = γ + δx1`

Helyettesítsük ezt be a többváltozós regresszióba:
`yE = β0 + β1x1 + β2(γ + δx1) = (β0 + β2γ) + (β1 + β2δ)x1`

Látható, hogy:
`β = β1 + δβ2`

### Különbség a meredekségekben: torzítás

Tehát:
- Egyváltozós regresszió: `yE = α + βx1`
- Többváltozós regresszió: `yE = β0 + β1x1 + β2x2`
Vagyis:
- x1 együtthatója: `β = β1 + δβ2`

Az egyváltozós regresszióban az x1 meredeksége eltér a többváltozós regresszióbeli meredekségétől. Két kivétel:
- x1 és x2 korrelálatlan (δ = 0)
- a többváltozós regresszióban x2 meredeksége nulla (β2 = 0).

Azt mondjuk, hogy a β együttható torzított.

### Különbség a meredekségekben: miből fakad a torzítás?

- Az egyváltozós regresszióban figyelmen kívül hagyjuk az x2-beli különbségeket, és azokat a megfigyeléseket hasonlítjuk össze, amelyek különböző x1 értékkel rendelkeznek.
- Ha x1 és x2 korrelált, akkor számít, hogy olyan megfigyeléseket hasonlítunk-e össze, amelyek ugyanolyan, vagy eltérő x2 értékkel rendelkeznek.
    - Például, pozitív korreláció esetén a nagyobb x1 értékek nagyobb x2 értékeket is jelentenek.
    - Ennek megfelelően tehát a megfelelő y-beli különbségek tehát nemcsak az x1-beli különbségekből, hanem az x2-beli különbségekből is adódhatnak.
- Példa: női bérhátrány - iparág
- Az egyébként fontos x2 figyelmen kívül hagyása kihagyott változók miatti torzításhoz vezet.

### A kihagyott változó okozta torzítás: a megoldás

Ha egy együttható értékére vagyunk kíváncsiak, a kihagyott változók fontosak:
- Ha van egy mérőszám/változó x2-re, akkor használjuk és a probléma megoldva.
- Ha nincs mérőszám/változó x2-re, akkor...
    - gondolkozzunk és "spekuláljunk"!
    - A 'valódi' paraméter a becsültnél vajon kisebb vagy nagyobb?

### A kihagyott változó okozta torzítás: a megoldás (folyt.)

- Legyen az elméleti összefüggés: `yE = β0 + β1x + β2z`
- Probléma: z-re nincs változónk, ezért a becsült modell: `yE = β̂0 + β̂1x`
- Tudjuk, hogy z fontos változó! Honnan tudjuk?
- Azt is tudjuk, hogy `Corr(x, z) ≠ 0`. Honnan tudjuk?
- A torzítás irányát meg tudjuk határozni:

| | Corr(x, z) > 0 | Corr(x, z) < 0 |
|---|---|---|
| **β2 > 0** | Pozitív torzítás | Negatív torzítás |
| **β2 < 0** | Negatív torzítás | Pozitív torzítás |

---

### Feladat: 1. feladat (folyt.)

2) Futtasson egy egyváltozós regressziót, ahol az árat magyarázza a távolsággal. Értelmezze az együtthatókat!
3) Mit gondol, milyen kapcsolat van az ár és a csillagok száma között? Miért?
4) Mit gondol, milyen kapcsolat van a csillagok száma és a távolság között? Miért?
5) Ellenőrizze az adatokon az előző két pontra adott válaszát!
6) Az előzőek alapján mit gondol, hogyan változik a 2)-es ponthoz képest a távolság becsült együtthatója, ha a csillagok számát is betesszük a bal oldalra?
7) Becsülje meg a kérdéses többváltozós regressziót és értelmezze az eredményeket!

---
## A többváltozós regresszió terminológiája

- Az y változó különbsége az x1 szerint, feltéve, hogy x2 változatlan:
    - x2 rögzítése melletti feltételes különbség
    - kontrollálunk x2-re
    - x2-t rögzítve
    - x2-t változatlannak feltételezve
- Amikor a többváltozós regresszióban az x1 változóra összpontosítunk, akkor x2-t kovariánsnak, vagy összemosó változónak is nevezzük.
    - Ha az x1 meredeksége más lesz, amikor x2-t kihagyjuk, akkor azt mondjuk, hogy x2 összemossa az y és az x1 közötti kapcsolatot.

---
## A konfidenciaintervallum

Számos dologban ugyanaz, mint az egyváltozós regresszió esetében:
- Jelentése.
- Közepe.
- Kiszámolása.

A standard hiba viszont más! Az egyszerű képlet:
`SE(β̂1) = Std[e] / (√n * Std(x1) * √(1 - R1^2))`

- Az SE kicsi, ha: a maradéktag szórása kicsi; a minta nagy; x1 szórása nagy.
- Minél nagyobb az x1 és x2 közötti korreláció (R1), annál nagyobb β1 standard hibája.

---
## Multikollinearitás

### Magyarázó változók kollinearitása
A β standard hibája tehát: `SE(β̂1) = Std[e] / (√n * Std(x1) * √(1 - R1^2))`

- **Tökéletes kollinearitásról** beszélünk, amikor x1 és x2 között 1 vagy -1 a lineáris korrelációs együttható (azaz, egymás lineáris függvényei):
    - Egyik együttható SE-je sem létezik.
    - Az együtthatókat nem lehet kiszámolni (az egyiket kidobja a szoftver).
- A magyarázó változók közötti erős, de nem tökéletes korrelációt **multikollinearitásnak** nevezzük:
    - Ilyenkor a meredekségi együtthatók és standard hibáik meghatározhatóak, de:
        - a standard hibák nagyok lehetnek.
        - a β értékét nem befolyásolja.
    - Megoldási lehetőségek: egyik kidobása; a kettő változó kombinálása.

---
## Hipotézistesztelés

- Az egyes β-kra vonatkozó hipotézistesztek ugyanazok, mint az egyváltozós esetben.
- **Együttes hipotézistesztelés**: olyan nullhipotézis, amely egynél több regressziós együtthatóra vonatkozó állítást tartalmaz.
- Tesztelhetjük, hogy a regresszióban az összes meredekségi együttható értéke nulla-e. → **"globális F-teszt"**
    - A teljes modell magyarázóerejét vizsgálja.

### Feladat: 1. feladat (folyt.)
8) Értelmezze a 7)-es pontban becsült modell globális F-tesztjét!

---

## Több magyarázó változó

- Több magyarázó változó bevonása egy egyértelmű kiterjesztés:
  `yE = β0 + β1x1 + β2x2 + β3x3 + ...`
- x1 együtthatójának értelmezése: y értéke az adatokban átlagosan β1 egységgel nagyobb azoknál a megfigyeléseknél, amelyeknél az x1 egy egységgel nagyobb, de a többi x változó értéke azonos.
- Az (egyszerű) SE képlet:
  `SE(β̂k) = Std[e] / (√n * Std[xk] * √(1 - Rk^2))`
- SE kicsi, amikor Rk^2 kicsi
    - xk összes többi x-en futtatott regressziójának R2-e.

---
## Kvalitatív magyarázó változó

### Ismétlés: kvantitatív és kvalitatív változók
- Az adatok többféleképpen születhetnek, és a változóink az adott jelenség minőségét vagy mennyiségét írhatják le.
- A kvantitatív változók számokként születnek.
- A kvalitatív változók nem számokként születnek, a megfigyeléseket verbálisan jellemzik és sajátos az értelmezésük (adott kategóriához tartozás).
    - Számokat rendelünk hozzájuk önkényesen.

### Kvalitatív változók használata: alapötlet
- A regresszióba bevonhatunk bináris és egyéb kvalitatív magyarázó változókat is.
- Hogyan vonjuk be ezeket a regressziós modellbe?
    - Ami eleve bináris, azt alakítsuk dummy változóvá és tegyük be.
    - A kettőnél több értékű kvalitatív változóból hozzunk létre minden kategóriára dummy változókat és azokat tegyük be.
        - Pontosabban: ha k különböző értéke van, akkor k-1 dummy változót tegyünk a jobb oldalra.
        - A kihagyott kategóriát nevezzük bázisnak, vagy referenciakategóriának, vagy referenciacsoportnak.

### Kvalitatív változók használata: Példa
- x egy kategorikus változó három értékkel: `low`, `medium` és `high`.
- Az `xm` bináris változó jelezze, ha `x = medium`, `xh` pedig jelezze, ha `x = high`.
- Az `x = low` esetet nem vonjuk be a regresszióba (referenciakategória).
  `yE = β0 + β1xm + β2xh`
- **Értelmezés:**
    - `β0`: y átlagát mutatja meg, ha minden x értéke nulla (`xm = 0` és `xh = 0`), vagyis: y átlagát mutatja meg a referenciakategóriában, `x = low` esetében.
    - `β1`: az y átlagában lévő különbséget mutatja az `x = medium` és `x = low` megfigyelések között.
    - `β2`: az y átlagában lévő különbséget mutatja az `x = high` és `x = low` megfigyelések között.

### Feladat: 1. feladat (folyt.)
9) Futtasson egy regressziót, ahol a bal oldalon az ár van, a jobb oldalon pedig egy dummy változó, amely 1, ha a szálláshely a központtól maximum 2 mérföldre van és 0 egyébként. Értelmezze az eredményeket!
10) Futtasson egy regressziót, ahol a bal oldalon az ár van, a jobb oldalon pedig az `accommodation_type` változó. Értelmezze az eredményeket!

---

## Interakciók

### Interakció: bevezetés
- Amikor egy kvalitatív változó különböző kategóriáira bináris változókat vonunk be a regresszióba, akkor az y átlagos különbségeit tárjuk fel.
    - Példa: bér - nő dummy
- Sokszor azonban egy változó befolyásolja két másik változó közötti kapcsolati mintázatot:
    - A csokiöntetet szeretjük a vaníliafagyin...
    - ... de kifejezetten utáljuk a töltöttkáposzta tetején.
- Az y és x közötti kapcsolat eltérhet egy harmadik változó, z értékei szerint.
    - Példa: A munkahelyi tapasztalattól pozitívan függ a bér, de ez a pozitív hatás a nőknél erősebb.
- Másképp: a megfigyelések egyes részhalmazaiban más-más általános mintázatot figyelhetünk meg.
- Orvostudományi példa: egy hatásmoderáló változó csökkentheti/erősítheti egy gyógyszer emberekre gyakorolt hatását.

### Interakció: fontosabb esetek
- interakció = attól függ
- **Alapeset:** x1 folytonos, D pedig bináris.
- **Több bináris változó esete:** x1 folytonos, D1 és D2 pedig bináris.
- **Folytonos változók esete:** x1 és x2 is folytonos.

### Interakció: alapeset
- Regresszió két magyarázó változóval: x1 folytonos, D pedig bináris, amely két csoportra bontja az adatokat (pl. női vagy férfi munkavállalók).
- Azt szeretnénk megtudni, van-e különbség az y átlaga és az x1 közötti kapcsolatban a D=1, és a D=0 megfigyelések között.

#### Interakció: alapeset (folyt.)
- **Interakció nélküli eset:** `yE = β0 + β1x1 + β2D`
    - Hogy néznek ki a prediktált értékek?
    - Hogy tudnánk lerajzolni?
- **Interakciós eset:** `yE = β0 + β1x1 + β2D + β3(x1 × D)`
    - Hogy néznek ki a prediktált értékek?
    - Hogy tudnánk lerajzolni?
- A két csoport önálló regressziói és a megfigyeléseket összevonó, de egy interakciós tagot tartalmazó regresszió pontosan ugyanazokat az együtthatóbecsléseket adják.
    - Az interakciót tartalmazó, összevont regresszió azonban lehetővé teszi, hogy közvetlenül teszteljük, azonosak-e a meredekségek.

### Interakció: több bináris változó esete
- Általánosíthatunk három (vagy több) csoportra (legyen D1, D2 bináris és x egy folytonos változó):
  `yE = β0 + β1x + β2D1 + β3D2 + β4(D1 × x) + β5(D2 × x)`
- Általánosságban, K darab kategóriával:
  `yE = β0 + β1x + Σ(βk * Dk-1) + βK+k(Dk-1 × x)` (k=2-től K-ig)

### Interakció: két folytonos változó esete
- Ugyanaz a modell, két folytonos változóval, x1 and x2:
  `yE = β0 + β1x1 + β2x2 + β3x1x2`
- **Példa: céges adat**
    - y a bevétel változása, x1 a globális kereslet változása, x2 a cég pénzügyi állapota.
    - Az interakció megmutatja, hogy a kereslet csökkenése csökkenti a bevételt, de az erős mérleggel rendelkező cégek esetében kevésbé.
- Pontos értelmezés: deriválással.

### Feladat: 1. feladat (folyt.)
11) Futtasson egy regressziót, ahol a bal oldalon az ár, a jobb oldalon pedig 9)-es pontban létrehozott dummy, az `offer` dummy és azok interakciója van. Készítsen predikciót és értelmezze az eredményeket!
12) Futtasson egy regressziót, ahol a bal oldalon az ár, a jobb oldalon pedig a 9)-es pontban létrehozott dummy, a `stars` változó és azok interakciója van. Értelmezze az eredményeket!

---
## Regresszió és okság

![Correlation vs Causation](https://raw.githubusercontent.com/tokesl/gda-public/main/presentations/images/ch10_multivariate_regression/corr_caus.png)

### Oksági elemzés többváltozós regresszióval
- Az egyik fő érv a többváltozós regresszióval történő becslés mellett az oksági értelmezéshez történő közelebb kerülés.
- Ami az oksági elemzéshez jó lenne: kísérleti adatok.
    - De az jellemzően nincs, ami van: megfigyeléses adat.
- Más változókra történő kontrollálással közelebb kerülhetünk ahhoz, hogy hasonló dolgokat hasonlítsunk össze még megfigyeléses adatoknál is.
    - De a közelebb kerülés nem egyenlő az eléréssel.
- Elvileg ezen javíthatunk, ha rögzítjük az összes lehetséges összemosó tényezőt: olyan változókat, amelyek egyszerre befolyásolnák y-t és x1-et, az oksági változót.
    - Ceteris paribus = az összes ilyen fontos változóra történő kontrollálás.
- A valóságban mindenre kontrollálni lehetetlen.

---
## Predikció

### Predikció többváltozós regresszióval
- Az egyik ok, amiért többváltozós regressziót becslünk, az a **predikció**.
    - Keressük az yj függő változó legjobb becslését egy adott j célmegfigyelésre.
    `ŷj = β̂0 + β̂1x1j + β̂2x2j + ...`
- Ha a cél a predikció, akkor azt akarjuk, hogy a regresszió a lehető legjobb illeszkedést eredményezze.
    - ‘Jó illeszkedés’ a j célmegfigyelést reprezentáló általános mintázathoz.
- Gyakori veszély az adatok **túlillesztése**: olyan mintázatokat találunk az adatokban, amelyek az általános mintázatban nem igazak.
    - Az R² jó kiindulópont, de nem cél annak a maximalizálása.

### A többváltozós regresszió illeszkedésének vizualizációja
- Az `ŷ – y` diagram vízszintes tengelyén ábrázoljuk az ŷ-ot, függőleges tengelyén pedig az y-t.
    - A diagramon a 45 fokos egyenes és a körülötte lévő pontdiagram szerepel.
- Az egyenes körüli pontdiagram azt mutatja, mennyire térnek el y tényleges értékei az prediktált értékeitől, ŷ-tól.
    - A 45 fokos egyenestől jobbra eső megfigyeléseket túl magasra becsüljük (ŷ > y).
    - A 45 fokos egyenestől balra eső megfigyeléseket túl alacsonyra becsüljük (ŷ < y).

### Feladat: 1. feladat (folyt.)
13) Futtasson egy regressziót, ahol a bal oldalon az ln(ár), a jobb oldalon pedig a távolság, vendégértékelés és csillagok száma van. Készítsen `ŷ - y` diagramot és keresse meg a legjobb ajánlatot!

---
## Összefoglalás

### Összefoglaló tanulságok
- A többváltozós regresszió egy több x változót tartalmazó lineáris modell.
- Bevonhatunk bináris változókat és interakciókat is.
- A többváltozós regresszió közelebb vihet minket az oksági értelmezéshez és segíthet jobb predikciók előállításában.

---
## Házi feladat

A házi feladatban ismét a vendégmunkásokkal szembeni bérdiszkriminációt elemezzük, a múlt heti házi feladatot folytatva. Töltse le [OSF-ről](https://osf.io/gdpq5/), majd nyissa meg a `morg-2014-emp.csv` adattáblát, és hajtsa végre a következőket:
1) Számolja ki az órabért és annak természetes alapú logaritmusát!
2) Tartsa meg azon embereket, akik vagy (i) külföldön születtek és nem amerikai állampolgárok (Foreign Born, Not a US Citizen), vagy (ii) az USA-ban születtek (Native, Born In US). Hozzon létre egy `native` nevű dummy változót, amely 0 az előbbiekre, és 1 az utóbbiakra.

*(A következő oldalon folytatódik!)*

### Házi feladat (folyt.)
3) Vizsgáljuk ismét a "Driver/sales workers and truck drivers" foglalkozási kategóriát (occ2012=9130), a többieket távolítsa el a mintából!
4) A regressziós modellben a következő változókat fogja használni: órabér, a 2)-es pontban létrehozott dummy változó, a munkavállaló kora (age), a munkavállaló neme (sex), valamint a munkavállaló iskolai végzettsége (grade92). Készítsen ezekről a változókról egy táblázatot, amelyben szerepel minden változó esetén (i) annak pontos tartalma, (ii) hogy a változó kvalitatív vagy kvantitatív, és (iii) egy értelmes középértékmutató, valamint ha értelmezhető, akkor egy szóródási mutató. Az adatok részletes dokumentációja [itt](https://osf.io/gdpq5/) elérhető, nézze meg a használandó változókat!
5) Futtasson egy többváltozós regressziót, amelyben bal oldalon a log órabér van, jobb oldalon pedig a következő változók: a 2)-es pontban létrehozott dummy változó, a munkavállaló kora és annak négyzete, a munkavállaló neme, valamint a munkavállaló iskolai végzettsége. Figyeljen, hogy minden változót értelmes módon tegyen be a modellbe! Az eredménytáblát másolja be a Moodle-be feltöltendő dokumentumba.
6) Értelmezze a modell fontosabb eredményeit: R², α, β-k és azok szignifikanciája.
7) Szeretnénk ellenőrizni, hogy vajon különbözik-e a nők és férfiak esetében a "vendégmunkás-bérhátrány". Bővítse úgy az előző modellt, hogy válaszolni tudjon a kérdésre és válaszoljon is! (Hogyan bővítette a modellt és milyen eredményt kapott?)
8) Gondolkozzon el, hogy milyen olyan fontos változók maradhattak ki a modellből, amelyek kihagyása torzítja a `native` nevű dummy változó becsült együtthatóját! Mondjon két példát és írja le azt is, hogy milyen irányba és miért torzítja az adott változó kihagyása a `native` dummy β-ját!
