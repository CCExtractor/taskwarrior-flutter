import 'package:taskwarrior/app/utils/language/sentences.dart';

class FrenchSentences extends Sentences {
  @override
  String get helloWorld => 'Bonjour, le monde!';
  @override
  String get homePageTitle => 'Page d\'accueil';
  @override
  String get homePageLastModified => 'Dernière modification';
  @override
  String get homePageDue => 'Échéance';
  @override
  String get homePageTaskWarriorNotConfigured => 'TaskServer non configuré';
  @override
  String get homePageSetup => 'Configuration';
  @override
  String get homePageFilter => 'Filtre';
  @override
  String get homePageMenu => 'Menu';
  @override
  String get homePageExitApp => 'Quitter l\'application';
  @override
  String get homePageAreYouSureYouWantToExit =>
      'Êtes-vous sûr de vouloir quitter l\'application ?';
  @override
  String get homePageExit => 'Quitter';
  @override
  String get homePageCancel => 'Annuler';
  @override
  String get homePageClickOnTheBottomRightButtonToStartAddingTasks =>
      'Cliquez sur le bouton en bas à droite pour commencer à ajouter des tâches';
  @override
  String get homePageSearchNotFound => 'Aucun résultat pour la recherche';
  @override
  String get settingsPageTitle => 'Page des paramètres';
  @override
  String get settingsPageSubtitle => 'Configurez vos préférences';
  @override
  String get settingsPageMovingDataToNewDirectory =>
      'Déplacement des données vers un nouveau répertoire';
  @override
  String get settingsPageSyncOnStartTitle =>
      'Synchroniser les données automatiquement au démarrage';
  @override
  String get settingsPageSyncOnStartDescription => 'Synchroniser au démarrage';
  @override
  String get settingsPageEnableSyncOnTaskCreateTitle =>
      'Activer la synchronisation automatique lors de la création de nouvelles tâches';
  @override
  String get settingsPageEnableSyncOnTaskCreateDescription =>
      'Activer la synchronisation automatique lors de la création de nouvelles tâches';
  @override
  String get settingsPageHighlightTaskTitle =>
      'Surbrillance des tâches avec 1 jour restant';
  @override
  String get settingsPageHighlightTaskDescription =>
      'Surbrillance des tâches avec 1 jour restant';
  @override
  String get settingsPageEnable24hrFormatTitle => 'Activer le format 24 heures';
  @override
  String get settingsPageEnable24hrFormatDescription =>
      'Activer le format 24 heures';
  @override
  String get settingsPageSelectLanguage => 'Choisir la langue';
  @override
  String get settingsPageToggleNativeLanguage =>
      'Basculer entre les langues natives';
  @override
  String get settingsPageSelectDirectoryTitle => 'Choisir un répertoire';
  @override
  String get settingsPageSelectDirectoryDescription =>
      'Choisissez le répertoire où les données Taskwarrior sont stockées\nRépertoire actuel : ';
  @override
  String get settingsPageChangeDirectory => 'Changer de répertoire';
  @override
  String get settingsPageSetToDefault => 'Définir par défaut';
  @override
  String get navDrawerProfile => 'Profil';
  @override
  String get navDrawerReports => 'Rapports';
  @override
  String get navDrawerAbout => 'À propos';
  @override
  String get navDrawerSettings => 'Paramètres';
  @override
  String get navDrawerExit => 'Quitter';

  @override
  String get detailPageDescription => 'Description';
  @override
  String get detailPageStatus => 'Statut';
  @override
  String get detailPageEntry => 'Entrée';
  @override
  String get detailPageModified => 'Modifié';
  @override
  String get detailPageStart => 'Début';
  @override
  String get detailPageEnd => 'Fin';
  @override
  String get detailPageDue => 'Échéance';
  @override
  String get detailPageWait => 'Attendre';
  @override
  String get detailPageUntil => 'Jusqu\'à';
  @override
  String get detailPagePriority => 'Priorité';
  @override
  String get detailPageProject => 'Projet';
  @override
  String get detailPageTags => 'Tags';
  @override
  String get detailPageUrgency => 'Urgence';
  @override
  String get detailPageID => 'ID';

  @override
  String get filterDrawerApplyFilters => 'Appliquer les filtres';
  @override
  String get filterDrawerHideWaiting => 'Masquer les en attente';
  @override
  String get filterDrawerShowWaiting => 'Afficher les en attente';
  @override
  String get filterDrawerPending => 'En attente';
  @override
  String get filterDrawerCompleted => 'Complété';
  @override
  String get filterDrawerFilterTagBy => 'Filtrer par tag';
  @override
  String get filterDrawerAND => 'et';
  @override
  String get filterDrawerOR => 'ou';
  @override
  String get filterDrawerSortBy => 'Trier par';
  @override
  String get filterDrawerCreated => 'Créé';
  @override
  String get filterDrawerModified => 'Modifié';
  @override
  String get filterDrawerStartTime => 'Heure de début';
  @override
  String get filterDrawerDueTill => 'Jusqu\'à l\'échéance';
  @override
  String get filterDrawerPriority => 'Priorité';
  @override
  String get filterDrawerProject => 'Projet';
  @override
  String get filterDrawerTags => 'Tags';
  @override
  String get filterDrawerUrgency => 'Urgence';
  @override
  String get filterDrawerResetSort => 'Réinitialiser le tri';
  @override
  String get filterDrawerStatus => 'Statut';
  @override
  String get reportsPageTitle => 'Rapports';
  @override
  String get reportsPageCompleted => 'Complété';
  @override
  String get reportsPagePending => 'En attente';
  @override
  String get reportsPageTasks => 'Tâches';

  @override
  String get reportsPageDaily => 'Quotidien';
  @override
  String get reportsPageDailyBurnDownChart =>
      'Graphique de burn down quotidien';
  @override
  String get reportsPageDailyDayMonth => 'Jour - Mois';

  @override
  String get reportsPageWeekly => 'Hebdomadaire';
  @override
  String get reportsPageWeeklyBurnDownChart =>
      'Graphique de burn down hebdomadaire';
  @override
  String get reportsPageWeeklyWeeksYear => 'Semaine - Année';

  @override
  String get reportsPageMonthly => 'Mensuel';
  @override
  String get reportsPageMonthlyBurnDownChart =>
      'Graphique de burn down mensuel';
  @override
  String get reportsPageMonthlyMonthYear => 'Mois - Année';

  @override
  String get reportsPageNoTasksFound => 'Aucune tâche trouvée';
  @override
  String get reportsPageAddTasksToSeeReports =>
      'Ajoutez des tâches pour voir les rapports';

  @override
  String get taskchampionTileDescription =>
      'Basculez la synchronisation de Taskwarrior vers le serveur de synchronisation CCSync ou Taskchampion';

  @override
  String get taskchampionTileTitle => 'Synchronisation Taskchampion';

  @override
  String get ccsyncCredentials => 'Identifiants CCSync';

  @override
  String get deleteTaskConfirmation => 'Supprimer la tâche';

  @override
  String get deleteTaskTitle => 'Supprimer toutes les tâches ?';

  @override
  String get deleteTaskWarning =>
      'Cette action est irréversible et supprimera toutes les tâches stockées localement.';

  @override
  String get profilePageProfile => 'Profil';
  @override
  String get profilePageProfiles => 'Profils';
  @override
  String get profilePageCurrentProfile => 'Profil actuel';
  @override
  String get profilePageManageSelectedProfile => 'Gérer le profil sélectionné';
  @override
  String get profilePageRenameAlias => 'Renommer l\'alias';

  @override
  String get profilePageConfigureTaskserver =>
      'Configurer le serveur de tâches';
  @override
  String get profilePageExportTasks => 'Exporter les tâches';
  @override
  String get profilePageCopyConfigToNewProfile =>
      'Copier la configuration vers un nouveau profil';
  @override
  String get profilePageDeleteProfile => 'Supprimer le profil';
  @override
  String get profilePageAddNewProfile => 'Ajouter un nouveau profil';

  @override
  String get profilePageRenameAliasDialogueBoxTitle => 'Renommer l\'alias';
  @override
  String get profilePageRenameAliasDialogueBoxNewAlias => 'Nouvel alias';
  @override
  String get profilePageRenameAliasDialogueBoxCancel => 'Annuler';
  @override
  String get profilePageRenameAliasDialogueBoxSubmit => 'Soumettre';
  @override
  String get profilePageExportTasksDialogueTitle => 'Format d\'exportation';
  @override
  String get profilePageExportTasksDialogueSubtitle =>
      'Choisissez le format d\'exportation';

  @override
  String get manageTaskServerPageConfigureTaskserver =>
      'Configurer le serveur de tâches';
  @override
  String get manageTaskServerPageConfigureTASKRC => 'Configurer TASKRC';
  @override
  String get manageTaskServerPageSetTaskRC => 'Définir TaskRC';
  @override
  String get manageTaskServerPageConfigureYourCertificate =>
      'Configurer votre certificat';
  @override
  String get manageTaskServerPageSelectCertificate =>
      'Sélectionner un certificat';
  @override
  String get manageTaskServerPageConfigureTaskserverKey =>
      'Configurer la clé du serveur de tâches';
  @override
  String get manageTaskServerPageSelectKey => 'Sélectionner une clé';
  @override
  String get manageTaskServerPageConfigureServerCertificate =>
      'Configurer le certificat du serveur';
  @override
  String get manageTaskServerPageTaskRCFileIsVerified =>
      'Le fichier Task RC est vérifié';

  @override
  String get manageTaskServerPageConfigureTaskRCDialogueBoxTitle =>
      'Configurer TaskRC';
  @override
  String get manageTaskServerPageConfigureTaskRCDialogueBoxSubtitle =>
      'Collez le contenu de TaskRC ou sélectionnez un fichier taskrc';
  @override
  String get manageTaskServerPageConfigureTaskRCDialogueBoxInputFieldText =>
      'Collez votre contenu TaskRC ici';
  @override
  String get manageTaskServerPageConfigureTaskRCDialogueBoxOr => 'ou';
  @override
  String get manageTaskServerPageConfigureTaskRCDialogueBoxSelectTaskRC =>
      'Sélectionner un fichier TaskRC';

  @override
  String get addTaskTitle => "Ajouter une tâche";
  @override
  String get addTaskEnterTask => "Entrer une tâche";
  @override
  String get addTaskDue => "Échéance";
  @override
  String get addTaskSelectDueDate => "Sélectionner la date d'échéance";
  @override
  String get addTaskPriority => "Priorité";
  @override
  String get addTaskAddTags => "Ajouter des tags";
  @override
  String get addTaskCancel => "Annuler";
  @override
  String get addTaskAdd => "Ajouter";
  @override
  String get addTaskTimeInPast => "L'heure sélectionnée est dans le passé.";
  @override
  String get addTaskFieldCannotBeEmpty =>
      "Vous ne pouvez pas laisser ce champ vide !";
  @override
  String get addTaskTaskAddedSuccessfully =>
      "Tâche ajoutée avec succès. Appuyez pour éditer";

  @override
  String get aboutPageGitHubLink =>
      "Enthousiaste à l'idée d'améliorer ce projet ? Visitez notre dépôt GitHub.";
  @override
  String get aboutPageProjectDescription =>
      "Ce projet vise à créer une application pour Taskwarrior. C'est votre application de gestion des tâches sur toutes les plateformes. Elle vous aide à gérer vos tâches et à les filtrer selon vos besoins.";
  @override
  String get aboutPageAppBarTitle => "À propos";
}
