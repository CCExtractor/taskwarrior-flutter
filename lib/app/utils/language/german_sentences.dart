import 'package:taskwarrior/app/utils/language/sentences.dart';

class GermanSentences extends Sentences {
  @override
  String get ccsyncLoginInstruction =>
      'Melde dich bei CCSync an, kopiere deine Anmeldedaten und füge sie oben ein.';
  @override
  String get ccsyncEasySyncTitle => 'CCSync nutzen für einfachen Sync';
  @override
  String get ccsyncOpenButton => 'CCSync öffnen';
  @override
  String get ccsyncIntro =>
      'CCSync nutzt TaskChampion, um Aufgaben nahtlos über mehrere Geräte hinweg zu synchronisieren. Außerdem erhälst du ein Web-Dashboard, über das du deine Aufgaben von jedem Browser aus verwalten kannst.';
  @override
  String get ccsyncSelfHosted =>
      'Oder bringe deine eigenen Anmeldedaten von einem selbst gehosteten TaskChampion-Synchronisierungsserver mit.';
  @override
  String get helloWorld => 'Hallo Welt!';

  @override
  String get homePageTitle => 'Startseite';
  @override
  String get homePageLastModified => 'Zuletzt geändert';
  @override
  String get homePageDue => 'Fällig';
  @override
  String get homePageTaskWarriorNotConfigured => 'TaskServer ist nicht konfiguriert';
  @override
  String get homePageSetup => 'Einrichtung';
  @override
  String get homePageFilter => 'Filter';
  @override
  String get homePageMenu => 'Menü';
  @override
  String get homePageExitApp => 'App beenden';
  @override
  String get homePageAreYouSureYouWantToExit =>
      'Bist du sicher, dass du beenden möchtest?';
  @override
  String get homePageExit => 'Beenden';
  @override
  String get homePageCancel => 'Abbruch';
  @override
  String get homePageClickOnTheBottomRightButtonToStartAddingTasks =>
      'Klicke auf die Schaltfläche unten rechts, um mit dem Hinzufügen von Aufgaben zu beginnen';
  @override
  String get homePageSearchNotFound => 'Suche nicht gefunden';
  @override
  String get homePageFetchingTasks => 'Aufgaben abholen';
  @override
  String get homePageSearchTooltip => 'Suchen';
  @override
  String get homePageCancelSearchTooltip => 'Abbruch';
  @override
  String get homePageAddTaskTooltip => 'Aufgabe hinzufügen';
  @override
  String get homePageTapBackToExit => 'Tipp zurück nochmal an, um zu benden';
  @override
  String get homePageSearchHint => 'Suche';

  @override
  String get settingsPageTitle => 'Einstellungen';
  @override
  String get settingsPageSubtitle => 'Konfiguriere deine Einstellungen';
  @override
  String get settingsPageMovingDataToNewDirectory =>
      'Verschiebe Daten zu neuem Verzeichnis';
  @override
  String get settingsPageSyncOnStartTitle => 'Synchronisiere bei App-Start';
  @override
  String get settingsPageSyncOnStartDescription =>
      'Automatische Synchronisierung beim Start der App';
  @override
  String get settingsPageEnableSyncOnTaskCreateTitle => 'Synchronisiere bei Erstellen neuer Aufgabe';
  @override
  String get settingsPageEnableSyncOnTaskCreateDescription =>
      'Automatische Synchronisierung beim Erstellen einer neuen Aufgabe aktivieren';
  @override
  String get settingsPageHighlightTaskTitle => 'Hebe dringende Aufgaben hervor';
  @override
  String get settingsPageHighlightTaskDescription =>
      'Hebe Aufgaben hervor, die innerhalb eines Tages fällig oder bereits überfällig sind';
  @override
  String get settingsPageEnable24hrFormatTitle => '24-Stunden-Format aktivieren';
  @override
  String get settingsPageEnable24hrFormatDescription =>
      'Nach rechts schalten, um das 24-Stunden-Format zu aktivieren';
  @override
  String get settingsPageSelectLanguage => 'Wähle die Sprache';
  @override
  String get settingsPageToggleNativeLanguage =>
      'Zwischen deiner Muttersprache umschalten';
  @override
  String get settingsPageSelectDirectoryTitle => 'Wähle das Verzeichnis';
  @override
  String get settingsPageSelectDirectoryDescription =>
      'Wähle das Verzeichnis aus, in dem die Taskwarrior-Daten gespeichert sind\nAktuelles Verzeichnis: ';
  @override
  String get settingsPageChangeDirectory => 'Verzeichnis ändern';
  @override
  String get settingsPageSetToDefault => 'Auf Standard setzen';

  @override
  String get navDrawerProfile => 'Profile';
  @override
  String get navDrawerReports => 'Berichte';
  @override
  String get navDrawerAbout => 'Über';
  @override
  String get navDrawerSettings => 'Einstellungen';
  @override
  String get navDrawerExit => 'Beenden';
  @override
  String get navDrawerConfirm => 'Bestätigen';

  @override
  String get detailPageDescription => 'Beschriftung';
  @override
  String get detailPageStatus => 'Status';
  @override
  String get detailPageEntry => 'Eingang';
  @override
  String get detailPageModified => 'Geändert';
  @override
  String get detailPageStart => 'Start';
  @override
  String get detailPageEnd => 'Ende';
  @override
  String get detailPageDue => 'Fällig';
  @override
  String get detailPageWait => 'Warten';
  @override
  String get detailPageUntil => 'Bis';
  @override
  String get detailPagePriority => 'Priorität';
  @override
  String get detailPageProject => 'Projekt';
  @override
  String get detailPageTags => 'Tags';
  @override
  String get detailPageUrgency => 'Dringlichkeit';
  @override
  String get detailPageID => 'ID';

  @override
  String get filterDrawerApplyFilters => 'Filter anwenden';
  @override
  String get filterDrawerHideWaiting => 'Verstecke Wartende';
  @override
  String get filterDrawerShowWaiting => 'Zeige Wartende';
  @override
  String get filterDrawerPending => 'Bevorstehend';
  @override
  String get filterDrawerCompleted => 'Erledigt';
  @override
  String get filterDrawerFilterTagBy => 'Tag filtern nach';
  @override
  String get filterDrawerAND => 'AND';
  @override
  String get filterDrawerOR => 'OR';
  @override
  String get filterDrawerSortBy => 'Sortieren nach';
  @override
  String get filterDrawerCreated => 'Erstellt';
  @override
  String get filterDrawerModified => 'Geändert';
  @override
  String get filterDrawerStartTime => 'Startzeit';
  @override
  String get filterDrawerDueTill => 'Fällig bis';
  @override
  String get filterDrawerPriority => 'Priorität';
  @override
  String get filterDrawerProject => 'Projekt';
  @override
  String get filterDrawerTags => 'Tags';
  @override
  String get filterDrawerUrgency => 'Dringlichkeit';
  @override
  String get filterDrawerResetSort => 'Sortierung zurücksetzen';
  @override
  String get filterDrawerStatus => 'Status';
  @override
  String get filterDrawerNoProjectsAvailable => 'Keine Projekte verfügbar.';
  @override
  String get reportsPageTitle => 'Berichte';
  @override
  String get reportsPageCompleted => 'Erledigt';
  @override
  String get reportsPagePending => 'Bevorstehend';
  @override
  String get reportsPageTasks => 'Aufgaben';

  @override
  String get reportsPageDaily => 'Täglich';
  @override
  String get reportsPageDailyBurnDownChart => 'Tägliches Burn Down Chart';
  @override
  String get reportsPageDailyDayMonth => 'Tag - Monat';

  @override
  String get reportsPageWeekly => 'Wöchentlich';
  @override
  String get reportsPageWeeklyBurnDownChart => 'Wöchentliches Burn Down Chart';
  @override
  String get reportsPageWeeklyWeeksYear => 'Wochen - Jahr';

  @override
  String get reportsPageMonthly => 'Monatlich';
  @override
  String get reportsPageMonthlyBurnDownChart => 'Monatliches Burn Down Chart';
  @override
  String get reportsPageMonthlyMonthYear => 'Monat - Jahr';

  @override
  String get reportsPageNoTasksFound => 'Keine Aufgaben gefunden';
  @override
  String get reportsPageAddTasksToSeeReports => 'Füge Aufgaben hinzu, um Berichte zu sehen';

  @override
  String get taskchampionTileDescription =>
      'Wechsel zu Taskwarrior Sync mit CCSync oder Taskchampion Sync Server';
  @override
  String get taskchampionTileTitle => 'Taskchampion Sync';

  @override
  String get ccsyncCredentials => 'CCync Anmeldedaten';

  @override
  String get deleteTaskConfirmation => 'Aufgaben löschen';

  @override
  String get deleteTaskTitle => 'Alle Aufgaben löschen?';

  @override
  String get deleteTaskWarning =>
      'Der Vorgang ist unwiderruflich und löscht alle lokal gespeicherten Aufgaben.';

  @override
  String get deleteAllTasksWillBeMarkedAsDeleted =>
      'Dadurch werden alle Aufgaben als gelöscht markiert und nicht mehr in der App angezeigt';

  @override
  String get profilePageProfile => 'Profil';
  @override
  String get profilePageProfiles => 'Profile';
  @override
  String get profilePageCurrentProfile => 'Aktuelles Profil';
  @override
  String get profilePageManageSelectedProfile => 'Manage gewähltes Profil';
  @override
  String get profilePageRenameAlias => 'Alias umbenennen';

  @override
  String get profilePageConfigureTaskserver => 'Konfiguriere Taskserver';
  @override
  String get profilePageExportTasks => 'Exportiere Aufgaben';
  @override
  String get profilePageChangeProfileMode => 'Ändere Sync Server';
  @override
  String get profilePageSelectProfileMode => 'Wähle einen Server';
  @override
  String get profilePageSuccessfullyChangedProfileModeTo =>
      'Profilmodus erfolgreich geändert auf';
  @override
  String get profilePageCopyConfigToNewProfile => 'Kopiere Konfiguration zu neuem Profil';
  @override
  String get profilePageDeleteProfile => 'Profil löschen';
  @override
  String get profilePageAddNewProfile => 'Neues Profil hinzufügen';

  @override
  String get profilePageRenameAliasDialogueBoxTitle => 'Alias umbenennen';
  @override
  String get profilePageRenameAliasDialogueBoxNewAlias => 'Neuer Alias';
  @override
  String get profilePageRenameAliasDialogueBoxCancel => 'Abbrechen';
  @override
  String get profilePageRenameAliasDialogueBoxSubmit => 'Senden';

  @override
  String get profilePageExportTasksDialogueTitle => 'Exportformat';
  @override
  String get profilePageExportTasksDialogueSubtitle =>
      'Wähle das Exportformat';

  @override
  String get manageTaskServerPageConfigureTaskserver => 'Konfiguriere Aufgaben-Server';
  @override
  String get manageTaskServerPageConfigureTASKRC => 'Konfiguriere TASKRC';
  @override
  String get manageTaskServerPageSetTaskRC => 'Setze TaskRC';
  @override
  String get manageTaskServerPageConfigureYourCertificate =>
      'Konfiguriere deine Zertifikate';
  @override
  String get manageTaskServerPageSelectCertificate => 'Wähle Zertifikate';
  @override
  String get manageTaskServerPageConfigureTaskserverKey =>
      'Konfiguriere Aufgaben-Server-Schlüssel';
  @override
  String get manageTaskServerPageSelectKey => 'Wähle Schlüssel';
  @override
  String get manageTaskServerPageConfigureServerCertificate =>
      'Konfiguriere Server-Zertifikate';

  @override
  String get manageTaskServerPageConfigureTaskRCDialogueBoxTitle =>
      'Konfiguriere TaskRC';
  @override
  String get manageTaskServerPageConfigureTaskRCDialogueBoxSubtitle =>
      'Füge deinen TaskRC-Inhalt ein oder wähle TaskRC-Datei';
  @override
  String get manageTaskServerPageConfigureTaskRCDialogueBoxInputFieldText =>
      'Füge deinen TaskRC-Inhalt hier ein';
  @override
  String get manageTaskServerPageConfigureTaskRCDialogueBoxOr => 'Oder';
  @override
  String get manageTaskServerPageConfigureTaskRCDialogueBoxSelectTaskRC =>
      'Wähle TaskRC-Datei';
  @override
  String get manageTaskServerPageTaskRCFileIsVerified =>
      'TaskRC-Datei wurde geprüft';

  @override
  String get addTaskTitle => "Aufgabe hinzufügen";
  @override
  String get addTaskEnterTask => "Aufgabe eingeben";
  @override
  String get addTaskDue => "Fällig";
  @override
  String get addTaskSelectDueDate => "Wähle Fälligkeitsdatum";
  @override
  String get addTaskPriority => "Priorität";
  @override
  String get addTaskAddTags => "Tags hinzufügen";
  @override
  String get addTaskCancel => "Abbrechen";
  @override
  String get addTaskAdd => "Hinzufügen";
  @override
  String get addTaskTimeInPast => "Die gewählte Zeit liegt in der Vergangenheit.";
  @override
  String get addTaskFieldCannotBeEmpty => "Du kannst dieses Feld nicht leer lassen!";
  @override
  String get addTaskTaskAddedSuccessfully =>
      "Aufgabe erfolgreich hinzugefügt. Antippen zum Bearbeiten";

  @override
  String get aboutPageGitHubLink =>
      "Möchtest du dieses Projekt verbessern? Besuche unser GitHub-Repository.";
  @override
  String get aboutPageProjectDescription =>
      "Dieses Projekt zielt darauf ab, eine App für Taskwarrior zu entwickeln. Es handelt sich dabei um eine plattformübergreifende Aufgabenverwaltungs-App. Sie hilft dir dabei, deine Aufgaben zu verwalten und nach deinen Bedürfnissen zu filtern.";
  @override
  String get aboutPageAppBarTitle => "Über";

  @override
  String get version => "Version";
  @override
  String get package => "Paket";

  @override
  String get notSelected => "Nicht ausgewählt";
  @override
  String get cantSetTimeinPast => "Kann keine Zeit in der Vergangenheit setzen";

  @override
  String get editDescription => "Beschreibung bearbeiten";
  @override
  String get editProject => "Projekt bearbeiten";
  @override
  String get cancel => "Abbrechen";
  @override
  String get submit => "Senden";

  @override
  String get saveChangesConfirmation => 'Möchtest du deine Änderungen speichern?';
  @override
  String get yes => 'Ja';
  @override
  String get no => 'Nein';
  @override
  String get reviewChanges => 'Änderungen sichten';
  @override
  String get oldChanges => 'Alt';
  @override
  String get newChanges => 'Neu';

  @override
  String get tags => 'Tags';
  @override
  String get addedTagsWillAppearHere => 'Hinzugefügte Tags erscheinen hier';
  @override
  String get addTag => 'Tag hinzufügen';

  @override
  String get enterProject => 'Projekt eingeben';
  @override
  String get allProjects => 'Alle Projekte';
  @override
  String get noProjectsFound => 'Keine Projekte gefunden';
  @override
  String get project => 'Projekt';

  @override
  String get select => 'Wähle';
  @override
  String get save => 'Speichern';
  @override
  String get dontSave => 'Nicht speichern';
  @override
  String get unsavedChanges => 'Ungesicherte Änderungen';
  @override
  String get unsavedChangesWarning =>
      'Du hast ungesicherte Änderungen. Was möchtest du tun?';
  @override
  String get enterNew => 'Neu eingeben';
  @override
  String get edit => 'Bearbeiten';
  @override
  String get task => 'Aufgabe';

  // task action strings
  @override
  String get confirmDeleteTask => 'Löschen bestätigen';
  @override
  String get taskUpdated => 'Aufgabe aktualisiert';
  @override
  String get undo => 'Rückgängig';
  @override
  String get taskMarkedAsCompleted =>
      'Aufgabe als abgeschlossen markiert. Aktualisieren, um Änderungen zu sehen!';
  @override
  String get taskMarkedAsDeleted =>
      'Aufgabe als gelöscht markiert. Aktualisieren, um Änderungen zu sehen!';
  @override
  String get refreshToViewChanges => 'Aktualisieren, um Änderungen zu sehen';
  @override
  String get clickOnBottomRightButtonToStartAddingTasks =>
      'Klicke auf die Schaltfläche unten rechts, um mit dem Hinzufügen von Aufgaben zu beginnen';
  @override
  String get complete => 'ABGESCHLOSSEN';
  @override
  String get delete => 'LÖSCHEN';

  // task server management strings
  @override
  String get taskServerInfo => 'TaskD-Server-Info';
  @override
  String get taskServerCredentials => 'TaskD-Server-Anmeldedaten';
  @override
  String get notConfigured => 'Nicht konfiguriert';
  @override
  String get fetchingStatistics => 'Sammle Statistiken…';
  @override
  String get pleaseWait => 'Bitte warten…';
  @override
  String get statistics => 'Statistiken:';
  @override
  String get ok => 'Ok';
  @override
  String get pleaseSetupTaskServer => 'Bitte richte deinen TaskServer ein.';

  // onboarding strings
  @override
  String get onboardingSkip => 'Überspringen';
  @override
  String get onboardingNext => 'Nächste';
  @override
  String get onboardingStart => 'Start';

  // permission strings
  @override
  String get permissionPageTitle => 'Warum wir deine Zustimmung benötigen';
  @override
  String get storagePermissionTitle => 'Speicherberechtigung';
  @override
  String get storagePermissionDescription =>
      'Wir nutzen den Speicherzugriff, um deine Aufgaben, Einstellungen und'
      'App-Daten sicher auf deinem Gerät zu speichern. So kannst du auch'
      'offline nahtlos dort weitermachen, wo du aufgehört hast.';
  @override
  String get notificationPermissionTitle => 'Benachrichtigungsberechtigung';
  @override
  String get notificationPermissionDescription =>
      'Benachrichtigungen halten dich mit wichtigen Erinnerungen und Updates auf dem '
      'Laufenden, sodass du mühelos den Überblick über deine Aufgabe behälst.';
  @override
  String get privacyStatement =>
      'Deine Privatsphäre hat für uns oberste Priorität. Wir greifen niemals ohne deine'
      'Zustimmung auf persönliche Dateien oder Daten zu und geben diese auch nicht weiter.';
  @override
  String get grantPermissions => 'Berechtigungen erteilen';
  @override
  String get managePermissionsLater =>
      'Du kannst deine Berechtigungen jederzeit später in den Einstellungen verwalten';

  // Profile page strings
  @override
  String get profileAllProfiles => 'Alle Profile:';
  @override
  String get profileSwitchedToProfile => 'Wechsel zu Profil';
  @override
  String get profileAddedSuccessfully => 'Profil hinzufügen erfolgreich';
  @override
  String get profileAdditionFailed => 'Profil hinzufügen fehlgeschlagen';
  @override
  String get profileConfigCopied => 'Profilkonfiguration kopiert';
  @override
  String get profileConfigCopyFailed => 'Profilkonfiguration kopieren fehlgeschlagen';
  @override
  String get profileDeletedSuccessfully => 'Löschen erfolgreich';
  @override
  String get profileDeletionFailed => 'Löschen schlug fehl';
  @override
  String get profileDeleteConfirmation => 'Bestätigen';

  // Reports strings
  @override
  String get reportsDate => 'Datum';
  @override
  String get reportsPending => 'Bevorstehend';
  @override
  String get reportsCompleted => 'Erledigt';
  @override
  String get reportsMonthYear => 'Monat-Jahr';
  @override
  String get reportsWeek => 'Woche';
  @override
  String get reportsDay => 'Tag';
  @override
  String get reportsYear => 'Jahr';
  @override
  String get reportsError => 'Fehler';
  @override
  String get reportsLoading => 'Lädt…';

  // Settings strings
  @override
  String get settingsResetToDefault => 'Auf Standard zurücksetzen';
  @override
  String get settingsAlreadyDefault => 'Bereits Standard';
  @override
  String get settingsConfirmReset =>
      'Bist du sicher, dass du dieses Verzeichnis auf den Standardwert zurücksetzen möchtest?';
  @override
  String get settingsNoButton => 'Nein';
  @override
  String get settingsYesButton => 'Ja';

  // Splash screen strings
  @override
  String get splashSettingUpApp => "Richte die App ein …";

  // Tour strings - reports
  @override
  String get tourReportsDaily => "Greife auf deine aktuellen täglichen Berichte hier zu";
  @override
  String get tourReportsWeekly => "Greife auf deine aktuellen wöchentlichen Berichte hier zu";
  @override
  String get tourReportsMonthly => "Greife auf deine aktuellen monatlichen Berichte hier zu";

  // Tour strings - profile
  @override
  String get tourProfileCurrent => "Dein aktuelles Profil steht hier";
  @override
  String get tourProfileManage => "Manage dein aktuelles Profil hier";
  @override
  String get tourProfileAddNew => "Neues Profil hier hinzufügen";

  // Tour strings - task server
  @override
  String get tourTaskServerTaskRC =>
      "Wähle hier die Datei taskrc aus oder füge deren Inhalt hier ein";
  @override
  String get tourTaskServerCertificate =>
      "Wähle hier eine Datei mit einem ähnlichen Namen wie <Ihre E-Mail-Adresse>.com.cert.pem aus";
  @override
  String get tourTaskServerKey =>
      "Wähle hier eine Datei mit einem ähnlichen Namen wie <Ihre E-Mail-Adresse>.key.pem aus";
  @override
  String get tourTaskServerRootCert =>
      "Wähle hier eine Datei mit einem ähnlichen Namen wie letsencrypt_root_cert.pem aus";

  // Tour strings - home page
  @override
  String get tourHomeAddTask => "Aufgabe hinzufügen";
  @override
  String get tourHomeSearch => "Suche Aufgaben";
  @override
  String get tourHomeRefresh => "Aktualisier oder synchronisiere deine Aufgaben";
  @override
  String get tourHomeFilter => "Filter hinzufügen, um Aufgaben und Projekte zu sortieren";
  @override
  String get tourHomeMenu => "Greif auf weitere Einstellung hier zu";

  // Tour strings - filter drawer
  @override
  String get tourFilterStatus =>
      "Aufgaben nach ihrem Fertigstellungsstatus filtern";
  @override
  String get tourFilterProjects => "Filtere Aufgaben basierend auf Projekten";
  @override
  String get tourFilterTagUnion => "Zwischen AND und OR Tag-Vereinigungstypen umschalten";
  @override
  String get tourFilterSort =>
      "Sortiere Aufgaben nach Erstellungszeitpunkt, Dringlichkeit, Fälligkeitsdatum, Startdatum usw.";

  // Tour strings - details page
  @override
  String get tourDetailsDue => "Dies bezeichnet das Fälligkeitsdatum der Aufgabe";
  @override
  String get tourDetailsWait =>
      "Dies gibt das Wartedatum der Aufgabe an \n Die Aufgabe wird nach diesem Datum sichtbar sein";
  @override
  String get tourDetailsUntil => "Dies zeigt das letzte Datum der Aufgabe an";
  @override
  String get tourDetailsPriority =>
      "Dies ist die Priorität der Aufgaben \n L -> Niedrig \n M -> Mittel \n H -> Hoch";
  // Dialogue for adding new task
  @override
  String get descriprtionCannotBeEmpty => "Beschreibung kann nicht leer sein";
  @override
  String get enterTaskDescription => "Aufgabenbeschreibung eingeben";
  @override
  String get canNotHaveWhiteSpace => "Kann keine Leerzeichen haben";
  @override
  String get high => "Hoch";
  @override
  String get medium => "Mittel";
  @override
  String get low => "Niedrig";
  @override
  String get priority => "Priorität";
  @override
  String get tagAlreadyExists => "Tag existiert bereits";
  @override
  String get tagShouldNotContainSpaces => "Tag sollte keine Leerzeichen enthalten";
  @override
  String get date => "Datum";
  @override
  String get add => "Hinzufügen";
  @override
  String get change => "Ändern";
  @override
  String get dateCanNotBeInPast => "Datum kann nicht in der Vergangenheit liegen";
  @override
  String get configureTaskchampion => 'Konfiguriere Taskchampion';
  @override
  String get encryptionSecret => 'Encryption Secret';
  @override
  String get ccsyncBackendUrl => 'CCSync Backend URL';
  @override
  String get ccsyncClientId => 'Client ID';
  @override
  String get success => 'Erfolg';
  @override
  String get credentialsSavedSuccessfully => 'Anmeldedaten erfolgreich gespeichert';
  @override
  String get saveCredentials => 'Speichern';
  @override
  String get tip =>
      "Tipp: Klicke auf das Info-Symbol in der oberen rechten Ecke, um die Anmeldedaten zu erhalten.";
  @override
  String get logs => 'Logs';
  @override
  String get checkAllDebugLogsHere => 'Check all debug logs here';
  // Settings
  @override
  String get syncSetting => 'Sync-Einstellungen';
  @override
  String get displaySettings => 'Anzeigeeinstellungen';
  @override
  String get storageAndData => 'Speicher und Daten';
  @override
  String get advanced => 'Fortgeschritten';
  @override
  String get taskchampionBackendUrl => 'Taskchampion URL';
}
