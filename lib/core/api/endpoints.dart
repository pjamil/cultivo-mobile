class Endpoints {
  static const String _baseUrlFromEnv = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://cultivo-dev.pjamil.dev/api',
  );

  static String get baseUrl => _baseUrlFromEnv;

  // Auth
  static const String login = '/v1/auth/login';
  static const String register = '/v1/auth/register';
  static const String refreshToken = '/v1/auth/refresh';
  static const String logout = '/v1/auth/logout';

  // Usuarios
  static const String usuarios = '/v1/usuarios';
  static const String meusDados = '/v1/meus-dados';
  static const String minhaConta = '/v1/minha-conta';

  // Plantas
  static const String plantas = '/v1/plantas';

  // Cultivos
  static const String cultivos = '/v1/cultivos';

  // Diário
  static const String diario = '/v1/diario-cultivo';

  // Ambientes
  static const String ambientes = '/v1/ambientes';

  // Variedades (antes Genética)
  static const String variedades = '/v1/geneticas';

  // Meios de Cultivo
  static const String meiosCultivo = '/v1/meios-cultivos';

  // Tarefas
  static const String tarefas = '/v1/tarefas';

  // Insumos
  static const String insumos = '/v1/insumos';

  // Dados Ambientais
  static const String dadosAmbientais = '/v1/dados-ambientais';

  // Dashboard
  static const String dashboard = '/v1/dashboard';

  // Analytics
  static const String analytics = '/v1/analytics';

  // Fotos
  static const String fotos = '/v1/fotos';
  static const String fotosPresignedUrl = '/v1/fotos/presigned-url';

  // Push Tokens
  static const String pushTokens = '/v1/push-tokens';

  // Registros de Ação
  static const String registrosAcao = '/v1/registros-acao';

  // Helper methods
  static String plantaById(int id) => '$plantas/$id';
  static String cultivoById(int id) => '$cultivos/$id';
  static String cultivoAvancarEstado(int id) => '$cultivos/$id/avancar-estado';
  static String cultivoCancelar(int id) => '$cultivos/$id/cancelar';
  static String cultivoColher(int id) => '$cultivos/$id/colher';
  static String diarioById(int id) => '$diario/$id';
  static String ambienteById(int id) => '$ambientes/$id';
  static String variedadeById(int id) => '$variedades/$id';
  static String meioCultivoById(int id) => '$meiosCultivo/$id';
  static String tarefaById(int id) => '$tarefas/$id';
  static String tarefaRecorrencia(int id) => '$tarefas/$id/recorrencia';
  static String insumoById(int id) => '$insumos/$id';
  static String fotoById(int id) => '$fotos/$id';
  static String fotosByEntity(String entityType, int entityId) =>
      '$fotos?entityType=$entityType&entityId=$entityId';
  static String registroAcaoById(int id) => '$registrosAcao/$id';
}
