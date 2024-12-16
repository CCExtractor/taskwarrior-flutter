import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/utils/language/french_sentences.dart';

void main() {
  final french = FrenchSentences();

  test('should provide correct French translations', () {
    expect(french.helloWorld, 'Bonjour, le monde!');
    expect(french.homePageTitle, 'Page d\'accueil');
    expect(french.homePageLastModified, 'Dernière modification');
    expect(french.homePageDue, 'Échéance');
    expect(french.homePageTaskWarriorNotConfigured, 'TaskServer non configuré');
    expect(french.homePageSetup, 'Configuration');
    expect(french.homePageFilter, 'Filtre');
    expect(french.homePageMenu, 'Menu');
    expect(french.homePageExitApp, 'Quitter l\'application');
    expect(french.homePageAreYouSureYouWantToExit,
        'Êtes-vous sûr de vouloir quitter l\'application ?');
    expect(french.homePageExit, 'Quitter');
    expect(french.homePageCancel, 'Annuler');
    expect(french.homePageClickOnTheBottomRightButtonToStartAddingTasks,
        'Cliquez sur le bouton en bas à droite pour commencer à ajouter des tâches');
    expect(french.homePageSearchNotFound, 'Aucun résultat pour la recherche');
    expect(french.settingsPageTitle, 'Page des paramètres');
    expect(french.settingsPageSubtitle, 'Configurez vos préférences');
    expect(french.settingsPageMovingDataToNewDirectory,
        'Déplacement des données vers un nouveau répertoire');
    expect(french.settingsPageSyncOnStartTitle,
        'Synchroniser les données automatiquement au démarrage');
    expect(
        french.settingsPageSyncOnStartDescription, 'Synchroniser au démarrage');
    expect(french.settingsPageEnableSyncOnTaskCreateTitle,
        'Activer la synchronisation automatique lors de la création de nouvelles tâches');
    expect(french.settingsPageEnableSyncOnTaskCreateDescription,
        'Activer la synchronisation automatique lors de la création de nouvelles tâches');
    expect(french.settingsPageHighlightTaskTitle,
        'Surbrillance des tâches avec 1 jour restant');
    expect(french.settingsPageHighlightTaskDescription,
        'Surbrillance des tâches avec 1 jour restant');
    expect(french.settingsPageEnable24hrFormatTitle,
        'Activer le format 24 heures');
    expect(french.settingsPageEnable24hrFormatDescription,
        'Activer le format 24 heures');
    expect(french.settingsPageSelectLanguage, 'Choisir la langue');
    expect(french.settingsPageToggleNativeLanguage,
        'Basculer entre les langues natives');
    expect(french.settingsPageSelectDirectoryTitle, 'Choisir un répertoire');
    expect(french.settingsPageSelectDirectoryDescription,
        'Choisissez le répertoire où les données TaskWarrior sont stockées\nRépertoire actuel : ');
    expect(french.settingsPageChangeDirectory, 'Changer de répertoire');
    expect(french.settingsPageSetToDefault, 'Définir par défaut');
    expect(french.navDrawerProfile, 'Profil');
    expect(french.navDrawerReports, 'Rapports');
    expect(french.navDrawerAbout, 'À propos');
    expect(french.navDrawerSettings, 'Paramètres');
    expect(french.navDrawerExit, 'Quitter');
    expect(french.detailPageDescription, 'Description');
    expect(french.detailPageStatus, 'Statut');
    expect(french.detailPageEntry, 'Entrée');
    expect(french.detailPageModified, 'Modifié');
    expect(french.detailPageStart, 'Début');
    expect(french.detailPageEnd, 'Fin');
    expect(french.detailPageDue, 'Échéance');
    expect(french.detailPageWait, 'Attendre');
    expect(french.detailPageUntil, 'Jusqu\'à');
    expect(french.detailPagePriority, 'Priorité');
    expect(french.detailPageProject, 'Projet');
    expect(french.detailPageTags, 'Tags');
    expect(french.detailPageUrgency, 'Urgence');
    expect(french.detailPageID, 'ID');
    expect(french.filterDrawerApplyFilters, 'Appliquer les filtres');
    expect(french.filterDrawerHideWaiting, 'Masquer les en attente');
    expect(french.filterDrawerShowWaiting, 'Afficher les en attente');
    expect(french.filterDrawerPending, 'En attente');
    expect(french.filterDrawerCompleted, 'Complété');
    expect(french.filterDrawerFilterTagBy, 'Filtrer par tag');
    expect(french.filterDrawerAND, 'et');
    expect(french.filterDrawerOR, 'ou');
    expect(french.filterDrawerSortBy, 'Trier par');
    expect(french.filterDrawerCreated, 'Créé');
    expect(french.filterDrawerModified, 'Modifié');
    expect(french.filterDrawerStartTime, 'Heure de début');
    expect(french.filterDrawerDueTill, 'Jusqu\'à l\'échéance');
    expect(french.filterDrawerPriority, 'Priorité');
    expect(french.filterDrawerProject, 'Projet');
    expect(french.filterDrawerTags, 'Tags');
    expect(french.filterDrawerUrgency, 'Urgence');
    expect(french.filterDrawerResetSort, 'Réinitialiser le tri');
    expect(french.filterDrawerStatus, 'Statut');
    expect(french.reportsPageTitle, 'Rapports');
    expect(french.reportsPageCompleted, 'Complété');
    expect(french.reportsPagePending, 'En attente');
    expect(french.reportsPageTasks, 'Tâches');
    expect(french.reportsPageDaily, 'Quotidien');
    expect(french.reportsPageDailyBurnDownChart,
        'Graphique de burn down quotidien');
    expect(french.reportsPageDailyDayMonth, 'Jour - Mois');
    expect(french.reportsPageWeekly, 'Hebdomadaire');
    expect(french.reportsPageWeeklyBurnDownChart,
        'Graphique de burn down hebdomadaire');
    expect(french.reportsPageWeeklyWeeksYear, 'Semaine - Année');
    expect(french.reportsPageMonthly, 'Mensuel');
    expect(french.reportsPageMonthlyBurnDownChart,
        'Graphique de burn down mensuel');
    expect(french.reportsPageMonthlyMonthYear, 'Mois - Année');
    expect(french.reportsPageNoTasksFound, 'Aucune tâche trouvée');
    expect(french.reportsPageAddTasksToSeeReports,
        'Ajoutez des tâches pour voir les rapports');
    expect(french.taskchampionTileDescription,
        'Basculez la synchronisation de TaskWarrior vers le serveur de synchronisation CCSync ou Taskchampion');
    expect(french.taskchampionTileTitle, 'Synchronisation Taskchampion');
    expect(french.ccsyncCredentials, 'Identifiants CCSync');
    expect(french.deleteTaskConfirmation, 'Supprimer la tâche');
    expect(french.deleteTaskTitle, 'Supprimer toutes les tâches ?');
    expect(french.deleteTaskWarning,
        'Cette action est irréversible et supprimera toutes les tâches stockées localement.');
    expect(french.profilePageProfile, 'Profil');
    expect(french.profilePageProfiles, 'Profils');
    expect(french.profilePageCurrentProfile, 'Profil actuel');
    expect(
        french.profilePageManageSelectedProfile, 'Gérer le profil sélectionné');
    expect(french.profilePageRenameAlias, 'Renommer l\'alias');
    expect(french.profilePageConfigureTaskserver,
        'Configurer le serveur de tâches');
    expect(french.profilePageExportTasks, 'Exporter les tâches');
    expect(french.profilePageCopyConfigToNewProfile,
        'Copier la configuration vers un nouveau profil');
    expect(french.profilePageDeleteProfile, 'Supprimer le profil');
    expect(french.profilePageAddNewProfile, 'Ajouter un nouveau profil');
    expect(french.profilePageRenameAliasDialogueBoxTitle, 'Renommer l\'alias');
    expect(french.profilePageRenameAliasDialogueBoxNewAlias, 'Nouvel alias');
    expect(french.profilePageRenameAliasDialogueBoxCancel, 'Annuler');
    expect(french.profilePageRenameAliasDialogueBoxSubmit, 'Soumettre');
    expect(french.profilePageExportTasksDialogueTitle, 'Format d\'exportation');
    expect(french.profilePageExportTasksDialogueSubtitle,
        'Choisissez le format d\'exportation');
    expect(french.manageTaskServerPageConfigureTaskserver,
        'Configurer le serveur de tâches');
    expect(french.manageTaskServerPageConfigureTASKRC, 'Configurer TASKRC');
    expect(french.manageTaskServerPageSetTaskRC, 'Définir TaskRC');
    expect(french.manageTaskServerPageConfigureYourCertificate,
        'Configurer votre certificat');
    expect(french.manageTaskServerPageSelectCertificate,
        'Sélectionner un certificat');
    expect(french.manageTaskServerPageConfigureTaskserverKey,
        'Configurer la clé du serveur de tâches');
    expect(french.manageTaskServerPageSelectKey, 'Sélectionner une clé');
    expect(french.manageTaskServerPageConfigureServerCertificate,
        'Configurer le certificat du serveur');
    expect(french.manageTaskServerPageTaskRCFileIsVerified,
        'Le fichier Task RC est vérifié');
    expect(french.manageTaskServerPageConfigureTaskRCDialogueBoxTitle,
        'Configurer TaskRC');
    expect(french.manageTaskServerPageConfigureTaskRCDialogueBoxSubtitle,
        'Collez le contenu de TaskRC ou sélectionnez un fichier taskrc');
    expect(french.manageTaskServerPageConfigureTaskRCDialogueBoxInputFieldText,
        'Collez votre contenu TaskRC ici');
    expect(french.manageTaskServerPageConfigureTaskRCDialogueBoxOr, 'ou');
    expect(french.manageTaskServerPageConfigureTaskRCDialogueBoxSelectTaskRC,
        'Sélectionner un fichier TaskRC');
    expect(french.addTaskTitle, 'Ajouter une tâche');
    expect(french.addTaskEnterTask, 'Entrer une tâche');
    expect(french.addTaskDue, 'Échéance');
    expect(french.addTaskSelectDueDate, 'Sélectionner la date d\'échéance');
    expect(french.addTaskPriority, 'Priorité');
    expect(french.addTaskAddTags, 'Ajouter des tags');
    expect(french.addTaskCancel, 'Annuler');
    expect(french.addTaskAdd, 'Ajouter');
    expect(
        french.addTaskTimeInPast, 'L\'heure sélectionnée est dans le passé.');
    expect(french.addTaskFieldCannotBeEmpty,
        'Vous ne pouvez pas laisser ce champ vide !');
    expect(french.addTaskTaskAddedSuccessfully,
        'Tâche ajoutée avec succès. Appuyez pour éditer');
    expect(french.aboutPageGitHubLink,
        'Enthousiaste à l\'idée d\'améliorer ce projet ? Visitez notre dépôt GitHub.');
    expect(french.aboutPageProjectDescription,
        'Ce projet vise à créer une application pour Taskwarrior. C\'est votre application de gestion des tâches sur toutes les plateformes. Elle vous aide à gérer vos tâches et à les filtrer selon vos besoins.');
    expect(french.aboutPageAppBarTitle, 'À propos');
  });
}
