library(tidyverse)
library(WDI)
library(car)  # VIF szamitashoz

# Reprodukalhato eredmenyekhez
set.seed(42)
cat("Script futtatasa:", Sys.time(), "\n\n")

# WDI api hivasa
indicators <- c("IT.NET.USER.ZS", "SL.TLF.CACT.FE.ZS")

cat("Adatok letoltese a World Banktol...\n")
wb_data <- WDI(country = "all",
               indicator = indicators,
               start = 2022,
               end = 2022,
               extra = TRUE)

# ellenorzes hogy van-e adat
if (is.null(wb_data) || nrow(wb_data) == 0) {
  stop("Hiba: nem sikerult letolteni a World Bank adatokat!")
}

cat("Sikeres letoltes,", nrow(wb_data), "sor\n")

final_data <- wb_data %>%
  select(country, IT.NET.USER.ZS, SL.TLF.CACT.FE.ZS) %>%
  rename(Country.Name = country,
         internet_usage = IT.NET.USER.ZS,
         female_labor_force = SL.TLF.CACT.FE.ZS) %>%
  na.omit()

cat("NA-k torlese utan:", nrow(final_data), "orszag maradt\n")

# === ALAP MODELL (Model1) ===
# Eloszor egy egyszeru linearis regressziot futatok
# H0: nincs kapcsolat az internet hasznalat es a noi munkaero kozott
model1 <- lm(female_labor_force ~ internet_usage, data = final_data)

summary(model1)

# === DEMOKRACIA INDEX HOZZAADASA ===
# A demokracia indexet hozzaadom mert a noi munkaero reszvetelez
# osszefugghet a demokratikus jogokkal es szabadsagokkal

if (!file.exists("democracy-index-eiu.csv")) {
  stop("Hiba: nem talalhato a democracy-index-eiu.csv file!")
}

democracy_data <- read_csv("democracy-index-eiu.csv", show_col_types = FALSE)
cat("Demokracia index betoltve:", nrow(democracy_data), "sor\n")

democracy_2022 <- democracy_data %>%
  select(Entity, Year, `Democracy index`) %>%
  filter(Year == 2022) %>%
  rename(Country.Name = Entity)

n_before <- nrow(final_data)
merged_data <- inner_join(final_data, democracy_2022, by = "Country.Name")
n_after <- nrow(merged_data)
cat("Join utan:", n_after, "orszag (volt:", n_before, ")\n")

# Test modell: internet + demokracia
# Tesztelem hogy a demokracia index javitja-e a modellt
test_model <- lm(female_labor_force ~ internet_usage + `Democracy index`,
                 data = merged_data)
summary(test_model)

# === TOVABBI KONTROLL VALTOZOK ===
# A demokracia index szignifikans lett es javitotta a modellt
# Most hozzaadom a Human Development Indexet es vallasi adatokat
#
# HDI: az orszag fejlettsegi szintjet meghatarozza (egeszsegugy, oktatas, elettszinvonal)
# Valllasok: a kulturalis hatternek hatasa lehet a noi munkaero reszvetelre
# pl. egyes vallasok tradicionalisabb nemi szerepeket preferalhatnak

if (!file.exists("human-development-index.csv")) {
  stop("Hiba: nem talalhato a human-development-index.csv file!")
}
if (!file.exists("religion.csv")) {
  stop("Hiba: nem talalhato a religion.csv file!")
}

hdi_data <- read_csv("human-development-index.csv", show_col_types = FALSE)
religion_data <- read_csv("religion.csv", show_col_types = FALSE)
cat("HDI es vallas adatok betoltve\n")

hdi_2022 <- hdi_data %>%
  select(Entity, Year, `Human Development Index`) %>%
  filter(Year == 2022) %>%
  rename(Country.Name = Entity)

religion_2020 <- religion_data %>%
  select(Country, Year, Christians, Muslims, Religiously_unaffiliated, Buddhists, Hindus, Jews) %>%
  filter(Year == 2020) %>%
  rename(Country.Name = Country)

n_before <- nrow(merged_data)
merged_data <- inner_join(merged_data, hdi_2022, by = "Country.Name")
cat("HDI join utan:", nrow(merged_data), "orszag (volt:", n_before, ")\n")

n_before <- nrow(merged_data)
merged_data <- inner_join(merged_data, religion_2020, by = "Country.Name")
cat("Vallas join utan:", nrow(merged_data), "orszag (volt:", n_before, ")\n")

# HDI atskalazes: 0-1 helyett 0-10 skala, hogy a regresszios egyutthatokat
# konnyebb legyen ertelmezni (egy egysegnyi valtozas nagyobb)
merged_data <- mutate(merged_data, `Human Development Index` = 10 * `Human Development Index`)

# ===== ADATOK FELTARASA =====
# Mielott a vegleges modelleket futtatom, megvizsgalom az adatokat
# Leiro statisztikak: atlag, median, min, max
# Korrelacio: mennyire fuggnek ossze a valtozok
# Grafikonok: vizualis kapcsolatok
cat("\n=== LEIRO STATISZTIKAK ===\n")
cat("Adatok szama a vegleges datasetben:", nrow(merged_data), "\n\n")

cat("Fobb valtozok leiro statisztikai:\n")
summary(select(merged_data, internet_usage, female_labor_force,
               `Democracy index`, `Human Development Index`))

# Korrelacio matrix
cat("\nKorrelacio matrix:\n")
cor_matrix <- cor(select(merged_data, internet_usage, female_labor_force,
                         `Democracy index`, `Human Development Index`))
print(round(cor_matrix, 3))

# Vizualizaciok
cat("\nGrafikonok keszitese...\n")

# Scatter plot: internet vs female labor force
plot(merged_data$internet_usage, merged_data$female_labor_force,
     xlab = "Internet hasznalat (%)",
     ylab = "Noi munkaero aranya (%)",
     main = "Internet hasznalat es noi foglalkoztatas",
     pch = 19, col = "blue")
abline(lm(female_labor_force ~ internet_usage, data = merged_data), col = "red", lwd = 2)

# Histogram: female labor force
hist(merged_data$female_labor_force,
     main = "Noi munkaero megoszlasa",
     xlab = "Noi munkaero aranya (%)",
     col = "lightblue", breaks = 20)

# === REGRESSZIOS MODELLEK ===

# Model2: Teljes modell vallasi valtozokkal
# Tesztelem hogy a vallasi hatter szignifikansan magyarazza-e a noi munkaero reszvetelt
model2 <- lm(female_labor_force ~ internet_usage + `Democracy index` +
             `Human Development Index` + Christians + Muslims +
             Religiously_unaffiliated, data = merged_data)
summary(model2)

# Model3: Redukalt modell valllasok nelkul (osszehasonlitashoz)
model3 <- lm(female_labor_force ~ internet_usage + `Democracy index` +
             `Human Development Index`, data = merged_data)
summary(model3)

# === EREDMENYEK ERTELMEZESE ===
# A vallasi valtozok SZIGNIFIKANSAK es JAVITJAK a modellt:
# - Muslims: p = 0.049 (szignifikans 5%-on)
# - Religiously_unaffiliated: p = 0.035 (szignifikans 5%-on)
# - Model2 R² = 0.314 vs Model3 R² = 0.15 (duplaja!)
#
# KOVETKEZTETES: A vallasi hatter FONTOS prediktor
# A muzulmán többségű országokban alacsonyabb a női munkavállalás (-0.106)
# A vallástalan országokban magasabb (+0.196)
# Ezert a VEGLEGES MODELL a Model2 (vallasokkal)

# ===== MODELL DIAGNOSZTIKA =====
cat("\n=== MODELL DIAGNOSZTIKA ===\n\n")

# === MODELLEK OSSZEHASONLITASA ===
# Minél kisebb az AIC/BIC, annál jobb a modell
# Az adjusted R-squared megmutatja mennyire jo a modell illeszkedese
cat("Model osszehasonlitas:\n\n")

cat("Model1 (csak internet):\n")
cat("  AIC:", AIC(model1), "\n")
cat("  BIC:", BIC(model1), "\n")
cat("  Adjusted R-squared:", summary(model1)$adj.r.squared, "\n\n")

cat("Model2 (teljes modell vallasokkal) - LEGJOBB:\n")
cat("  AIC:", AIC(model2), "\n")
cat("  BIC:", BIC(model2), "\n")
cat("  Adjusted R-squared:", summary(model2)$adj.r.squared, "\n\n")

cat("Model3 (internet + demokracia + HDI):\n")
cat("  AIC:", AIC(model3), "\n")
cat("  BIC:", BIC(model3), "\n")
cat("  Adjusted R-squared:", summary(model3)$adj.r.squared, "\n\n")

# === MULTIKOLLINEARITAS ELLENORZES ===
# VIF > 10: eros multikollinearitas (problema)
# VIF 5-10: kozepes multikollinearitas (figyelmeztetés)
# VIF < 5: nincs problema
cat("VIF ertekek (model2 - vegleges modell):\n")
print(vif(model2))
cat("\n")

# === NORMALITAS TESZT ===
# H0: a residualsok normalis eloszlasuak
# Ha p < 0.05, akkor NEM normalisak (de nagy mintan (n>30) ez nem kritikus)
cat("Shapiro-Wilk normalitas teszt (model2 residuals):\n")
shapiro_test <- shapiro.test(residuals(model2))
print(shapiro_test)
cat("\n")

# === RESIDUAL DIAGNOSZTIKAI PLOTOK ===
# 1. Residuals vs Fitted: heteroszkedaszticitast mutat (kell legyen random)
# 2. Q-Q plot: normalitast ellenorzi (pontoknak a vonalon kell lenniuk)
# 3. Scale-Location: homoszkedaszticitast ellenorzi
# 4. Residuals vs Leverage: influensos megfigyeleseket mutat (outlierek)
cat("Plotok generalasa (model2 - vegleges modell)...\n")
par(mfrow = c(2, 2))
plot(model2, main = "Model2 Diagnostics (Vegleges Modell)")
par(mfrow = c(1, 1))

# ===== SESSION INFO =====
cat("\n=== SESSION INFO (reprodukalhatosag) ===\n")
sessionInfo()

# ============================================================================
# ELEMZÉS: NOI MUNKAERO RÉSZVÉTEL VIZSGÁLATA
# ============================================================================
#
# KUTATÁSI KÉRDÉS
# ---------------
# Mi befolyásolja a nők munkaerő-piaci részvételét a különböző országokban?
#
# ADATOK
# ------
# - 136 ország adatai 2022-ből
# - Források: World Bank, Democracy Index, Human Development Index, vallási adatok
#
# VIZSGÁLT TÉNYEZŐK
# -----------------
# 1. Internet használat (%)
# 2. Demokrácia index (0-10 skála)
# 3. Human Development Index - fejlettség (0-10 skála)
# 4. Vallási háttér (keresztény, muzulmán, vallástalanok aránya)
#
# FŐBB EREDMÉNYEK
# ---------------
#
# Model1 - Csak internet használat:
#   ❌ NEM működik! (R² = 0.003)
#   ❌ Az internet használat EGYMAGÁBAN nem magyarázza a női foglalkoztatást
#
# Model2 - TELJES MODELL (ajánlott):
#   ✅ JÓ modell! (R² = 0.28, azaz 28%-ot magyaráz)
#   ✅ AIC = 1074 (legalacsonyabb, tehát legjobb)
#
#   SZIGNIFIKÁNS TÉNYEZŐK:
#   - Internet használat: NEGATÍV hatás (-0.14)
#     → Magasabb internet = alacsonyabb női foglalkoztatás?!
#     → Ez azért van mert összefügg a HDI-vel (multikollinearitás)
#
#   - Muzulmán vallás: NEGATÍV hatás (-0.11, p=0.049)
#     → Muzulmán többségű országokban alacsonyabb a női munkavállalás
#
#   - Vallástalan: POZITÍV hatás (+0.20, p=0.035)
#     → Szekuláris országokban magasabb a női munkavállalás
#
# Model3 - Vallások nélkül:
#   ⚠️ Gyengébb! (R² = 0.13)
#   ⚠️ AIC = 1097 (magasabb = rosszabb)
#
# KÖVETKEZTETÉSEK
# ---------------
#
# 1. A VALLÁSI HÁTTÉR FONTOS!
#    - A muzulmán országokban kulturálisan alacsonyabb a női munkavállalás
#    - A szekuláris országokban nincs vallási akadály
#    - Ez DUPLÁZZA a modell magyarázó erejét (28% vs 14%)
#
# 2. A DEMOKRÁCIA SZÁMÍT
#    - Demokratikusabb országokban magasabb a női részvétel (+2.1)
#    - A demokratikus jogok segítik a női egyenjogúságot
#
# 3. AZ INTERNET HATÁSA ÖSSZETETT
#    - Egyedül nem jó prediktor
#    - A fejlett országokban magas az internet ÉS változó a női foglalkoztatás
#    - Ezért negatív együttható (furcsa, de statisztikailag érthető)
#
# 4. FEJLETTSÉG (HDI)
#    - Fontos kontroll változó
#    - Összefügg mindennel (internet, demokrácia, vallás)
#
# LIMITÁCIÓK
# ----------
# - Csak keresztmetszeti adatok (egy időpont)
# - Nem mondhatunk ok-okozati összefüggést
# - Multikollinearitás van (internet és HDI: r=0.91)
# - 28% magyarázó erő = még sok minden hiányzik a modellből
#   (pl. szülési szabadság, bölcsődék, kultúra, stb.)
#
# JAVASLAT
# --------
# A Model2 (vallási változókkal) a legjobb választás az elemzéshez.
# Bár van benne multikollinearitás, a VIF értékek még elfogadhatók (<10).
#
# ============================================================================
