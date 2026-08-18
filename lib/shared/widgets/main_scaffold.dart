import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cultivo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.push('/meus-dados'),
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: child,
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.green,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.eco,
                  size: 48,
                  color: Colors.white,
                ),
                SizedBox(height: 8),
                Text(
                  'Cultivo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pop(context);
              context.go('/');
            },
          ),
          ListTile(
            leading: const Icon(Icons.grass),
            title: const Text('Plantas'),
            onTap: () {
              Navigator.pop(context);
              context.go('/plantas');
            },
          ),
          ListTile(
            leading: const Icon(Icons.spa),
            title: const Text('Cultivos'),
            onTap: () {
              Navigator.pop(context);
              context.go('/cultivos');
            },
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('Diário'),
            onTap: () {
              Navigator.pop(context);
              context.go('/diario');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.home_work),
            title: const Text('Ambientes'),
            onTap: () {
              Navigator.pop(context);
              context.go('/ambientes');
            },
          ),
          ListTile(
            leading: const Icon(Icons.local_florist),
            title: const Text('Variedades'),
            onTap: () {
              Navigator.pop(context);
              context.go('/variedades');
            },
          ),
          ListTile(
            leading: const Icon(Icons.water_drop),
            title: const Text('Meios de Cultivo'),
            onTap: () {
              Navigator.pop(context);
              context.go('/meios-cultivo');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.task_alt),
            title: const Text('Tarefas'),
            onTap: () {
              Navigator.pop(context);
              context.go('/tarefas');
            },
          ),
          ListTile(
            leading: const Icon(Icons.inventory),
            title: const Text('Insumos'),
            onTap: () {
              Navigator.pop(context);
              context.go('/insumos');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.analytics),
            title: const Text('Analytics'),
            onTap: () {
              Navigator.pop(context);
              context.go('/analytics');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configurações'),
            onTap: () {
              Navigator.pop(context);
              context.go('/configuracoes');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.path;

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _getCurrentIndex(currentPath),
      onTap: (index) => _onTap(context, index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.grass),
          label: 'Plantas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.spa),
          label: 'Cultivos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.task_alt),
          label: 'Tarefas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Config',
        ),
      ],
    );
  }

  int _getCurrentIndex(String path) {
    if (path == '/') return 0;
    if (path.startsWith('/plantas')) return 1;
    if (path.startsWith('/cultivos')) return 2;
    if (path.startsWith('/tarefas')) return 3;
    if (path.startsWith('/configuracoes')) return 4;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/plantas');
        break;
      case 2:
        context.go('/cultivos');
        break;
      case 3:
        context.go('/tarefas');
        break;
      case 4:
        context.go('/configuracoes');
        break;
    }
  }
}
