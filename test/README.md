# Widget test di JiVaio

La suite usa `flutter_test`, Provider e i ViewModel di produzione. I fake
manuali sostituiscono soltanto le dipendenze dati. Non inizializza Firebase,
Firestore, Geolocator o client delle mappe e non richiede accesso alla rete.
Non sono stati modificati codice di produzione, dipendenze, asset o dati GTFS.

## Analisi e ambito

Prima dell'intervento erano presenti due test: la normalizzazione delle linee
monodirezionali in `domain/models/transit_line_test.dart` e la callback Linee
della barra inferiore. Entrambi sono conservati. Il file della barra viene
esteso con un test delle altre voci e dell'aggiornamento della selezione
accessibile; il comportamento preesistente non viene duplicato.

La struttura `lib/ui/` comprende auth, core, home, lines, main_navigation,
notifications, onboarding, route_results e settings. Le schermate osservano
i rispettivi ChangeNotifier tramite Provider; le impostazioni usano un
ViewModel senza stato mutabile. I repository delegano ai servizi, salvo
`TransitRepository`, che prepara i modelli dai dati GTFS: nei widget test
quest'ultimo viene sostituito direttamente con dati sintetici.

L'elenco linee implementa il filtro Tutte/Salvate, ma non una ricerca testuale.
I preferiti appartengono all'elenco, non alla schermata dettaglio. Il dettaglio
gestisce direzioni, fasce orarie e segnalazioni demo. La pianificazione usa
`MockRoutePlanningService`; il pulsante di navigazione dei risultati mostra
un messaggio di funzionalità non implementata. I test rispettano questi limiti.

## File e comportamenti

I percorsi seguenti sono relativi a `test/`.

| File | Comportamenti verificati |
| --- | --- |
| `ui/lines/line_card_test.dart` | Inversione di origine e orari, callback distinte, direzione unica, assenza di partenze con/senza servizio. |
| `ui/lines/lines_screen_test.dart` | Elenco, filtro e aggiornamenti dei preferiti, salvataggio/rimozione, rollback su errore e richieste duplicate, guest, retry, apertura e chiusura del dettaglio. |
| `ui/lines/line_detail_screen_test.dart` | Fermate ordinate, orari presenti/assenti, cambio direzione, annullamento/conferma filtro, modalità automatica, segnalazioni a bordo/alla fermata e azzeramento selezione. |
| `ui/auth/auth_choice_screen_test.dart` | Cambio modalità, conservazione input, visibilità password, validazione login/registrazione, dati inviati, caricamento, errori, guest, Google e navigazione al recupero password. |
| `ui/auth/reset_password_screen_test.dart` | Input vuoto o non valido, normalizzazione email, invio, caricamento, conferma ed errore di rete. |
| `ui/onboarding/onboarding_screen_test.dart` | Slide, avanti/indietro, salta, completamento, scelta preferenza, attesa scrittura, doppi tap ed errore di persistenza. |
| `ui/home/route_search_card_test.dart` | Attivazione/disattivazione ricerca, spazi vuoti, swap completo/parziale, argomenti normalizzati della callback. |
| `ui/home/home_controls_test.dart` | Pulsante GPS durante richiesta controllata, permesso concesso/negato, prevenzione doppi tap, conferma/annullamento del dialogo. |
| `ui/notifications/notification_center_overlay_test.dart` | Apertura e tre modalità di chiusura, stato vuoto, caricamento controllato e ordinamento, lettura singola/totale, errore e badge accessibile. |
| `ui/route_results/route_results_screen_test.dart` | Aggiornamento al completamento della richiesta, dati ricevuti, messaggio della navigazione demo e ritorno alla schermata precedente. |
| `ui/settings/settings_screen_test.dart` | Profilo guest/autenticato e callback di accesso/logout. |
| `ui/main_navigation/widgets/bottom_nav_bar_test.dart` | Callback delle tre voci e aggiornamento della selezione. File preesistente esteso. |

Gli helper condivisi sono `helpers/widget_test_helpers.dart`,
`helpers/transit_fakes.dart` e `helpers/fake_auth_service.dart`. I fake usati
da una sola feature rimangono privati nel relativo file di test.

## Isolamento e attese

- I ViewModel e Provider rimangono reali; non vengono simulati i loro meccanismi.
- Le risposte asincrone controllate usano `Completer`, creati all'interno del
  test widget. Le notifiche dei preferiti usano uno stream chiuso nel teardown.
- Il pulsante GPS con indicatore continuo viene verificato con `pump`, senza
  attendere che l'animazione termini tramite `pumpAndSettle`.
- Le schermate usano una superficie verticale 430 × 932, ripristinata dopo
  ogni test. Gli elementi delle liste vengono raggiunti tramite scorrimento.
- L'onboarding salva su un fake del servizio preferenze in memoria, nuovo per
  ogni test. Si verifica il valore riletto dal repository, senza scrivere le
  preferenze del dispositivo e senza testare il plugin SharedPreferences.

## Limiti della copertura

`HomeMap` costruisce direttamente `TileLayer` con URL HTTP e senza un punto
di sostituzione del provider delle tile. `HomeScreen` la monta sempre e avvia
anche la localizzazione; `MainNavigationScreen` mantiene Home in un
`IndexedStack`. Per preservare il codice di produzione e impedire richieste
di rete, questi tre widget non vengono montati.

Di conseguenza non sono verificati il rendering/centramento della mappa, i
marker, i gesti, la ripresa dalle impostazioni GPS, il collegamento effettivo
tra gli esiti GPS e i messaggi della Home, il passaggio Home → risultati e il
cambio delle schermate nel contenitore principale. Sono invece testati i
controlli isolati, le callback, la barra inferiore e le schermate di destinazione.
Anche AuthGate, la navigazione conseguente a un cambio di sessione e i servizi
reali restano fuori da questi widget test.

Notifiche e dettaglio linea non espongono uno stato di caricamento distinto:
in caso di errore mostrano dati vuoti. I risultati percorso non hanno uno
stato UI di errore implementato. La suite non introduce aspettative su
funzionalità assenti e non include golden test o una matrice di dispositivi.

## Riproduzione

```sh
dart format test/helpers test/ui
flutter analyze
flutter test test/ui/lines/line_detail_screen_test.dart
flutter test
flutter test --coverage
```

Ogni file widget può essere eseguito singolarmente come nell'esempio.
La copertura generata è disponibile in `coverage/lcov.info`; misura le righe
Dart, non la completezza dei percorsi utente o l'aspetto grafico.

## Verifiche eseguite

- Formattazione dei 15 file Dart nuovi/modificati completata.
- `flutter analyze`: nessun problema rilevato.
- Tutti i 12 file di widget test eseguiti separatamente: 57 widget test superati.
- `flutter test`: 58 test superati, nessun fallimento o test saltato.
- `flutter test --coverage`: 58 test superati; generato `coverage/lcov.info`.
- 56 nuovi widget test; i due test originari sono conservati.
- 11 nuovi file di test, tre helper e questo resoconto. L'unico file
  preesistente modificato è `ui/main_navigation/widgets/bottom_nav_bar_test.dart`.

Il messaggio di debug relativo al mancato salvataggio dell'onboarding è
atteso nel test che simula quell'errore e non rappresenta un fallimento.

## Copertura misurata

Il file LCOV contiene 90 sorgenti: **2.079 righe eseguite su 2.414 (86,12%)**.
Per i soli sorgenti `lib/ui/` presenti nel report sono **2.016 su 2.062
(97,77%)**. Questi denominatori non comprendono i file non caricati: non sono
percentuali della totalità dell'applicazione. Il conteggio somma le righe `DA`
con almeno un'esecuzione rispetto a tutte le righe `DA` di ciascun sorgente.

| Ambito nei sorgenti inclusi in LCOV | Righe eseguite / rilevate | Copertura |
| --- | ---: | ---: |
| Linee e dettaglio | 788 / 795 | 99,12% |
| Autenticazione, escluso SessionViewModel | 293 / 304 | 96,38% |
| Onboarding | 171 / 172 | 99,42% |
| Notifiche | 236 / 241 | 97,93% |
| Risultati percorso | 159 / 160 | 99,38% |
| Controlli Home e ViewModel, escluse HomeScreen e HomeMap | 138 / 158 | 87,34% |
| Barra di navigazione e tema, escluso MainNavigationScreen | 56 / 56 | 100,00% |
| Impostazioni | 124 / 124 | 100,00% |
| Componenti core inclusi | 51 / 52 | 98,08% |

Oltre ai widget e a SessionViewModel indicati sopra, non compaiono nel report
UI `core/themes/app_theme.dart`, `auth/theme/auth_colors.dart`,
`onboarding/theme/onboarding_colors.dart` e `settings/theme/settings_colors.dart`.
I tre file di colori contengono prevalentemente costanti. La percentuale non
sostituisce l'elenco dei flussi scoperti documentato nella sezione sui limiti.
