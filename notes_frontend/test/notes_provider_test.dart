import 'package:flutter_test/flutter_test.dart';
import 'package:notes_frontend/features/notes/data/note_model.dart';
import 'package:notes_frontend/features/notes/data/notes_repository.dart';
import 'package:notes_frontend/features/notes/providers/notes_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('NotesProvider load, add, toggle, delete', () async {
    final repo = NotesRepository();
    final provider = NotesProvider(repo);

    await provider.loadNotes();
    expect(provider.isLoading, false);
    expect(provider.notes, isEmpty);

    final now = DateTime.now();
    await provider.addOrUpdate(Note(
      title: 'A',
      content: 'x',
      createdAt: now,
      updatedAt: now,
    ));
    expect(provider.notes.length, 1);

    final note = provider.notes.first;
    await provider.togglePin(note);
    expect(provider.notes.first.isPinned, true);

    await provider.delete(provider.notes.first.id!);
    expect(provider.notes, isEmpty);
  });

  test('NotesProvider search filters results', () async {
    final repo = NotesRepository();
    final provider = NotesProvider(repo);
    final now = DateTime.now();

    await provider.addOrUpdate(Note(
      title: 'Groceries',
      content: 'Milk',
      createdAt: now,
      updatedAt: now,
    ));
    await provider.addOrUpdate(Note(
      title: 'Work',
      content: 'Meeting',
      createdAt: now,
      updatedAt: now,
    ));

    await provider.search('Gro');
    expect(provider.notes.length, 1);
    expect(provider.notes.first.title, 'Groceries');
  });
}
