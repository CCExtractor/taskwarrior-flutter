import 'package:taskwarrior/app/utils/language/sentences.dart';

class SpanishSentences extends Sentences {
  @override
  String get helloWorld => '¡Hola, mundo!';
  @override
  String get homePageTitle => 'Página de inicio';
  @override
  String get homePageLastModified => 'Última modificación';
  @override
  String get homePageDue => 'Vencimiento';
  @override
  String get homePageTaskWarriorNotConfigured => 'TaskServer no configurado';
  @override
  String get homePageSetup => 'Configuración';
  @override
  String get homePageFilter => 'Filtro';
  @override
  String get homePageMenu => 'Menú';
  @override
  String get homePageExitApp => 'Salir de la aplicación';
  @override
  String get homePageAreYouSureYouWantToExit =>
      '¿Estás seguro de que quieres salir de la aplicación?';
  @override
  String get homePageExit => 'Salir';
  @override
  String get homePageCancel => 'Cancelar';
  @override
  String get homePageClickOnTheBottomRightButtonToStartAddingTasks =>
      'Haz clic en el botón en la parte inferior derecha para comenzar a agregar tareas';
  @override
  String get homePageSearchNotFound =>
      'No se encontraron resultados para la búsqueda';
  @override
  String get homePageFetchingTasks => 'Obteniendo tareas';
  @override
  String get settingsPageTitle => 'Página de configuración';
  @override
  String get settingsPageSubtitle => 'Configura tus preferencias';
  @override
  String get settingsPageMovingDataToNewDirectory =>
      'Moviendo datos a un nuevo directorio';
  @override
  String get settingsPageSyncOnStartTitle =>
      'Sincronizar datos automáticamente al inicio';
  @override
  String get settingsPageSyncOnStartDescription => 'Sincronizar al iniciar';
  @override
  String get settingsPageEnableSyncOnTaskCreateTitle =>
      'Habilitar sincronización automática al crear nuevas tareas';
  @override
  String get settingsPageEnableSyncOnTaskCreateDescription =>
      'Habilitar sincronización automática al crear nuevas tareas';
  @override
  String get settingsPageHighlightTaskTitle => 'Resaltar tareas urgentes';
  @override
  String get settingsPageHighlightTaskDescription =>
      'Resaltar tareas que vencen en 1 día o están vencidas';
  @override
  String get settingsPageEnable24hrFormatTitle =>
      'Habilitar formato de 24 horas';
  @override
  String get settingsPageEnable24hrFormatDescription =>
      'Habilitar formato de 24 horas';
  @override
  String get settingsPageSelectLanguage => 'Seleccionar idioma';
  @override
  String get settingsPageToggleNativeLanguage =>
      'Alternar entre idiomas nativos';
  @override
  String get settingsPageSelectDirectoryTitle => 'Seleccionar directorio';
  @override
  String get settingsPageSelectDirectoryDescription =>
      'Selecciona el directorio donde se almacenan los datos de Taskwarrior\nDirectorio actual: ';
  @override
  String get settingsPageChangeDirectory => 'Cambiar directorio';
  @override
  String get settingsPageSetToDefault => 'Restablecer a predeterminado';
  @override
  String get navDrawerProfile => 'Perfil';
  @override
  String get navDrawerReports => 'Informes';
  @override
  String get navDrawerAbout => 'Acerca de';
  @override
  String get navDrawerSettings => 'Configuración';
  @override
  String get navDrawerExit => 'Salir';

  @override
  String get detailPageDescription => 'Descripción';
  @override
  String get detailPageStatus => 'Estado';
  @override
  String get detailPageEntry => 'Entrada';
  @override
  String get detailPageModified => 'Modificado';
  @override
  String get detailPageStart => 'Inicio';
  @override
  String get detailPageEnd => 'Fin';
  @override
  String get detailPageDue => 'Vencimiento';
  @override
  String get detailPageWait => 'Esperar';
  @override
  String get detailPageUntil => 'Hasta';
  @override
  String get detailPagePriority => 'Prioridad';
  @override
  String get detailPageProject => 'Proyecto';
  @override
  String get detailPageTags => 'Etiquetas';
  @override
  String get detailPageUrgency => 'Urgencia';
  @override
  String get detailPageID => 'ID';

  @override
  String get filterDrawerApplyFilters => 'Aplicar filtros';
  @override
  String get filterDrawerHideWaiting => 'Ocultar pendientes';
  @override
  String get filterDrawerShowWaiting => 'Mostrar pendientes';
  @override
  String get filterDrawerPending => 'Pendiente';
  @override
  String get filterDrawerCompleted => 'Completado';
  @override
  String get filterDrawerFilterTagBy => 'Filtrar por etiqueta';
  @override
  String get filterDrawerAND => 'y';
  @override
  String get filterDrawerOR => 'o';
  @override
  String get filterDrawerSortBy => 'Ordenar por';
  @override
  String get filterDrawerCreated => 'Creado';
  @override
  String get filterDrawerModified => 'Modificado';
  @override
  String get filterDrawerStartTime => 'Hora de inicio';
  @override
  String get filterDrawerDueTill => 'Hasta vencimiento';
  @override
  String get filterDrawerPriority => 'Prioridad';
  @override
  String get filterDrawerProject => 'Proyecto';
  @override
  String get filterDrawerTags => 'Etiquetas';
  @override
  String get filterDrawerUrgency => 'Urgencia';
  @override
  String get filterDrawerResetSort => 'Restablecer orden';
  @override
  String get filterDrawerStatus => 'Estado';
  @override
  String get reportsPageTitle => 'Informes';
  @override
  String get reportsPageCompleted => 'Completado';
  @override
  String get reportsPagePending => 'Pendiente';
  @override
  String get reportsPageTasks => 'Tareas';

  @override
  String get reportsPageDaily => 'Diario';
  @override
  String get reportsPageDailyBurnDownChart => 'Gráfico de quema diario';
  @override
  String get reportsPageDailyDayMonth => 'Día - Mes';

  @override
  String get reportsPageWeekly => 'Semanal';
  @override
  String get reportsPageWeeklyBurnDownChart => 'Gráfico de quema semanal';
  @override
  String get reportsPageWeeklyWeeksYear => 'Semana - Año';

  @override
  String get reportsPageMonthly => 'Mensual';
  @override
  String get reportsPageMonthlyBurnDownChart => 'Gráfico de quema mensual';
  @override
  String get reportsPageMonthlyMonthYear => 'Mes - Año';

  @override
  String get reportsPageNoTasksFound => 'No se encontraron tareas';
  @override
  String get reportsPageAddTasksToSeeReports =>
      'Agrega tareas para ver informes';

  @override
  String get taskchampionTileDescription =>
      'Cambia la sincronización de Taskwarrior al servidor de sincronización CCSync o Taskchampion';

  @override
  String get taskchampionTileTitle => 'Sincronización Taskchampion';

  @override
  String get ccsyncCredentials => 'Credenciales de CCSync';

  @override
  String get deleteTaskConfirmation => 'Eliminar tarea';

  @override
  String get deleteTaskTitle => '¿Eliminar todas las tareas?';

  @override
  String get deleteTaskWarning =>
      'Esta acción es irreversible y eliminará todas las tareas almacenadas localmente.';

  @override
  String get deleteAllTasksWillBeMarkedAsDeleted =>
      'Esto marcará todas las tareas como eliminadas y no aparecerán en la aplicación.';

  @override
  String get profilePageProfile => 'Perfil';
  @override
  String get profilePageProfiles => 'Perfiles';
  @override
  String get profilePageCurrentProfile => 'Perfil actual';
  @override
  String get profilePageManageSelectedProfile =>
      'Gestionar perfil seleccionado';
  @override
  String get profilePageRenameAlias => 'Renombrar alias';

  @override
  String get profilePageConfigureTaskserver => 'Configurar servidor de tareas';
  @override
  String get profilePageExportTasks => 'Exportar tareas';
  @override
  String get profilePageChangeProfileMode =>
      'Cambiar servidor de sincronización';
  @override
  String get profilePageSelectProfileMode => 'Selecciona un servidor';
  @override
  String get profilePageCopyConfigToNewProfile =>
      'Copiar configuración a un nuevo perfil';
  @override
  String get profilePageDeleteProfile => 'Eliminar perfil';
  @override
  String get profilePageAddNewProfile => 'Agregar nuevo perfil';

  @override
  String get profilePageRenameAliasDialogueBoxTitle => 'Renombrar alias';
  @override
  String get profilePageRenameAliasDialogueBoxNewAlias => 'Nuevo alias';
  @override
  String get profilePageRenameAliasDialogueBoxCancel => 'Cancelar';
  @override
  String get profilePageSuccessfullyChangedProfileModeTo =>
      'Modo de perfil cambiado correctamente a: ';
  @override
  String get profilePageRenameAliasDialogueBoxSubmit => 'Enviar';

  @override
  String get profilePageExportTasksDialogueTitle => 'Formato de exportación';
  @override
  String get profilePageExportTasksDialogueSubtitle =>
      'Selecciona el formato de exportación';

  @override
  String get manageTaskServerPageConfigureTaskserver =>
      'Configurar servidor de tareas';
  @override
  String get manageTaskServerPageConfigureTASKRC => 'Configurar TASKRC';
  @override
  String get manageTaskServerPageSetTaskRC => 'Establecer TaskRC';
  @override
  String get manageTaskServerPageConfigureYourCertificate =>
      'Configura tu certificado';
  @override
  String get manageTaskServerPageSelectCertificate => 'Seleccionar certificado';
  @override
  String get manageTaskServerPageConfigureTaskserverKey =>
      'Configurar clave del servidor de tareas';
  @override
  String get manageTaskServerPageSelectKey => 'Seleccionar clave';
  @override
  String get manageTaskServerPageConfigureServerCertificate =>
      'Configurar certificado del servidor';
  @override
  String get manageTaskServerPageTaskRCFileIsVerified =>
      'El archivo Task RC ha sido verificado';

  @override
  String get manageTaskServerPageConfigureTaskRCDialogueBoxTitle =>
      'Configurar TaskRC';
  @override
  String get manageTaskServerPageConfigureTaskRCDialogueBoxSubtitle =>
      'Pega el contenido de TaskRC o selecciona un archivo taskrc';
  @override
  String get manageTaskServerPageConfigureTaskRCDialogueBoxInputFieldText =>
      'Pega tu contenido TaskRC aquí';
  @override
  String get manageTaskServerPageConfigureTaskRCDialogueBoxOr => 'o';
  @override
  String get manageTaskServerPageConfigureTaskRCDialogueBoxSelectTaskRC =>
      'Seleccionar archivo TaskRC';

  @override
  String get addTaskTitle => "Agregar tarea";
  @override
  String get addTaskEnterTask => "Ingresar tarea";
  @override
  String get addTaskDue => "Vencimiento";
  @override
  String get addTaskSelectDueDate => "Seleccionar fecha de vencimiento";
  @override
  String get addTaskPriority => "Prioridad";
  @override
  String get addTaskAddTags => "Agregar etiquetas";
  @override
  String get addTaskCancel => "Cancelar";
  @override
  String get addTaskAdd => "Agregar";
  @override
  String get addTaskTimeInPast => "La hora seleccionada está en el pasado.";
  @override
  String get addTaskFieldCannotBeEmpty => "¡No puedes dejar este campo vacío!";
  @override
  String get addTaskTaskAddedSuccessfully =>
      "Tarea añadida con éxito. Toca para editar";

  @override
  String get aboutPageGitHubLink =>
      "¿Desea mejorar este proyecto? Visite nuestro repositorio en GitHub.";
  @override
  String get aboutPageProjectDescription =>
      "Este proyecto tiene como objetivo construir una aplicación para Taskwarrior. Es su aplicación de gestión de tareas en todas las plataformas. Le ayuda a gestionar sus tareas y a filtrarlas según sus necesidades.";
  @override
  String get aboutPageAppBarTitle => "Acerca de";

  @override
  String get homePageSearchTooltip => 'Buscar';
  @override
  String get homePageCancelSearchTooltip => 'Cancelar';
  @override
  String get homePageAddTaskTooltip => 'Agregar tarea';
  @override
  String get homePageTapBackToExit => 'Toca atrás nuevamente para salir';
  @override
  String get homePageSearchHint => 'Buscar';

  @override
  String get navDrawerConfirm => 'Confirmar';

  @override
  String get filterDrawerNoProjectsAvailable => 'No hay proyectos disponibles.';

  @override
  String get version => "Versión";
  @override
  String get package => "Paquete";

  @override
  String get notSelected => "No seleccionado";
  @override
  String get cantSetTimeinPast =>
      "No se pueden establecer horarios en el pasado";

  @override
  String get editDescription => "Editar descripción";
  @override
  String get editProject => "Editar proyecto";
  @override
  String get cancel => "Cancelar";
  @override
  String get submit => "Enviar";

  @override
  String get saveChangesConfirmation => '¿Quieres guardar los cambios?';
  @override
  String get yes => 'Sí';
  @override
  String get no => 'No';
  @override
  String get reviewChanges => 'Revisar cambios';
  @override
  String get oldChanges => 'Antiguo';
  @override
  String get newChanges => 'Nuevo';

  @override
  String get tags => 'Etiquetas';
  @override
  String get addedTagsWillAppearHere =>
      'Las etiquetas añadidas aparecerán aquí';
  @override
  String get addTag => 'Agregar etiqueta';

  @override
  String get enterProject => 'Ingresar proyecto';
  @override
  String get allProjects => 'Todos los proyectos';
  @override
  String get noProjectsFound => 'No se encontraron proyectos';
  @override
  String get project => 'Proyecto';

  @override
  String get select => 'Seleccionar';
  @override
  String get save => 'Guardar';
  @override
  String get dontSave => 'No guardar';
  @override
  String get unsavedChanges => 'Cambios no guardados';
  @override
  String get unsavedChangesWarning =>
      'Tienes cambios no guardados. ¿Qué deseas hacer?';
  @override
  String get enterNew => 'Ingresar nuevo';
  @override
  String get edit => 'Editar';
  @override
  String get task => 'Tarea';

// task action strings
  @override
  String get confirmDeleteTask => 'Confirmar eliminación';
  @override
  String get taskUpdated => 'Tarea actualizada';
  @override
  String get undo => 'Deshacer';
  @override
  String get taskMarkedAsCompleted =>
      'Tarea marcada como completada. ¡Actualiza para ver los cambios!';
  @override
  String get taskMarkedAsDeleted =>
      'Tarea marcada como eliminada. ¡Actualiza para ver los cambios!';
  @override
  String get refreshToViewChanges => 'Actualizar para ver cambios';
  @override
  String get clickOnBottomRightButtonToStartAddingTasks =>
      'Haz clic en el botón inferior derecho para comenzar a agregar tareas';
  @override
  String get complete => 'COMPLETADO';
  @override
  String get delete => 'ELIMINAR';

// task server management strings
  @override
  String get taskServerInfo => 'Información del servidor TaskD';
  @override
  String get taskServerCredentials => 'Credenciales del servidor TaskD';
  @override
  String get notConfigured => 'No configurado';
  @override
  String get fetchingStatistics => 'Obteniendo estadísticas...';
  @override
  String get pleaseWait => 'Por favor, espera...';
  @override
  String get statistics => 'Estadísticas:';
  @override
  String get ok => 'Ok';
  @override
  String get pleaseSetupTaskServer => 'Por favor, configura tu servidor TaskD.';

// onboarding strings
  @override
  String get onboardingSkip => 'Omitir';
  @override
  String get onboardingNext => 'Siguiente';
  @override
  String get onboardingStart => 'Comenzar';

// permission strings
  @override
  String get permissionPageTitle => 'Por qué necesitamos tu permiso';
  @override
  String get storagePermissionTitle => 'Permiso de almacenamiento';
  @override
  String get storagePermissionDescription =>
      'Utilizamos el acceso al almacenamiento para guardar tus tareas, '
      'preferencias y datos de la aplicación de forma segura en tu dispositivo. '
      'Esto garantiza que puedas continuar donde lo dejaste, incluso sin conexión.';
  @override
  String get notificationPermissionTitle => 'Permiso de notificaciones';
  @override
  String get notificationPermissionDescription =>
      'Las notificaciones te mantienen al tanto de recordatorios importantes '
      'y actualizaciones, asegurando que gestiones tus tareas sin esfuerzo.';
  @override
  String get privacyStatement =>
      'Tu privacidad es nuestra máxima prioridad. Nunca accedemos ni compartimos '
      'tus archivos o datos personales sin tu consentimiento.';
  @override
  String get grantPermissions => 'Conceder permisos';
  @override
  String get managePermissionsLater =>
      'Puedes administrar tus permisos más tarde en Configuración';

// Profile page strings
  @override
  String get profileAllProfiles => 'Todos los perfiles:';
  @override
  String get profileSwitchedToProfile => 'Cambiado al perfil';
  @override
  String get profileAddedSuccessfully => 'Perfil agregado con éxito';
  @override
  String get profileAdditionFailed => 'Error al agregar perfil';
  @override
  String get profileConfigCopied => 'Configuración del perfil copiada';
  @override
  String get profileConfigCopyFailed =>
      'Error al copiar la configuración del perfil';
  @override
  String get profileDeletedSuccessfully => 'Eliminado con éxito';
  @override
  String get profileDeletionFailed => 'Error al eliminar';
  @override
  String get profileDeleteConfirmation => 'Confirmar';

// Reports strings
  @override
  String get reportsDate => 'Fecha';
  @override
  String get reportsPending => 'Pendiente';
  @override
  String get reportsCompleted => 'Completado';
  @override
  String get reportsMonthYear => 'Mes-Año';
  @override
  String get reportsWeek => 'Semana';
  @override
  String get reportsDay => 'Día';
  @override
  String get reportsYear => 'Año';
  @override
  String get reportsError => 'Error';
  @override
  String get reportsLoading => 'Cargando...';

// Settings strings
  @override
  String get settingsResetToDefault => 'Restablecer a predeterminado';
  @override
  String get settingsAlreadyDefault => 'Ya está predeterminado';
  @override
  String get settingsConfirmReset =>
      '¿Estás seguro de que deseas restablecer el directorio a los valores predeterminados?';
  @override
  String get settingsNoButton => 'No';
  @override
  String get settingsYesButton => 'Sí';

// Splash screen strings
  @override
  String get splashSettingUpApp => "Configurando la aplicación...";

// Tour strings - reports
  @override
  String get tourReportsDaily => "Accede a tu informe de tareas diarias aquí";
  @override
  String get tourReportsWeekly => "Accede a tus informes semanales aquí";
  @override
  String get tourReportsMonthly => "Accede a tus informes mensuales aquí";

// Tour strings - profile
  @override
  String get tourProfileCurrent => "Consulta tu perfil actual aquí";
  @override
  String get tourProfileManage => "Administra tu perfil actual aquí";
  @override
  String get tourProfileAddNew => "Agrega un nuevo perfil aquí";

// Tour strings - task server
  @override
  String get tourTaskServerTaskRC =>
      "Selecciona el archivo llamado taskrc aquí o pega su contenido";
  @override
  String get tourTaskServerCertificate =>
      "Selecciona un archivo con un nombre similar a <Tu Email>.com.cert.pem aquí";
  @override
  String get tourTaskServerKey =>
      "Selecciona un archivo con un nombre similar a <Tu Email>.key.pem aquí";
  @override
  String get tourTaskServerRootCert =>
      "Selecciona un archivo con un nombre similar a letsencrypt_root_cert.pem aquí";

// Tour strings - home page
  @override
  String get tourHomeAddTask => "Agregar una nueva tarea";
  @override
  String get tourHomeSearch => "Buscar tareas";
  @override
  String get tourHomeRefresh => "Actualizar o sincronizar tus tareas";
  @override
  String get tourHomeFilter =>
      "Agregar filtros para ordenar tus tareas y proyectos";
  @override
  String get tourHomeMenu => "Acceder a configuraciones adicionales aquí";

// Tour strings - filter drawer
  @override
  String get tourFilterStatus =>
      "Filtrar tareas según su estado de finalización";
  @override
  String get tourFilterProjects => "Filtrar tareas según los proyectos";
  @override
  String get tourFilterTagUnion =>
      "Alternar entre los tipos de unión de etiquetas AND y OR";
  @override
  String get tourFilterSort =>
      "Ordenar tareas según el tiempo de creación, urgencia, fecha de vencimiento, fecha de inicio, etc.";

// Tour strings - details page
  @override
  String get tourDetailsDue =>
      "Esto indica la fecha de vencimiento de la tarea";
  @override
  String get tourDetailsWait =>
      "Esto indica la fecha de espera de la tarea\nLa tarea será visible después de esta fecha";
  @override
  String get tourDetailsUntil => "Esto muestra la última fecha de la tarea";
  @override
  String get tourDetailsPriority =>
      "Esta es la prioridad de las tareas\nL -> Baja\nM -> Media\nH -> Alta";
  @override
  String get descriprtionCannotBeEmpty => "La descripción no puede estar vacía";
  @override
  String get enterTaskDescription => "Ingresar descripción de la tarea";
  @override
  String get canNotHaveWhiteSpace => "No puede tener espacios en blanco";
  @override
  String get high => "Alta";
  @override
  String get medium => "Media";
  @override
  String get low => "Baja";
  @override
  String get priority => "Prioridad";
  @override
  String get tagAlreadyExists => "¡La etiqueta ya existe!";
  @override
  String get tagShouldNotContainSpaces =>
      "¡La etiqueta no debe contener espacios!";
  @override
  String get date => "Fecha";
  @override
  String get add => "Agregar";
  @override
  String get change => "Cambiar";
  @override
  String get dateCanNotBeInPast => "La fecha no puede estar en el pasado";
  @override
  String get configureTaskchampion => "Configurar Taskchampion";
  @override
  String get encryptionSecret => 'Secreto de cifrado';
  @override
  String get ccsyncBackendUrl => 'URL del backend de CCSync';
  @override
  String get ccsyncClientId => 'ID de cliente';
  @override
  String get success => 'Éxito';
  @override
  String get credentialsSavedSuccessfully => 'Credenciales guardadas con éxito';
  @override
  String get saveCredentials => 'guardar credenciales';
  @override
  String get tip =>
      "Consejo: Haz clic en el ícono de información en la esquina superior derecha para obtener tus credenciales";
  @override
  String get logs => 'Registros';
  @override
  String get checkAllDebugLogsHere =>
      'Consulta todos los registros de depuración aquí';

  @override
  String get tutorialModalWelcome => '¡Bienvenido!';
  @override
  String get tutorialModalMessage =>
      '¿Te gustaría ver un tutorial rápido para aprender a usar esta aplicación?';
  @override
  String get tutorialModalKeepTutorials => 'Mantener tutoriales';
  @override
  String get tutorialModalSkipAllTutorials => 'Omitir todos los tutoriales';
}
