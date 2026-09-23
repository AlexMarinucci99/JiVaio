<a id="readme-top"></a>

<p align="center">
  <img src="assets/brandlogoname/jivaio_logo_name.png" alt="JiVaio logo" width="320">
</p>

<p align="center">
  App mobile per rendere più semplice, chiaro e immediato l’utilizzo del trasporto pubblico urbano.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-Mobile-blue?logo=flutter" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-Language-blue?logo=dart" alt="Dart">
  <img src="https://img.shields.io/badge/Status-Prototype-orange" alt="Status">
  <img src="https://img.shields.io/badge/License-Proprietary-red" alt="Proprietary License">
</p>

<p align="center">
  <a href="https://github.com/AlexMarinucci99/JiVaio/actions/workflows/flutter-ci.yml">
    <img src="https://github.com/AlexMarinucci99/JiVaio/actions/workflows/flutter-ci.yml/badge.svg" alt="Flutter CI">
  </a>
</p>

---

> **Proprietary project — All Rights Reserved**
>
> Questo repository è reso pubblicamente consultabile esclusivamente per finalità di portfolio, valutazione tecnica e presentazione del progetto.
>
> La disponibilità pubblica del codice sorgente non concede il diritto di utilizzarlo, modificarlo, redistribuirlo, distribuirne versioni derivate, pubblicarlo, commercializzarlo o utilizzarlo per realizzare o distribuire applicazioni derivate.
>
> Per i termini completi fare riferimento al file [LICENSE](LICENSE).

---

<details>
  <summary>Indice</summary>
  <ol>
    <li><a href="#obiettivo-del-progetto">Obiettivo del progetto</a></li>
    <li><a href="#stato-del-progetto">Stato del progetto</a></li>
    <li><a href="#demo-dellapp">Demo dell’app</a></li>
    <li><a href="#funzionalità-principali">Funzionalità principali</a></li>
    <li>
      <a href="#profili-utente">Profili utente</a>
      <ul>
        <li><a href="#utente-guest">Utente guest</a></li>
        <li><a href="#utente-registrato">Utente registrato</a></li>
      </ul>
    </li>
    <li><a href="#stack-tecnologico">Stack tecnologico</a></li>
    <li><a href="#architettura">Architettura</a></li>
    <li><a href="#gestione-dei-servizi-esterni">Gestione dei servizi esterni</a></li>
    <li><a href="#testing-e-ci">Testing e CI</a></li>
    <li><a href="#dati-utilizzati">Dati utilizzati</a></li>
    <li><a href="#limitazioni-note">Limitazioni note</a></li>
    <li><a href="#roadmap-futura">Roadmap futura</a></li>
    <li><a href="#team">Team</a></li>
    <li><a href="#licenza">Licenza</a></li>
    <li><a href="#sicurezza">Sicurezza</a></li>
  </ol>
</details>

---

JiVaio è un’app mobile Flutter dedicata al trasporto pubblico urbano dell’Aquila.

L’app nasce con l’obiettivo di rendere più semplice, chiara e immediata la consultazione di linee, fermate, orari e direzioni, aiutando studenti, pendolari, cittadini e visitatori a orientarsi meglio nella rete urbana.

Il progetto è stato realizzato come prototipo accademico nell’ambito del corso di Applicazioni per Dispositivi Mobili del Corso di Laurea in Informatica dell’Università degli Studi dell’Aquila.

<p align="right">(<a href="#readme-top">torna su</a>)</p>

---

## Obiettivo del progetto

Il problema principale affrontato da JiVaio riguarda la difficoltà, spesso riscontrata dagli utenti, nel reperire informazioni chiare e utili sul trasporto pubblico locale.

In particolare, l’app punta a ridurre l’incertezza legata a:

* quale linea prendere;
* quale fermata raggiungere;
* in quale direzione attendere il bus;
* quali orari e corse consultare;
* come ritrovare rapidamente le linee usate più spesso.

JiVaio non nasce come alternativa generica a servizi come Google Maps o Moovit, ma come soluzione focalizzata sul contesto aquilano e sulle esigenze locali degli utenti.

<p align="right">(<a href="#readme-top">torna su</a>)</p>

---

## Stato del progetto

JiVaio è attualmente un **prototipo funzionante**, non ancora un prodotto pronto per il rilascio pubblico.

Sono state implementate le funzionalità principali legate alla consultazione delle linee, autenticazione, mappa, geolocalizzazione e salvataggio delle linee preferite.

Alcune funzionalità più avanzate sono presenti come prototipi o utilizzano sorgenti dati mock e rappresentano possibili sviluppi futuri del progetto.

<p align="right">(<a href="#readme-top">torna su</a>)</p>

---

## Demo dell’app

È stata realizzata una demo video del prototipo JiVaio che mostra il flusso principale dell’applicazione e le funzionalità implementate.

Per limitare l’esposizione pubblica di materiale e account esterni collegati al progetto, la demo non è distribuita direttamente attraverso questo repository.

Il materiale dimostrativo può essere mostrato durante una presentazione o valutazione tecnica del progetto.

<p align="right">(<a href="#readme-top">torna su</a>)</p>

---

## Funzionalità principali

| Funzionalità           | Stato           | Descrizione                                                                              |
| ---------------------- | --------------- | ---------------------------------------------------------------------------------------- |
| Onboarding             | Implementata    | Schermate introduttive che presentano lo scopo dell’app.                                 |
| Accesso guest          | Implementata    | Permette di entrare nell’app senza registrazione.                                        |
| Registrazione e login  | Implementata    | Accesso tramite email e password o Google Sign-In.                                       |
| Recupero password      | Implementata    | Recupero dell’accesso tramite Firebase Authentication.                                   |
| Navigazione principale | Implementata    | Bottom navigation per spostarsi tra le sezioni principali.                               |
| Home con mappa         | Implementata    | Visualizzazione della mappa e delle fermate disponibili.                                 |
| Geolocalizzazione      | Implementata    | Recupero della posizione dell’utente previa autorizzazione.                              |
| Elenco linee           | Implementata    | Lista delle linee urbane disponibili.                                                    |
| Dettaglio linea        | Implementata    | Visualizzazione di fermate, direzioni, orari e informazioni della linea.                 |
| Linee salvate          | Implementata    | Salvataggio persistente delle linee preferite per utenti registrati.                     |
| Ricerca percorso       | Prototipo       | Flusso e schermata dimostrativa basati attualmente su un servizio mock.                  |
| Notifiche e avvisi     | Prototipo       | Centro notifiche implementato a livello di UI e architettura tramite sorgente dati mock. |
| Segnalazioni utenti    | Sviluppo futuro | Funzionalità prevista per ritardi, criticità e informazioni condivise sul servizio.      |

<p align="right">(<a href="#readme-top">torna su</a>)</p>

---

## Profili utente

### Utente guest

L’utente guest può accedere rapidamente all’app senza creare un account.

Può consultare le informazioni principali, visualizzare la mappa, esplorare le linee e aprire il dettaglio delle fermate.

Questa modalità è pensata per utenti occasionali, visitatori o cittadini che vogliono consultare il servizio senza registrarsi.

<p align="right">(<a href="#readme-top">torna su</a>)</p>

### Utente registrato

L’utente registrato accede tramite credenziali personali.

Oltre alle funzioni disponibili per il guest, può salvare le linee preferite e ritrovarle negli accessi successivi.

Questa modalità è pensata soprattutto per studenti, pendolari e utenti abituali del trasporto pubblico.

<p align="right">(<a href="#readme-top">torna su</a>)</p>

---

## Stack tecnologico

Il progetto è stato sviluppato utilizzando:

* **Flutter** per la realizzazione dell’app mobile cross-platform;
* **Dart** come linguaggio di programmazione;
* **Provider** e **ChangeNotifier** per la gestione reattiva dello stato;
* **Firebase Authentication** per registrazione, login e recupero password;
* **Cloud Firestore** per il salvataggio persistente di dati associati agli utenti;
* **Google Sign-In** per l’autenticazione tramite account Google;
* **Flutter Map** per la visualizzazione della mappa;
* **LatLong2** per la gestione delle coordinate geografiche;
* **Geolocator** per il recupero della posizione dell’utente;
* **SharedPreferences** per la persistenza locale di preferenze dell’app;
* **dati GTFS elaborati localmente** per linee, fermate, corse e orari;
* **Git e GitHub** per versionamento e collaborazione;
* **GitHub Actions** per l’esecuzione automatizzata dei controlli CI.

Tra gli strumenti utilizzati durante lo sviluppo sono inoltre presenti:

* **Flutter Test**;
* **Flutter Lints**;
* **Flutter Native Splash**;
* **Flutter Launcher Icons**;
* **Figma** per la progettazione dell’interfaccia.

<p align="right">(<a href="#readme-top">torna su</a>)</p>

---

## Architettura

Il progetto segue una struttura modulare basata sulla separazione tra interfaccia, logica applicativa e accesso ai dati.

L’organizzazione generale è ispirata a un approccio di tipo MVVM, con:

* **View / Widget** per la parte grafica e l’interazione con l’utente;
* **ViewModel** per la gestione dello stato e della logica relativa alla UI;
* **Repository** come livello intermedio tra logica applicativa e accesso ai dati;
* **Service** per interazioni con Firebase, geolocalizzazione, persistenza locale, dati mock e altre sorgenti;
* **Model** per rappresentare le entità principali del dominio.

Il flusso generale delle dipendenze può essere rappresentato come:

```text
View
  ↓
ViewModel
  ↓
Repository
  ↓
Service
  ↓
Data Source
```

Questa organizzazione permette di mantenere separate le responsabilità dei diversi componenti, ridurre l’accoppiamento tra UI e sorgenti dati e rendere il progetto più semplice da mantenere, testare ed estendere.

NOTA: La struttura seguente mostra le directory più rilevanti per comprendere l’organizzazione generale del progetto. Il repository completo contiene anche altri file e cartelle di configurazione, piattaforma e supporto allo sviluppo.

```text
JiVaio/
|
├── lib/
│   ├── main.dart
│   ├── jivaio_app.dart
│   ├── config/
│   ├── data/
│   │   ├── gtfs/
│   │   ├── repositories/
│   │   └── services/
│   ├── domain/
│   │   ├── exceptions/
│   │   └── models/
│   ├── routing/
│   ├── ui/
│   │   ├── core/
│   │   │   ├── themes/
│   │   │   └── widgets/
│   │   ├── auth/
│   │   │   ├── view_model/
│   │   │   └── widgets/
│   │   ├── home/
│   │   │   ├── view_model/
│   │   │   └── widgets/
│   │   ├── lines/
│   │   │   ├── view_model/
│   │   │   └── widgets/
│   │   ├── main_navigation/
│   │   ├── notifications/
│   │   │   ├── view_model/
│   │   │   └── widgets/
│   │   ├── onboarding/
│   │   │   └── widgets/
│   │   ├── route_results/
│   │   │   ├── view_model/
│   │   │   └── widgets/
│   │   └── settings/
│   │       └── widgets/
│   └── utils/
├── test/
└── README.md
```

<p align="right">(<a href="#readme-top">torna su</a>)</p>

---

## Gestione dei servizi esterni

JiVaio utilizza alcuni servizi esterni per funzionalità specifiche dell’applicazione.

Firebase viene utilizzato per:

* autenticazione degli utenti;
* recupero password;
* Google Sign-In;
* persistenza di informazioni associate agli utenti autenticati.

La configurazione operativa degli ambienti esterni, le informazioni di deployment e gli eventuali valori sensibili non vengono documentati pubblicamente all’interno del README.

L’accesso ai servizi backend deve essere protetto tramite gli opportuni meccanismi di autenticazione, autorizzazione, Firebase Security Rules e ulteriori strumenti di sicurezza applicabili.

Eventuali segreti, credenziali, certificati o configurazioni private non devono essere inclusi nel repository pubblico.

<p align="right">(<a href="#readme-top">torna su</a>)</p>

---

## Testing e CI

JiVaio utilizza `flutter_test` per verificare il comportamento dei modelli di dominio e dei componenti dell’interfaccia. La suite è organizzata per livelli e feature nella directory [`test/`](test/README.md), in coerenza con la separazione tra UI, ViewModel e Data Layer.

La suite aggiornata comprende **13 file di test**: un unit test e 12 file di widget test. Il resoconto incluso in `test/README.md` documenta **58 test superati (1 unit test e 57 widget test)**, senza fallimenti o test saltati.

### Test automatizzati

| Ambito | File di test | Comportamenti verificati |
| --- | --- | --- |
| Modello delle linee | `domain/models/transit_line_test.dart` | Riconoscimento e normalizzazione delle linee monodirezionali. |
| Autenticazione | `ui/auth/auth_choice_screen_test.dart` | Passaggio tra login e registrazione, validazione, visibilità password, invio dei dati, gestione di caricamento ed errori, guest, accesso Google e recupero password. |
| Recupero password | `ui/auth/reset_password_screen_test.dart` | Validazione e normalizzazione email, invio, stato di caricamento, conferma ed errore. |
| Onboarding | `ui/onboarding/onboarding_screen_test.dart` | Navigazione tra slide, salto, completamento, preferenza di visualizzazione, persistenza simulata e prevenzione dei doppi invii. |
| Ricerca dalla Home | `ui/home/route_search_card_test.dart` | Abilitazione della ricerca, inversione di partenza e destinazione, input incompleti e callback con dati normalizzati. |
| Controlli Home | `ui/home/home_controls_test.dart` | Stato del pulsante GPS, permesso concesso o negato, blocco dei doppi tap e dialogo di conferma/annullamento. |
| Card delle linee | `ui/lines/line_card_test.dart` | Cambio direzione, orari mostrati, callback e casi di direzione unica o assenza di partenze. |
| Elenco linee | `ui/lines/lines_screen_test.dart` | Filtro Tutte/Salvate, salvataggio e rimozione dei preferiti, errori e retry, modalità guest e apertura del dettaglio. |
| Dettaglio linea | `ui/lines/line_detail_screen_test.dart` | Fermate, orari, direzioni, filtri temporali, modalità automatica e segnalazioni dimostrative. |
| Barra di navigazione | `ui/main_navigation/widgets/bottom_nav_bar_test.dart` | Callback delle voci e aggiornamento della selezione accessibile. |
| Centro notifiche | `ui/notifications/notification_center_overlay_test.dart` | Apertura e chiusura, stati vuoto/errore, ordinamento, lettura delle notifiche e badge accessibile. |
| Risultati percorso | `ui/route_results/route_results_screen_test.dart` | Visualizzazione dopo la risposta del servizio mock, navigazione dimostrativa e ritorno alla schermata precedente. |
| Impostazioni | `ui/settings/settings_screen_test.dart` | Profilo guest o autenticato e callback per accesso e logout. |

I percorsi della tabella sono relativi a `test/`. Per i casi di test più dettagliati, l’isolamento delle dipendenze e i limiti della suite si rimanda a [`test/README.md`](test/README.md).

### Isolamento dei test

I widget test esercitano i **ViewModel e Provider effettivamente utilizzati dall’app**, sostituendo le dipendenze dati con fake manuali e dati sintetici. In questo modo verificano le interazioni e gli aggiornamenti della UI senza richiedere Firebase, Firestore, Geolocator, tile della mappa o accesso alla rete. Gli helper condivisi sono raccolti in `test/helpers/`.

### Esecuzione locale

Dalla radice del progetto:

```bash
flutter pub get
flutter analyze
flutter test
```

Per eseguire un singolo file o generare un report di copertura:

```bash
flutter test test/ui/lines/line_detail_screen_test.dart
flutter test --coverage
```

Il report di copertura viene generato in `coverage/lcov.info`. Secondo il resoconto dell’ultima esecuzione incluso in `test/README.md`, i 58 test sono stati superati e la copertura delle righe **nei soli sorgenti presenti nel report LCOV** è pari all’**86,12% (2.079/2.414)**. Il valore non rappresenta la copertura dell’intera applicazione: i file non inclusi nel report non rientrano nel denominatore.

### Limiti della suite

I test della Home verificano componenti isolati, non il rendering completo della mappa. Non sono coperti tramite questi widget test `HomeMap`, `HomeScreen`, `MainNavigationScreen`, `AuthGate`, i servizi esterni reali o l’integrazione end-to-end dei relativi flussi. La suite non include golden test né test su una matrice di dispositivi.

### Continuous Integration

Il repository utilizza **GitHub Actions** per eseguire i controlli automatizzati configurati nel workflow [Flutter CI](https://github.com/AlexMarinucci99/JiVaio/actions/workflows/flutter-ci.yml). Il badge indica lo stato del workflow e non la percentuale di copertura dei test.

[![Flutter CI](https://github.com/AlexMarinucci99/JiVaio/actions/workflows/flutter-ci.yml/badge.svg)](https://github.com/AlexMarinucci99/JiVaio/actions/workflows/flutter-ci.yml)

<p align="right">(<a href="#readme-top">torna su</a>)</p>

---

## Dati utilizzati

JiVaio utilizza dati relativi a linee, fermate, direzioni, corse e orari del trasporto urbano.

I dati vengono elaborati localmente attraverso una struttura derivata dal formato GTFS e sono mantenuti separati dalla UI attraverso il Data Layer.

Una parte importante del lavoro progettuale ha riguardato la raccolta, il controllo e l’organizzazione di questi dati, poiché le informazioni disponibili non erano sempre già pronte in un formato direttamente utilizzabile dall’app.

La qualità dei dati è un aspetto centrale del progetto: informazioni non aggiornate o incomplete possono ridurre l’affidabilità percepita dall’utente.

La presenza dei dati nel repository non modifica eventuali diritti, licenze o condizioni applicabili alle relative fonti originali.

<p align="right">(<a href="#readme-top">torna su</a>)</p>

---

## Limitazioni note

JiVaio è un prototipo accademico e presenta alcune limitazioni:

* la ricerca percorso utilizza attualmente un’implementazione dimostrativa basata su dati mock;
* il sistema non confronta automaticamente più alternative di viaggio attraverso un motore di routing reale;
* il centro notifiche utilizza attualmente una sorgente dati mock e non è ancora collegato a un sistema completo di notifiche push;
* le segnalazioni utenti richiedono ancora meccanismi di conferma, moderazione e scadenza;
* non è presente un’integrazione completa con dati di trasporto pubblico in tempo reale;
* i dati su linee, fermate e orari richiederebbero aggiornamenti continui da fonti ufficiali;
* prima di un eventuale utilizzo in produzione sarebbe necessaria una validazione più ampia del sistema.

<p align="right">(<a href="#readme-top">torna su</a>)</p>

---

## Roadmap futura

Possibili sviluppi futuri:

* implementazione di un vero algoritmo di pianificazione percorso;
* integrazione più completa con dati ufficiali o aggiornati in tempo reale;
* notifiche push personalizzate in base alle linee salvate;
* avvisi su deviazioni, lavori e modifiche temporanee alla viabilità;
* sistema di segnalazioni con conferme da parte della community;
* moderazione e validazione delle segnalazioni;
* ampliamento della suite di test automatici;
* estensione del progetto ad altri contesti locali;
* miglioramento dell’accessibilità e dell’esperienza utente.

<p align="right">(<a href="#readme-top">torna su</a>)</p>

---

## Team

Progetto sviluppato dal team **Master Mobile Devs**.

Componenti:

* Alessandro Marinucci **[@AlexMarinucci99](https://github.com/AlexMarinucci99)**
* Matteo Accurti **[@MattAcc03](https://github.com/MattAcc03)**
* Luca Salvi **[@LucaSalvi1999](https://github.com/LucaSalvi1999)**

Corso: **Applicazioni per Dispositivi Mobili**
Anno accademico: **2025/2026**

<p align="right">(<a href="#readme-top">torna su</a>)</p>

---

## Licenza

JiVaio è un progetto proprietario.

Il codice sorgente e i materiali originali del progetto sono pubblicamente consultabili esclusivamente per finalità di portfolio, valutazione tecnica e presentazione del lavoro svolto.

La disponibilità pubblica del repository non concede automaticamente alcun diritto di utilizzo, copia, modifica, redistribuzione, deployment, commercializzazione o creazione di opere derivate.

Per i termini completi e vincolanti fare riferimento al file [LICENSE](LICENSE).

<p align="right">(<a href="#readme-top">torna su</a>)</p>

---

## Sicurezza

Eventuali vulnerabilità di sicurezza non devono essere segnalate tramite issue, pull request, discussion o altri canali pubblici.

Le segnalazioni devono essere effettuate tramite **GitHub Private Vulnerability Reporting**, secondo quanto indicato nel file [SECURITY.md](SECURITY.md).

Credenziali, token, chiavi private, certificati, file di firma e altre informazioni sensibili non devono essere incluse nel repository.

<p align="right">(<a href="#readme-top">torna su</a>)</p>
