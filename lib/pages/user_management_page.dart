import 'package:flutter/material.dart';
import '../models/user.dart';
import '../widgets/user_form.dart';
import '../widgets/user_filter.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({Key? key}) : super(key: key);

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  List<UserModel> _users = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    // simulate async load (DB/network/parsing) so navigation remains smooth
    await Future.delayed(const Duration(milliseconds: 120));
    final loaded = List.generate(
      6,
      (i) => UserModel(
        id: 'u$i',
        name: 'User $i',
        email: 'user$i@example.com',
        phone: '08123456${100 + i}',
        role: i % 2 == 0 ? 'Admin' : 'Operator',
        status: i % 2 == 0 ? 'Active' : 'Inactive',
        createdAt: DateTime.now().subtract(Duration(days: i * 3)),
      ),
    );
    if (!mounted) return;
    setState(() {
      _users = loaded;
      _loading = false;
    });
  }

  void _openCreate() async {
    final created = await showModalBottomSheet<UserModel>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: const UserForm(),
      ),
    );

    if (created != null) {
      setState(() => _users.insert(0, created));
    }
  }

  void _openFilter() async {
    final applied = await showDialog<bool>(
      context: context,
      builder: (_) => const Dialog(child: UserFilter()),
    );

    // For now we only close the dialog; in real app we'd apply the filter criteria
    if (applied == true) {
      // TODO: filter data
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          backgroundColor: const Color.fromARGB(255, 5, 117, 209),
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 5, 117, 209),
                  Color.fromARGB(255, 3, 95, 170),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.people_alt_outlined,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Manajemen Pengguna',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView.separated(
                itemCount: _users.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  final u = _users[i];
                  return _UserCard(
                    user: u,
                    onDelete: () => setState(() => _users.removeAt(i)),
                  );
                },
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 16.0, bottom: 12.0),
        child: FloatingActionButton(
          onPressed: _openCreate,
          child: const Icon(Icons.add, size: 28),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}

class _UserCard extends StatefulWidget {
  final UserModel user;
  final VoidCallback onDelete;
  const _UserCard({Key? key, required this.user, required this.onDelete})
    : super(key: key);

  @override
  State<_UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<_UserCard> {
  bool open = false;

  @override
  Widget build(BuildContext context) {
    final u = widget.user;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              child: Text(u.name.isNotEmpty ? u.name[0] : '?'),
            ),
            title: Text(u.name),
            subtitle: Text(u.email),
            trailing: IconButton(
              icon: Icon(open ? Icons.expand_less : Icons.expand_more),
              onPressed: () => setState(() => open = !open),
            ),
          ),
          if (open)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('No HP: ${u.phone}'),
                  const SizedBox(height: 6),
                  Text('Role: ${u.role}'),
                  const SizedBox(height: 6),
                  Text('Status: ${u.status}'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          /* edit */
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit'),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: widget.onDelete,
                        icon: const Icon(Icons.delete),
                        label: const Text('Hapus'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
