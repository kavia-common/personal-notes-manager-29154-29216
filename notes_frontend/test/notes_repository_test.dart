import 'package:flutter_test/flutter_test.dart';
import 'package:notes_frontend/features/notes/data/note_model.dart';
import 'package:notes_frontend/features/notes/data/notes_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('NotesRepository insert/update/search/delete flow', () async {
    final repo = NotesRepository();

    // Insert two notes
    final now = DateTime.now();
    var a = await repo.insert(Note(
      title: 'First',
      content: 'Hello',
      createdAt: now,
      updatedAt: now,
    ));
    var b = await repo.insert(Note(
      title: 'Second',
      content: 'World',
      isPinned: true,
      createdAt: now,
      updatedAt: now,
    ));

    // Ensure order: pinned first
    var all = await repo.getAll();
    expect(all.first.id, b.id);

    // Update 'a' to be pinned and updated later
    final later = now.add(const Duration(minutes: 1));
    a = a.copyWith(isPinned: true, updatedAt: later);
    await repo.upsert(a);

    all = await repo.getAll();
    expect(all.first.id, a.id);

    // Search
    final search = await repo.getAll(search: 'World');
    expect(search.length, 1);
    expect(search.first.id, b.id);

    // Delete
    await repo.delete(a.id!);
    await repo.delete(b.id!);

    final remaining = await repo.getAll();
    expect(remaining, isEmpty);
  });
}
