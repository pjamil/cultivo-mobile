import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/login_page.dart';
import '../features/auth/presentation/register_page.dart';
import '../features/plantas/presentation/plantas_list_page.dart';
import '../features/plantas/presentation/planta_form_page.dart';
import '../features/plantas/presentation/planta_detail_page.dart';
import '../features/cultivos/presentation/cultivos_list_page.dart';
import '../features/cultivos/presentation/cultivo_form_page.dart';
import '../features/cultivos/presentation/cultivo_detail_page.dart';
import '../features/diario/presentation/diario_list_page.dart';
import '../features/diario/presentation/diario_form_page.dart';
import '../features/diario/presentation/diario_detail_page.dart';
import '../features/ambientes/presentation/ambientes_list_page.dart';
import '../features/ambientes/presentation/ambiente_form_page.dart';
import '../features/ambientes/presentation/ambiente_detail_page.dart';
import '../features/variedade/presentation/variedade_list_page.dart';
import '../features/variedade/presentation/variedade_form_page.dart';
import '../features/variedade/presentation/variedade_detail_page.dart';
import '../features/meio_cultivo/presentation/meio_cultivo_list_page.dart';
import '../features/meio_cultivo/presentation/meio_cultivo_form_page.dart';
import '../features/meio_cultivo/presentation/meio_cultivo_detail_page.dart';
import '../features/tarefas/presentation/tarefas_list_page.dart';
import '../features/tarefas/presentation/tarefa_form_page.dart';
import '../features/tarefas/presentation/tarefa_detail_page.dart';
import '../features/tarefas/presentation/calendar_page.dart';
import '../features/insumos/presentation/insumos_list_page.dart';
import '../features/insumos/presentation/insumo_form_page.dart';
import '../features/insumos/presentation/insumo_detail_page.dart';
import '../features/dashboard/presentation/dashboard_page.dart';
import '../features/analytics/presentation/analytics_page.dart';
import '../features/usuario/presentation/meus_dados_page.dart';
import '../features/usuario/presentation/usuario_form_page.dart';
import '../features/settings/presentation/settings_page.dart';
import '../features/settings/presentation/notification_settings_page.dart';
import '../shared/widgets/main_scaffold.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      // Auth routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),

      // Main scaffold with bottom nav + drawer
      ShellRoute(
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          // Bottom Nav routes
          GoRoute(
            path: '/',
            builder: (context, state) => const DashboardPage(),
          ),
          GoRoute(
            path: '/plantas',
            builder: (context, state) => const PlantasListPage(),
          ),
          GoRoute(
            path: '/cultivos',
            builder: (context, state) => const CultivosListPage(),
          ),
          GoRoute(
            path: '/tarefas',
            builder: (context, state) => const TarefasListPage(),
          ),
          GoRoute(
            path: '/configuracoes',
            builder: (context, state) => const SettingsPage(),
          ),

          // Drawer routes (secondary)
          GoRoute(
            path: '/ambientes',
            builder: (context, state) => const AmbientesListPage(),
          ),
          GoRoute(
            path: '/variedades',
            builder: (context, state) => const VariedadeListPage(),
          ),
          GoRoute(
            path: '/meios-cultivo',
            builder: (context, state) => const MeioCultivoListPage(),
          ),
          GoRoute(
            path: '/insumos',
            builder: (context, state) => const InsumosListPage(),
          ),
          GoRoute(
            path: '/analytics',
            builder: (context, state) => const AnalyticsPage(),
          ),
          GoRoute(
            path: '/diario',
            builder: (context, state) => const DiarioListPage(),
          ),
        ],
      ),

      // Detail/Form routes (outside shell)
      GoRoute(
        path: '/plantas/nova',
        builder: (context, state) => const PlantaFormPage(),
      ),
      GoRoute(
        path: '/plantas/:id',
        builder: (context, state) => PlantaDetailPage(
          id: int.parse(state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: '/plantas/:id/editar',
        builder: (context, state) => PlantaFormPage(
          id: int.parse(state.pathParameters['id']!),
        ),
      ),

      GoRoute(
        path: '/cultivos/novo',
        builder: (context, state) => const CultivoFormPage(),
      ),
      GoRoute(
        path: '/cultivos/:id',
        builder: (context, state) => CultivoDetailPage(
          id: int.parse(state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: '/cultivos/:id/editar',
        builder: (context, state) => CultivoFormPage(
          id: int.parse(state.pathParameters['id']!),
        ),
      ),

      GoRoute(
        path: '/diario/novo',
        builder: (context, state) => const DiarioFormPage(),
      ),
      GoRoute(
        path: '/diario/:id',
        builder: (context, state) => DiarioDetailPage(
          id: int.parse(state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: '/diario/:id/editar',
        builder: (context, state) => DiarioFormPage(
          id: int.parse(state.pathParameters['id']!),
        ),
      ),

      GoRoute(
        path: '/ambientes/novo',
        builder: (context, state) => const AmbienteFormPage(),
      ),
      GoRoute(
        path: '/ambientes/:id',
        builder: (context, state) => AmbienteDetailPage(
          id: int.parse(state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: '/ambientes/:id/editar',
        builder: (context, state) => AmbienteFormPage(
          id: int.parse(state.pathParameters['id']!),
        ),
      ),

      GoRoute(
        path: '/variedades/nova',
        builder: (context, state) => const VariedadeFormPage(),
      ),
      GoRoute(
        path: '/variedades/:id',
        builder: (context, state) => VariedadeDetailPage(
          id: int.parse(state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: '/variedades/:id/editar',
        builder: (context, state) => VariedadeFormPage(
          id: int.parse(state.pathParameters['id']!),
        ),
      ),

      GoRoute(
        path: '/meios-cultivo/novo',
        builder: (context, state) => const MeioCultivoFormPage(),
      ),
      GoRoute(
        path: '/meios-cultivo/:id',
        builder: (context, state) => MeioCultivoDetailPage(
          id: int.parse(state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: '/meios-cultivo/:id/editar',
        builder: (context, state) => MeioCultivoFormPage(
          id: int.parse(state.pathParameters['id']!),
        ),
      ),

      GoRoute(
        path: '/tarefas/nova',
        builder: (context, state) => const TarefaFormPage(),
      ),
      GoRoute(
        path: '/tarefas/:id',
        builder: (context, state) => TarefaDetailPage(
          id: int.parse(state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: '/tarefas/:id/editar',
        builder: (context, state) => TarefaFormPage(
          id: int.parse(state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: '/tarefas/calendario',
        builder: (context, state) => const CalendarPage(),
      ),

      GoRoute(
        path: '/insumos/novo',
        builder: (context, state) => const InsumoFormPage(),
      ),
      GoRoute(
        path: '/insumos/:id',
        builder: (context, state) => InsumoDetailPage(
          id: int.parse(state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: '/insumos/:id/editar',
        builder: (context, state) => InsumoFormPage(
          id: int.parse(state.pathParameters['id']!),
        ),
      ),

      GoRoute(
        path: '/meus-dados',
        builder: (context, state) => const MeusDadosPage(),
      ),
      GoRoute(
        path: '/meus-dados/editar',
        builder: (context, state) => const UsuarioFormPage(),
      ),
      GoRoute(
        path: '/configuracoes/notificacoes',
        builder: (context, state) => const NotificationSettingsPage(),
      ),
    ],
  );
});
