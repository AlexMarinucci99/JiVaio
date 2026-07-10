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
</p>

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
    <li>
      <a href="#setup-del-progetto">Setup del progetto</a>
      <ul>
        <li><a href="#prerequisiti">Prerequisiti</a></li>
        <li><a href="#installazione">Installazione</a></li>
      </ul>
    </li>
    <li><a href="#configurazione-firebase">Configurazione Firebase</a></li>
    <li><a href="#testing">Testing</a></li>
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

- quale linea prendere;
- quale fermata raggiungere;
- in quale direzione attendere il bus;
- quali orari e corse consultare;
- come ritrovare rapidamente le linee usate più spesso.

JiVaio non nasce come alternativa generica a servizi come Google Maps o Moovit, ma come soluzione focalizzata sul contesto aquilano e sulle esigenze locali degli utenti.

<p align="right">(<a href="#readme-top">torna su</a>)</p>

---

## Stato del progetto

JiVaio è attualmente un **prototipo funzionante**, non ancora un prodotto pronto per il rilascio pubblico.

Sono state implementate le funzionalità principali legate a consultazione, autenticazione, mappa, geolocalizzazione e preferiti. Alcune funzionalità più avanzate sono state predisposte a livello di interfaccia o lasciate come sviluppo futuro.

<p align="right">(<a href="#readme-top">torna su</a>)</p>

---

## Demo dell’app

Il seguente video mostra una breve demo del prototipo JiVaio, evidenziando il flusso principale dell’applicazione e le funzionalità implementate.

<p align="center">
  <a href="https://drive.google.com/file/d/1oUQdUdVYBfpxGdUOXvM6BLVRkSu3MaWj/view">
    Guarda la demo dell’app
  </a>
</p>

<p align="right">(<a href="#readme-top">torna su</a>)</p>

---

## Funzionalità principali

| Funzionalità           | Stato             | Descrizione                                                                                                                 |
| ---------------------- | ----------------- | --------------------------------------------------------------------------------------------------------------------------- |
| Onboarding             | Implementata      | Schermate introduttive che presentano lo scopo dell’app.                                                                    |
| Accesso guest          | Implementata      | Permette di entrare nell’app senza registrazione.                                                                           |
| Registrazione e login  | Implementata      | Accesso tramite email e password e Google.                                                                                  |
| Recupero password      | Implementata      | Invio email per reimpostare la password.                                                                                    |
| Navigazione principale | Implementata      | Bottom navigation per spostarsi tra le sezioni principali.                                                                  |
| Home con mappa         | Implementata      | Visualizzazione della mappa e delle fermate disponibili.                                                                    |
| Geolocalizzazione      | Implementata      | Recupero della posizione dell’utente tramite autorizzazione.                                                                |
| Elenco linee           | Implementata      | Lista delle linee urbane disponibili.                                                                                       |
| Dettaglio linea        | Implementata      | Visualizzazione di fermate, direzioni, orari e informazioni della linea.                                                    |
| Linee salvate          | Implementata      | Salvataggio persistente delle linee preferite per utenti registrati.                                                        |
| Ricerca percorso       | Parziale / futura | Presente come flusso e schermata prototipale, ma non collegata a un algoritmo reale di calcolo percorso.                    |
| Notifiche e avvisi     | Parziale / futura | Centro notifiche predisposto, ma non ancora sistema completo di notifiche push automatiche.                                 |
| Segnalazioni utenti    | Parziale / futura | Funzione prevista per ritardi, bus pieni e criticità del servizio; richiede ancora controlli di affidabilità e moderazione. |

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

Il progetto è stato sviluppato con:

- **Flutter** per la realizzazione dell’app mobile cross-platform;
- **Dart** come linguaggio di programmazione;
- **Firebase Authentication** per registrazione, login e recupero password;
- **Cloud Firestore** per il salvataggio persistente dei dati utente, come le linee preferite;
- **Mappe e geolocalizzazione** per mostrare fermate e posizione dell’utente;
- **Provider / ChangeNotifier** per la gestione dello stato;
- **Figma** per la progettazione dei mockup;
- **Git e GitHub** per versionamento e collaborazione.

<p align="right">(<a href="#readme-top">torna su</a>)</p>

---

## Architettura

Il progetto segue una struttura modulare basata sulla separazione tra interfaccia, logica applicativa e accesso ai dati.

L’organizzazione generale è ispirata a un approccio di tipo MVVM, con:

- **View / Widget** per la parte grafica;
- **ViewModel** per stato e logica della UI;
- **Repository** come livello intermedio per l’accesso ai dati;
- **Service** per interazioni con Firebase, sorgenti locali o servizi esterni;
- **Model** per rappresentare le entità principali del dominio.

NOTA: La struttura seguente mostra le directory più rilevanti per comprendere l’organizzazione generale del progetto. Il repository completo contiene anche altri file e cartelle di configurazione, piattaforma e supporto allo sviluppo.

```text
JiVaio/
|
├── lib/
│   ├── main.dart
│   ├── config/
│   ├── data/
│   │   ├── repositories/
│   │   └── services/
│   ├── domain/
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
│   ├── data/
│   ├── domain/
│   ├── ui/
│   └── utils/
|
└── README.md

```

<p align="right">(<a href="#readme-top">torna su</a>)</p>

---

## Setup del progetto

### Prerequisiti

Prima di avviare il progetto è necessario avere installati:

- Flutter SDK;
- Dart SDK;
- Android Studio oppure Visual Studio Code;
- un emulatore Android/iOS oppure un dispositivo fisico;
- Firebase configurato per le funzionalità di autenticazione e Firestore.

<p align="right">(<a href="#readme-top">torna su</a>)</p>

### Installazione

Clonare il repository:

```bash
git clone https://github.com/AlexMarinucci99/JiVaio.git
cd JiVaio
```

Installare le dipendenze:

```bash
flutter pub get
```

Avviare l’app:

```bash
flutter run
```

<p align="right">(<a href="#readme-top">torna su</a>)</p>

---

## Configurazione Firebase

Le funzionalità di autenticazione, recupero password e salvataggio delle linee preferite richiedono Firebase.

Per eseguire correttamente l’app con queste funzionalità è necessario configurare Firebase per il progetto Flutter e assicurarsi che i file di configurazione siano presenti nelle rispettive cartelle di piattaforma.

Esempio:

```bash
flutterfire configure
```

I file di configurazione Firebase non devono contenere credenziali private o dati sensibili non destinati al repository pubblico.

<p align="right">(<a href="#readme-top">torna su</a>)</p>

---

## Testing

Il progetto include una suite di test automatici composta da unit test e widget test.

I test coprono principalmente:

- modelli di dominio;
- ViewModel;
- autenticazione;
- recupero password;
- onboarding;
- ricerca percorso a livello di UI;
- elenco linee;
- dettaglio linea;
- pulsanti di salvataggio;
- centro notifiche;
- componenti principali dell’interfaccia.

Eseguire tutti i test:

```bash
flutter test
```

Generare il report di copertura:

```bash
flutter test --coverage
```

Nell’ultima esecuzione sono stati completati con successo 202 casi di test automatici. Il comando flutter test --coverage ha generato un report LCOV con 1.854 righe coperte su 2.385, corrispondenti a una copertura delle righe pari al 77,74%.

<p align="right">(<a href="#readme-top">torna su</a>)</p>

---

## Dati utilizzati

JiVaio utilizza dati relativi a linee, fermate, direzioni e orari del trasporto urbano.

Una parte importante del lavoro progettuale ha riguardato la raccolta, il controllo e l’organizzazione di questi dati, poiché le informazioni disponibili non erano sempre già pronte in un formato direttamente utilizzabile dall’app.

La qualità dei dati è un aspetto centrale del progetto: informazioni non aggiornate o incomplete possono ridurre l’affidabilità percepita dall’utente.

<p align="right">(<a href="#readme-top">torna su</a>)</p>

---

## Limitazioni note

JiVaio è un prototipo accademico e presenta alcune limitazioni:

- la ricerca percorso non utilizza ancora un algoritmo reale di calcolo;
- il sistema non confronta automaticamente più alternative di viaggio;
- il centro notifiche è predisposto, ma non è ancora collegato a un sistema completo di notifiche push;
- le segnalazioni utenti richiedono ancora meccanismi di conferma, moderazione e scadenza;
- i dati su linee, fermate e orari richiederebbero aggiornamenti continui da fonti ufficiali;
- la validazione con utenti reali è stata limitata a test informali.

<p align="right">(<a href="#readme-top">torna su</a>)</p>

---

## Roadmap futura

Possibili sviluppi futuri:

- implementazione di un vero algoritmo di pianificazione percorso;
- integrazione più completa con dati ufficiali o aggiornati in tempo reale;
- notifiche push personalizzate in base alle linee salvate;
- avvisi su deviazioni, lavori e modifiche temporanee alla viabilità;
- sistema di segnalazioni con conferme da parte della community;
- moderazione e validazione delle segnalazioni;
- estensione del progetto ad altri contesti locali;
- miglioramento dell’accessibilità e dell’esperienza utente.

<p align="right">(<a href="#readme-top">torna su</a>)</p>

---

## Team

Progetto sviluppato dal team **Master Mobile Devs**.

Componenti:

- Alessandro Marinucci
- Matteo Accurti **[@MattAcc03](https://github.com/MattAcc03)**
- Luca Salvi **[@LucaSalvi1999](https://github.com/LucaSalvi1999)**

Corso: **Applicazioi per Dispositivi Mobili**
Anno accademico: **2025/2026**

<p align="right">(<a href="#readme-top">torna su</a>)</p>

---

## Licenza

Progetto realizzato per finalità didattiche e accademiche.

Se il repository include un file `LICENSE`, fare riferimento a quello per i termini di utilizzo.

<p align="right">(<a href="#readme-top">torna su</a>)</p>

---

## Sicurezza

Non pubblicare credenziali, chiavi private o file contenenti informazioni sensibili.

Per eventuali problemi legati alla sicurezza o alla configurazione dei servizi esterni, contattare i maintainer del repository.

<p align="right">(<a href="#readme-top">torna su</a>)</p>
