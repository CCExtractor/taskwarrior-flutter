import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/utils/language/spanish_sentences.dart';

void main() {
  final spanish = SpanishSentences();

  test('should provide correct Spanish translations', () {
    expect(spanish.helloWorld, '¡Hola, mundo!');
    expect(spanish.homePageTitle, 'Página de inicio');
    expect(spanish.homePageLastModified, 'Última modificación');
    expect(spanish.homePageDue, 'Vencimiento');
    expect(
        spanish.homePageTaskWarriorNotConfigured, 'TaskServer no configurado');
    expect(spanish.homePageSetup, 'Configuración');
    expect(spanish.homePageFilter, 'Filtro');
    expect(spanish.homePageMenu, 'Menú');
    expect(spanish.homePageExitApp, 'Salir de la aplicación');
    expect(spanish.homePageAreYouSureYouWantToExit,
        '¿Estás seguro de que quieres salir de la aplicación?');
    expect(spanish.homePageExit, 'Salir');
    expect(spanish.homePageCancel, 'Cancelar');
    expect(spanish.homePageClickOnTheBottomRightButtonToStartAddingTasks,
        'Haz clic en el botón en la parte inferior derecha para comenzar a agregar tareas');
    expect(spanish.homePageSearchNotFound,
        'No se encontraron resultados para la búsqueda');
    expect(spanish.settingsPageTitle, 'Página de configuración');
    expect(spanish.settingsPageSubtitle, 'Configura tus preferencias');
    expect(spanish.settingsPageMovingDataToNewDirectory,
        'Moviendo datos a un nuevo directorio');
    expect(spanish.settingsPageSyncOnStartTitle,
        'Sincronizar datos automáticamente al inicio');
    expect(
        spanish.settingsPageSyncOnStartDescription, 'Sincronizar al iniciar');
    expect(spanish.settingsPageEnableSyncOnTaskCreateTitle,
        'Habilitar sincronización automática al crear nuevas tareas');
    expect(spanish.settingsPageEnableSyncOnTaskCreateDescription,
        'Habilitar sincronización automática al crear nuevas tareas');
    expect(spanish.settingsPageHighlightTaskTitle,
        'Resaltar tareas con 1 día restante');
    expect(spanish.settingsPageHighlightTaskDescription,
        'Resaltar tareas con 1 día restante');
    expect(spanish.settingsPageEnable24hrFormatTitle,
        'Habilitar formato de 24 horas');
    expect(spanish.settingsPageEnable24hrFormatDescription,
        'Habilitar formato de 24 horas');
    expect(spanish.settingsPageSelectLanguage, 'Seleccionar idioma');
    expect(spanish.settingsPageToggleNativeLanguage,
        'Alternar entre idiomas nativos');
    expect(spanish.settingsPageSelectDirectoryTitle, 'Seleccionar directorio');
    expect(spanish.settingsPageSelectDirectoryDescription,
        'Selecciona el directorio donde se almacenan los datos de Taskwarrior\nDirectorio actual: ');
    expect(spanish.settingsPageChangeDirectory, 'Cambiar directorio');
    expect(spanish.settingsPageSetToDefault, 'Restablecer a predeterminado');
    expect(spanish.navDrawerProfile, 'Perfil');
    expect(spanish.navDrawerReports, 'Informes');
    expect(spanish.navDrawerAbout, 'Acerca de');
    expect(spanish.navDrawerSettings, 'Configuración');
    expect(spanish.navDrawerExit, 'Salir');
    expect(spanish.detailPageDescription, 'Descripción');
    expect(spanish.detailPageStatus, 'Estado');
    expect(spanish.detailPageEntry, 'Entrada');
    expect(spanish.detailPageModified, 'Modificado');
    expect(spanish.detailPageStart, 'Inicio');
    expect(spanish.detailPageEnd, 'Fin');
    expect(spanish.detailPageDue, 'Vencimiento');
    expect(spanish.detailPageWait, 'Esperar');
    expect(spanish.detailPageUntil, 'Hasta');
    expect(spanish.detailPagePriority, 'Prioridad');
    expect(spanish.detailPageProject, 'Proyecto');
    expect(spanish.detailPageTags, 'Etiquetas');
    expect(spanish.detailPageUrgency, 'Urgencia');
    expect(spanish.detailPageID, 'ID');
    expect(spanish.filterDrawerApplyFilters, 'Aplicar filtros');
    expect(spanish.filterDrawerHideWaiting, 'Ocultar pendientes');
    expect(spanish.filterDrawerShowWaiting, 'Mostrar pendientes');
    expect(spanish.filterDrawerPending, 'Pendiente');
    expect(spanish.filterDrawerCompleted, 'Completado');
    expect(spanish.filterDrawerFilterTagBy, 'Filtrar por etiqueta');
    expect(spanish.filterDrawerAND, 'y');
    expect(spanish.filterDrawerOR, 'o');
    expect(spanish.filterDrawerSortBy, 'Ordenar por');
    expect(spanish.filterDrawerCreated, 'Creado');
    expect(spanish.filterDrawerModified, 'Modificado');
    expect(spanish.filterDrawerStartTime, 'Hora de inicio');
    expect(spanish.filterDrawerDueTill, 'Hasta vencimiento');
    expect(spanish.filterDrawerPriority, 'Prioridad');
    expect(spanish.filterDrawerProject, 'Proyecto');
    expect(spanish.filterDrawerTags, 'Etiquetas');
    expect(spanish.filterDrawerUrgency, 'Urgencia');
    expect(spanish.filterDrawerResetSort, 'Restablecer orden');
    expect(spanish.filterDrawerStatus, 'Estado');
    expect(spanish.reportsPageTitle, 'Informes');
    expect(spanish.reportsPageCompleted, 'Completado');
    expect(spanish.reportsPagePending, 'Pendiente');
    expect(spanish.reportsPageTasks, 'Tareas');
    expect(spanish.reportsPageDaily, 'Diario');
    expect(spanish.reportsPageDailyBurnDownChart, 'Gráfico de quema diario');
    expect(spanish.reportsPageDailyDayMonth, 'Día - Mes');
    expect(spanish.reportsPageWeekly, 'Semanal');
    expect(spanish.reportsPageWeeklyBurnDownChart, 'Gráfico de quema semanal');
    expect(spanish.reportsPageWeeklyWeeksYear, 'Semana - Año');
    expect(spanish.reportsPageMonthly, 'Mensual');
    expect(spanish.reportsPageMonthlyBurnDownChart, 'Gráfico de quema mensual');
    expect(spanish.reportsPageMonthlyMonthYear, 'Mes - Año');
    expect(spanish.reportsPageNoTasksFound, 'No se encontraron tareas');
    expect(spanish.reportsPageAddTasksToSeeReports,
        'Agrega tareas para ver informes');
    expect(spanish.taskchampionTileDescription,
        'Cambia la sincronización de Taskwarrior al servidor de sincronización CCSync o Taskchampion');
    expect(spanish.taskchampionTileTitle, 'Sincronización Taskchampion');
    expect(spanish.ccsyncCredentials, 'Credenciales de CCSync');
    expect(spanish.deleteTaskConfirmation, 'Eliminar tarea');
    expect(spanish.deleteTaskTitle, '¿Eliminar todas las tareas?');
    expect(spanish.deleteTaskWarning,
        'Esta acción es irreversible y eliminará todas las tareas almacenadas localmente.');
    expect(spanish.profilePageProfile, 'Perfil');
    expect(spanish.profilePageProfiles, 'Perfiles');
    expect(spanish.profilePageCurrentProfile, 'Perfil actual');
    expect(spanish.profilePageManageSelectedProfile,
        'Gestionar perfil seleccionado');
    expect(spanish.profilePageRenameAlias, 'Renombrar alias');
    expect(spanish.profilePageConfigureTaskserver,
        'Configurar servidor de tareas');
    expect(spanish.profilePageExportTasks, 'Exportar tareas');
    expect(spanish.profilePageCopyConfigToNewProfile,
        'Copiar configuración a un nuevo perfil');
    expect(spanish.profilePageDeleteProfile, 'Eliminar perfil');
    expect(spanish.profilePageAddNewProfile, 'Agregar nuevo perfil');
    expect(spanish.profilePageRenameAliasDialogueBoxTitle, 'Renombrar alias');
    expect(spanish.profilePageRenameAliasDialogueBoxNewAlias, 'Nuevo alias');
    expect(spanish.profilePageRenameAliasDialogueBoxCancel, 'Cancelar');
    expect(spanish.profilePageRenameAliasDialogueBoxSubmit, 'Enviar');
    expect(
        spanish.profilePageExportTasksDialogueTitle, 'Formato de exportación');
    expect(spanish.profilePageExportTasksDialogueSubtitle,
        'Selecciona el formato de exportación');
    expect(spanish.manageTaskServerPageConfigureTaskserver,
        'Configurar servidor de tareas');
    expect(spanish.manageTaskServerPageConfigureTASKRC, 'Configurar TASKRC');
    expect(spanish.manageTaskServerPageSetTaskRC, 'Establecer TaskRC');
    expect(spanish.manageTaskServerPageConfigureYourCertificate,
        'Configura tu certificado');
    expect(spanish.manageTaskServerPageSelectCertificate,
        'Seleccionar certificado');
    expect(spanish.manageTaskServerPageConfigureTaskserverKey,
        'Configurar clave del servidor de tareas');
    expect(spanish.manageTaskServerPageSelectKey, 'Seleccionar clave');
    expect(spanish.manageTaskServerPageConfigureServerCertificate,
        'Configurar certificado del servidor');
    expect(spanish.manageTaskServerPageTaskRCFileIsVerified,
        'El archivo Task RC ha sido verificado');
    expect(spanish.manageTaskServerPageConfigureTaskRCDialogueBoxTitle,
        'Configurar TaskRC');
    expect(spanish.manageTaskServerPageConfigureTaskRCDialogueBoxSubtitle,
        'Pega el contenido de TaskRC o selecciona un archivo taskrc');
    expect(spanish.manageTaskServerPageConfigureTaskRCDialogueBoxInputFieldText,
        'Pega tu contenido TaskRC aquí');
    expect(spanish.manageTaskServerPageConfigureTaskRCDialogueBoxOr, 'o');
    expect(spanish.manageTaskServerPageConfigureTaskRCDialogueBoxSelectTaskRC,
        'Seleccionar archivo TaskRC');
    expect(spanish.addTaskTitle, 'Agregar tarea');
    expect(spanish.addTaskEnterTask, 'Ingresar tarea');
    expect(spanish.addTaskDue, 'Vencimiento');
    expect(spanish.addTaskSelectDueDate, 'Seleccionar fecha de vencimiento');
    expect(spanish.addTaskPriority, 'Prioridad');
    expect(spanish.addTaskAddTags, 'Agregar etiquetas');
    expect(spanish.addTaskCancel, 'Cancelar');
    expect(spanish.addTaskAdd, 'Agregar');
    expect(
        spanish.addTaskTimeInPast, 'La hora seleccionada está en el pasado.');
    expect(spanish.addTaskFieldCannotBeEmpty,
        '¡No puedes dejar este campo vacío!');
    expect(spanish.addTaskTaskAddedSuccessfully,
        'Tarea añadida con éxito. Toca para editar');
    expect(spanish.aboutPageGitHubLink,
        '¿Desea mejorar este proyecto? Visite nuestro repositorio en GitHub.');
    expect(spanish.aboutPageAppBarTitle, 'Acerca de');
  });
}
