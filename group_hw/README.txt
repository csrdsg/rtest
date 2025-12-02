README - Internethasználat és Női Munkaerő-piaci Részvétel Elemzése
=====================================================================

Projekt címe: Az internethasználat és a női munkaerő-piaci részvétel közötti kapcsolat elemzése
Dátum: 2025. november 4.

Csoport információk:
- Csoport száma: [KÉRJÜK TÖLTSE KI A CSOPORT SZÁMÁT]
- Csoport tagjai:
  1. [KÉRJÜK TÖLTSE KI A NÉV 1]
  2. [KÉRJÜK TÖLTSE KI A NÉV 2]
  3. [KÉRJÜK TÖLTSE KI A NÉV 3]
  4. [KÉRJÜK TÖLTSE KI A NÉV 4 - ha van]

Adatforrások:
-------------
Ez az elemzés a Világbank Világfejlesztési Mutatók (WDI) adatbázisából származó adatokat használ:
- Internethasználat (a népesség %-ában): IT.NET.USER.ZS mutató
- Női munkaerő-piaci részvételi arány (%): SL.TLF.CACT.FE.ZS mutató
- Év: 2022
- Országok: Minden elérhető ország teljes adatokkal (203 ország)

Kutatási kérdés:
----------------
Van-e kapcsolat az internethasználat és a női munkaerő-piaci részvételi arány között az országok tekintetében?

Hipotézis:
----------
Pozitív kapcsolatot feltételezünk az internethasználat és a női munkaerő-piaci részvétel között.
Érvelésünk:
- Az internet-hozzáférés jobb hozzáférést biztosít a nők számára az álláslehetőségekhez és a távmunkához
- Az online platformok rugalmas munkavégzési lehetőségeket tesznek lehetővé, amelyek segíthetnek a munka és a családi kötelezettségek egyensúlyban tartásában
- A digitális írástudás és a technológiai hozzáférés kapcsolódik a gazdasági fejlődéshez és a nemek közötti egyenlőséghez

A projekt fájljai:
------------------
1. README.txt - Ez a fájl, amely tartalmazza a projekt leírását és metaadatait
2. analysis.Rmd - R Markdown fájl a teljes elemzési kóddal
3. analysis.html - Az elemzés HTML kimenete eredményekkel és vizualizációkkal
4. IMG_8901.PNG - Feladat utasítások (eredeti képernyőkép)

Szoftverkövetelmények:
----------------------
- R verzió 4.0 vagy újabb
- Szükséges R csomagok:
  * tidyverse (adatkezeléshez és vizualizációhoz)
  * WDI (Világbank adatok letöltéséhez)
  * knitr (R Markdownhoz)
  * rmarkdown (HTML kimenet generálásához)

Hogyan futtassuk az elemzést:
------------------------------
1. Nyissa meg az R-t vagy az RStudiot
2. Telepítse a szükséges csomagokat (ha még nincsenek telepítve):
   install.packages(c("tidyverse", "WDI", "knitr", "rmarkdown"))
3. Nyissa meg az "analysis.Rmd" fájlt
4. Kattintson a "Knit" gombra az RStudioban, vagy futtassa:
   rmarkdown::render("analysis.Rmd")
5. A kimenet "analysis.html" néven lesz generálva

Adatfeldolgozási lépések:
-------------------------
1. Adatok letöltése a Világbank WDI-ból a WDI csomag használatával
2. Szűrés a 2022-es évre
3. Releváns változók kiválasztása (internethasználat és női munkaerő-piaci részvétel)
4. Hiányzó értékek eltávolítása
5. Leíró statisztikák számítása
6. Vizualizációk létrehozása (hisztogramok, dobozdiagramok, pontdiagramok)
7. Korrelációs elemzés elvégzése
8. Eredmények értelmezése

Főbb eredmények:
----------------
- Gyenge negatív korreláció (-0,06) az internethasználat és a női munkaerő-piaci részvétel között
- Átlagos internethasználat: 67,7% (tartomány: 11%-tól 100%-ig)
- Átlagos női munkaerő-piaci részvétel: 50,6% (tartomány: 5,2%-tól 82,6%-ig)
- A pozitív kapcsolat hipotézisét az adatok nem támasztották alá

Megjegyzések:
-------------
- Az elemzés keresztmetszeti (egyetlen év), nem longitudinális
- Az országszintű adatok elfedhetik az országon belüli eltéréseket
- Számos zavaró tényező (kultúra, gazdaság, oktatás) nincs kontrollálva
- A gyenge korreláció azt sugallja, hogy az internet-hozzáférés önmagában nem határozza meg a női munkaerő-piaci részvételt

Kapcsolat:
----------
Az elemzéssel kapcsolatos kérdésekkel kérjük, vegye fel a kapcsolatot a fent felsorolt csoporttagokkal.

Utolsó frissítés: 2025. november 4.
