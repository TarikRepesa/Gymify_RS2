# Gymify – Gym Management & Membership Application

## 📌 Introduction

Gymify je full-stack aplikacija za upravljanje fitness centrom koja omogućava administraciju članova, članarina, treninga i uplata, uz integrisani sistem notifikacija i e-mail servisa putem RabbitMQ-a.

Projekat uključuje ASP.NET Core Web API backend, Flutter desktop aplikaciju, kao i Docker infrastrukturu (SQL Server, RabbitMQ, Email Consumer) za jednostavno i potpuno automatizovano pokretanje sistema.

Gymify je razvijen kao modularna aplikacija sa jasnom arhitekturom servisa, podrškom za autentifikaciju putem JWT-a, primjenom migracija baze podataka, te real-time komunikacijom između servisa putem message broker-a.


Ovaj README fajl objašnjava:
- potrebne tehnologije
- način pokretanja projekta
- testne korisničke podatke
- opcije za testiranje aplikacije 

---

## 🛠️ Tehnologije i alati

Za provjeru i pokretanje projekta potrebno je imati instalirano:

- **Git**
- **Docker & Docker Compose**
- **Visual Studio (2022 ili noviji)**
- **Android Studio**
- **Flutter SDK**
- **.NET SDK (za backend, ako se ručno pokreće)**

---

## 📥 Kloniranje projekta

Projekat se preuzima sa GitHub repozitorija pomoću sljedeće komande:


git clone <GITHUB_REPO_LINK>



## 🔐 Konfiguracija (VAŽNO)

⚠️ **NAPOMENA**

Nakon `git clone`, u repozitoriju se nalazi **šifrirani fajl**: 

EnviormentalPostavke.7z

### Koraci:

🔐 **Šifra arhive:** `FIT`

1. Otvoriti šifrirani fajl `EnviormentalPostavke.7z`
2. Iz njega izvaditi fajl **`.env`**
3. **Prije pokretanja Dockera**, `.env` fajl ubaciti u **root folder projekta**  
   (folder gdje je urađen `git clone`)

⚠️ **Bez ovog koraka Docker servisi se neće pravilno pokrenuti.**

---

## 🐳 Pokretanje Dockera

Kada je `.env` fajl pravilno postavljen, u terminalu (root folder projekta) pokrenuti:


docker compose up -d --build




## ▶️ Pokretanje aplikacije


U projektu se nalazi **šifrirani fajl**:
FIT-RS2-IB180019-DesktopApp.7z

🔐 **Šifra arhive:** `FIT`

Unutar arhive se nalaze:
- **Release/** – `.exe` fajl za pokretanje **desktop aplikacije**

Ovo je **najbrži način** za testiranje aplikacije bez dodatne konfiguracije.

---


## 🧪 Testni korisnički podaci

### 🖥️ Desktop aplikacija

**Admin**
- Username: `tare45`
- Password: `Admin123!`

**Trener**
- Username: `marko78`
- Password: `Trener123!`

**Radnik**
- Username: `nedim89`
- Password: `Radnik123!`

## Email testiranje

Za testiranje dolaska maila na email dummy korisnika
"Tarik Malic (tare45)" koristite:

- **Email:** `healthcaretest190@gmail.com`
- **Password:** 

NAPOMENA 

Molim Vas koristite ove podatke jer oporavak lozinke radi
na principu pronalaska maila koji je u registrovanim korisnicima
`







