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
  String get homePageFetchingTasks => 'Récupération de tâches';
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
  String get settingsPageHighlightTaskTitle => 'Surligner les tâches urgentes';
  @override
  String get settingsPageHighlightTaskDescription =>
      'Surligner les tâches dues dans 1 jour ou en retard';
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
  String get deleteAllTasksWillBeMarkedAsDeleted =>
      'Cela marquera toutes les tâches comme supprimées et elles ne seront pas affichées dans l\'application.';

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
  String get profilePageChangeProfileMode =>
      'Changer le serveur de synchronisation';
  @override
  String get profilePageSelectProfileMode => 'Sélectionnez un serveur';
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
  String get profilePageSuccessfullyChangedProfileModeTo =>
      'Mode de profil changé avec succès en : ';
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

  @override
  String get homePageSearchTooltip => 'Rechercher';
  @override
  String get homePageCancelSearchTooltip => 'Annuler';
  @override
  String get homePageAddTaskTooltip => 'Ajouter une tâche';
  @override
  String get homePageTapBackToExit => 'Appuyez de nouveau pour quitter';
  @override
  String get homePageSearchHint => 'Rechercher';

  @override
  String get navDrawerConfirm => 'Confirmer';

  @override
  String get filterDrawerNoProjectsAvailable => 'Aucun projet disponible.';

  @override
  String get version => "Version";
  @override
  String get package => "Package";

  @override
  String get notSelected => "Non sélectionné";
  @override
  String get cantSetTimeinPast => "Impossible de définir une date passée";

  @override
  String get editDescription => "Modifier la description";
  @override
  String get editProject => "Modifier le projet";
  @override
  String get cancel => "Annuler";
  @override
  String get submit => "Soumettre";

  @override
  String get saveChangesConfirmation =>
      'Voulez-vous enregistrer les modifications ?';
  @override
  String get yes => 'Oui';
  @override
  String get no => 'Non';
  @override
  String get reviewChanges => 'Revoir les modifications';
  @override
  String get oldChanges => 'Ancien';
  @override
  String get newChanges => 'Nouveau';

  @override
  String get tags => 'Tags';
  @override
  String get addedTagsWillAppearHere => 'Les tags ajoutés apparaîtront ici';
  @override
  String get addTag => 'Ajouter un tag';

  @override
  String get enterProject => 'Entrer un projet';
  @override
  String get allProjects => 'Tous les projets';
  @override
  String get noProjectsFound => 'Aucun projet trouvé';
  @override
  String get project => 'Projet';

  @override
  String get select => 'Sélectionner';
  @override
  String get save => 'Enregistrer';
  @override
  String get dontSave => 'Ne pas enregistrer';
  @override
  String get unsavedChanges => 'Modifications non enregistrées';
  @override
  String get unsavedChangesWarning =>
      'Vous avez des modifications non enregistrées. Que souhaitez-vous faire ?';
  @override
  String get enterNew => 'Entrer une nouvelle';
  @override
  String get edit => 'Modifier';
  @override
  String get task => 'Tâche';

// Chaînes d'actions des tâches
  @override
  String get confirmDeleteTask => 'Confirmer la suppression';
  @override
  String get taskUpdated => 'Tâche mise à jour';
  @override
  String get undo => 'Annuler';
  @override
  String get taskMarkedAsCompleted =>
      'Tâche marquée comme terminée. Rafraîchissez pour voir les modifications !';
  @override
  String get taskMarkedAsDeleted =>
      'Tâche marquée comme supprimée. Rafraîchissez pour voir les modifications !';
  @override
  String get refreshToViewChanges => 'Rafraîchir pour voir les modifications';
  @override
  String get clickOnBottomRightButtonToStartAddingTasks =>
      'Cliquez sur le bouton en bas à droite pour commencer à ajouter des tâches';
  @override
  String get complete => 'TERMINER';
  @override
  String get delete => 'SUPPRIMER';

// Gestion du serveur de tâches
  @override
  String get taskServerInfo => 'Informations du serveur TaskD';
  @override
  String get taskServerCredentials => 'Identifiants du serveur TaskD';
  @override
  String get notConfigured => 'Non configuré';
  @override
  String get fetchingStatistics => 'Récupération des statistiques...';
  @override
  String get pleaseWait => 'Veuillez patienter...';
  @override
  String get statistics => 'Statistiques :';
  @override
  String get ok => 'Ok';
  @override
  String get pleaseSetupTaskServer =>
      'Veuillez configurer votre serveur TaskD.';

// Chaînes d'intégration
  @override
  String get onboardingSkip => 'Passer';
  @override
  String get onboardingNext => 'Suivant';
  @override
  String get onboardingStart => 'Commencer';

// Chaînes des permissions
  @override
  String get permissionPageTitle =>
      'Pourquoi avons-nous besoin de votre autorisation';
  @override
  String get storagePermissionTitle => 'Autorisation de stockage';
  @override
  String get storagePermissionDescription =>
      'Nous utilisons l\'accès au stockage pour enregistrer vos tâches, '
      'préférences et données de l\'application en toute sécurité sur votre appareil. '
      'Cela vous permet de reprendre votre travail là où vous l\'avez laissé, même hors ligne.';
  @override
  String get notificationPermissionTitle => 'Autorisation de notifications';
  @override
  String get notificationPermissionDescription =>
      'Les notifications vous tiennent informé des rappels importants et des mises à jour, '
      'vous aidant à rester organisé sans effort.';
  @override
  String get privacyStatement =>
      'Votre vie privée est notre priorité. Nous n\'accédons jamais à vos fichiers personnels '
      'ni ne partageons vos données sans votre consentement.';
  @override
  String get grantPermissions => 'Accorder les autorisations';
  @override
  String get managePermissionsLater =>
      'Vous pouvez gérer vos autorisations plus tard dans les paramètres';

// Chaînes de la page de profil
  @override
  String get profileAllProfiles => 'Tous les profils :';
  @override
  String get profileSwitchedToProfile => 'Changé de profil';
  @override
  String get profileAddedSuccessfully => 'Profil ajouté avec succès';
  @override
  String get profileAdditionFailed => 'Échec de l\'ajout du profil';
  @override
  String get profileConfigCopied => 'Configuration du profil copiée';
  @override
  String get profileConfigCopyFailed =>
      'Échec de la copie de la configuration du profil';
  @override
  String get profileDeletedSuccessfully => 'Supprimé avec succès';
  @override
  String get profileDeletionFailed => 'Échec de la suppression';
  @override
  String get profileDeleteConfirmation => 'Confirmer';

// Chaînes des rapports
  @override
  String get reportsDate => 'Date';
  @override
  String get reportsPending => 'En attente';
  @override
  String get reportsCompleted => 'Terminé';
  @override
  String get reportsMonthYear => 'Mois-Année';
  @override
  String get reportsWeek => 'Semaine';
  @override
  String get reportsDay => 'Jour';
  @override
  String get reportsYear => 'Année';
  @override
  String get reportsError => 'Erreur';
  @override
  String get reportsLoading => 'Chargement...';

// Chaînes des paramètres
  @override
  String get settingsResetToDefault => 'Réinitialiser par défaut';
  @override
  String get settingsAlreadyDefault => 'Déjà par défaut';
  @override
  String get settingsConfirmReset =>
      'Êtes-vous sûr de vouloir réinitialiser le répertoire aux paramètres par défaut ?';
  @override
  String get settingsNoButton => 'Non';
  @override
  String get settingsYesButton => 'Oui';

// Chaînes de l'écran de démarrage
  @override
  String get splashSettingUpApp => "Configuration de l'application...";

// Chaînes du tour - rapports
  @override
  String get tourReportsDaily =>
      "Accédez à votre rapport quotidien des tâches ici";
  @override
  String get tourReportsWeekly =>
      "Accédez à vos rapports hebdomadaires des tâches ici";
  @override
  String get tourReportsMonthly =>
      "Accédez à vos rapports mensuels des tâches ici";

// Chaînes du tour - profil
  @override
  String get tourProfileCurrent => "Voir votre profil actuel ici";
  @override
  String get tourProfileManage => "Gérez votre profil actuel ici";
  @override
  String get tourProfileAddNew => "Ajoutez un nouveau profil ici";

// Chaînes du tour - serveur de tâches
  @override
  String get tourTaskServerTaskRC =>
      "Sélectionnez le fichier nommé taskrc ici ou collez son contenu";
  @override
  String get tourTaskServerCertificate =>
      "Sélectionnez le fichier nommé comme <Votre Email>.com.cert.pem ici";
  @override
  String get tourTaskServerKey =>
      "Sélectionnez le fichier nommé comme <Votre Email>.key.pem ici";
  @override
  String get tourTaskServerRootCert =>
      "Sélectionnez le fichier nommé comme letsencrypt_root_cert.pem ici";

// Chaînes du tour - page d'accueil
  @override
  String get tourHomeAddTask => "Ajouter une nouvelle tâche";
  @override
  String get tourHomeSearch => "Rechercher des tâches";
  @override
  String get tourHomeRefresh => "Rafraîchir ou synchroniser vos tâches";
  @override
  String get tourHomeFilter =>
      "Ajouter des filtres pour trier vos tâches et projets";
  @override
  String get tourHomeMenu => "Accéder aux paramètres supplémentaires ici";

  @override
  String get tourDetailsDue => "Cela signifie la date d'échéance de la tâche";

  @override
  String get tourDetailsPriority =>
      "Ceci est la priorité des tâches \n L -> Faible \n M -> Moyenne \n H -> Élevée";

  @override
  String get tourDetailsUntil => "Cela montre la dernière date de la tâche";

  @override
  String get tourDetailsWait =>
      "Cela signifie la date d'attente de la tâche \n La tâche sera visible après cette date";

  @override
  String get tourFilterProjects => "Filtrer les tâches en fonction des projets";

  @override
  String get tourFilterSort =>
      "Trier les tâches en fonction de la date de création, de l'urgence, de la date d'échéance, de la date de début, etc.";

  @override
  String get tourFilterStatus =>
      "Filtrer les tâches en fonction de leur état d'achèvement";

  @override
  String get tourFilterTagUnion =>
      "Basculer entre les types d'union de balises ET et OU";
  @override
  String get descriprtionCannotBeEmpty =>
      "La description ne peut pas être vide";
  @override
  String get enterTaskDescription => "Entrez la description de la tâche";
  @override
  String get canNotHaveWhiteSpace => "Ne peut pas contenir d'espaces blancs";
  @override
  String get high => "Élevée";
  @override
  String get medium => "Moyenne";
  @override
  String get low => "Faible";
  @override
  String get priority => "Priorité";
  @override
  String get tagAlreadyExists => "Le tag existe déjà";
  @override
  String get tagShouldNotContainSpaces =>
      "Le tag ne doit pas contenir d'espaces";
  @override
  String get date => "Date";
  @override
  String get add => "Ajouter";
  @override
  String get change => "Changer";
  @override
  String get dateCanNotBeInPast => "La date ne peut pas être dans le passé";
  @override
  String get configureTaskchampion =>
      "Configurer Taskchampion pour la synchronisation";
  @override
  String get encryptionSecret => 'Secret de chiffrement';
  @override
  String get ccsyncBackendUrl => 'URL du backend CCSync';
  @override
  String get ccsyncClientId => 'ID client';
  @override
  String get success => 'Succès';
  @override
  String get credentialsSavedSuccessfully =>
      'Identifiants enregistrés avec succès';
  @override
  String get saveCredentials => 'enregistrer les identifiants';
  @override
  String get tip =>
      "Astuce : Cliquez sur l'icône d'information en haut à droite pour obtenir vos identifiants";
  @override
  String get logs => 'Journaux';
  @override
  String get checkAllDebugLogsHere =>
      'Vérifiez tous les journaux de débogage ici';
}
