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
  String get settingsPageHighlightTaskTitle =>
      'Resaltar tareas con 1 día restante';
  @override
  String get settingsPageHighlightTaskDescription =>
      'Resaltar tareas con 1 día restante';
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
      'Selecciona el directorio donde se almacenan los datos de TaskWarrior\nDirectorio actual: ';
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
      'Cambia la sincronización de TaskWarrior al servidor de sincronización CCSync o Taskchampion';

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
}
