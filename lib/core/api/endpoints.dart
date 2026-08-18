class Endpoints {
  static const String baseUrl = 'https://searches-winds-wiki-prominent.trycloudflare.com';

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';

  // Usuarios
  static const String usuarios = '/usuarios';
  static const String meusDados = '/meus-dados';

  // Plantas
  static const String plantas = '/plantas';

  // Cultivos
  static const String cultivos = '/cultivos';

  // Diário
  static const String diario = '/diario-cultivo';

  // Ambientes
  static const String ambientes = '/ambientes';

  // Variedades (antes Genética)
  static const String variedades = '/geneticas';

  // Meios de Cultivo
  static const String meiosCultivo = '/meios-cultivos';

  // Tarefas
  static const String tarefas = '/tarefas';

  // Insumos
  static const String insumos = '/insumos';

  // Dados Ambientais
  static const String dadosAmbientais = '/dados-ambientais';

  // Dashboard
  static const String dashboard = '/dashboard';

  // Analytics
  static const String analytics = '/analytics';

  // Fotos
  static const String fotos = '/fotos';
  static const String fotosPresignedUrl = '/fotos/presigned-url';

  // Push Tokens
  static const String pushTokens = '/push-tokens';

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
  static String insumoById(int id) => '$insumos/$id';
  static String fotoById(int id) => '$fotos/$id';
  static String fotosByEntity(String entityType, int entityId) =>
      '$fotos?entityType=$entityType&entityId=$entityId';
}
