// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Field Tracker';

  @override
  String get homeTitle => 'Ordem de Serviço';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get trackingTitle => 'Rastreamento';

  @override
  String get technicianName => 'Nome do Técnico';

  @override
  String get technicianId => 'ID do Técnico';

  @override
  String get serviceOrderNumber => 'Número da Ordem de Serviço';

  @override
  String get startTracking => 'Iniciar Rastreamento';

  @override
  String get stopTracking => 'Finalizar Ordem de Serviço';

  @override
  String get refresh => 'Atualizar';

  @override
  String get map => 'Mapa';

  @override
  String get details => 'Detalhes';

  @override
  String get trackingActive => 'Rastreamento Ativo';

  @override
  String get waitingLocation => 'Aguardando localização...';

  @override
  String get latitude => 'Latitude';

  @override
  String get longitude => 'Longitude';

  @override
  String get accuracy => 'Precisão';

  @override
  String get altitude => 'Altitude';

  @override
  String get speed => 'Velocidade';

  @override
  String get lastUpdate => 'Última atualização';

  @override
  String get distance => 'Distância';

  @override
  String get duration => 'Duração';

  @override
  String get points => 'Pontos';

  @override
  String get confirmFinish => 'Finalizar Ordem de Serviço?';

  @override
  String get confirmFinishMessage =>
      'Isso irá parar o rastreamento e salvar a rota. Continuar?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get profileNotConfigured => 'Perfil do técnico não configurado';

  @override
  String get goToSettings => 'Ir para Configurações';

  @override
  String get technician => 'Técnico';

  @override
  String get language => 'Idioma';

  @override
  String get portuguese => 'Português (BR)';

  @override
  String get english => 'Inglês';

  @override
  String get about => 'Sobre';

  @override
  String get version => 'Versão';

  @override
  String get appDescription =>
      'App de rastreamento GPS para técnicos em campo durante ordens de serviço. 100% offline.';

  @override
  String get save => 'Salvar';

  @override
  String get profileSaved => 'Perfil salvo';

  @override
  String get serviceOrderRequired => 'Número da ordem de serviço é obrigatório';

  @override
  String get nameRequired => 'Nome é obrigatório';

  @override
  String get idRequired => 'ID é obrigatório';

  @override
  String get elapsed => 'Decorrido';

  @override
  String get locationPermissionDenied => 'Permissão de localização negada';

  @override
  String get locationServiceDisabled => 'Serviço de localização desativado';

  @override
  String get enableLocationService =>
      'Por favor, ative os serviços de localização';

  @override
  String get permissionRequired => 'Permissão Necessária';

  @override
  String get backgroundPermissionInfo =>
      'A permissão de localização em segundo plano permite rastrear quando o app está minimizado. Isso é opcional.';

  @override
  String get grant => 'Conceder';

  @override
  String get skip => 'Pular';

  @override
  String get noSessionsYet => 'Nenhuma sessão de rastreamento ainda';

  @override
  String get serviceOrder => 'Ordem de Serviço';

  @override
  String get darkMode => 'Modo Escuro';

  @override
  String get systemDefault => 'Padrão do Sistema';

  @override
  String get meters => 'm';

  @override
  String get kmh => 'km/h';

  @override
  String get sessionSaved => 'Sessão salva com sucesso';

  @override
  String get errorSavingSession => 'Erro ao salvar sessão';
}
