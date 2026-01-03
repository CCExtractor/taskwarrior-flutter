import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/models/filters.dart';
import 'package:taskwarrior/app/services/tag_filter.dart';

void main() {
  group('Filters', () {
    late Filters filters;
    late bool pendingFilter;
    late bool waitingFilter;
    late bool deletedFilter;
    late String projectFilter;
    late bool tagUnion;
    late Map<String, TagFilterMetadata> tags;

    setUp(() {
      pendingFilter = false;
      waitingFilter = false;
      deletedFilter = false;
      projectFilter = 'TestProject';
      tagUnion = false;
      tags = {
        'tag1': const TagFilterMetadata(display: 'Tag 1', selected: false),
        'tag2': const TagFilterMetadata(display: 'Tag 2', selected: true),
      };

      filters = Filters(
        pendingFilter: pendingFilter,
        waitingFilter: waitingFilter,
        deletedFilter: deletedFilter,
        togglePendingFilter: () {
          pendingFilter = !pendingFilter;
        },
        toggleWaitingFilter: () {
          waitingFilter = !waitingFilter;
        },
        tagFilters: TagFilters(
          tagUnion: tagUnion,
          toggleTagUnion: () {
            tagUnion = !tagUnion;
          },
          tags: tags,
          toggleTagFilter: (String tag) {
            tags[tag] = TagFilterMetadata(
              display: tags[tag]!.display,
              selected: !tags[tag]!.selected,
            );
          },
        ),
        projects: [],
        projectFilter: projectFilter,
        toggleProjectFilter: (String project) {
          projectFilter = project;
        },
      );
    });

    test('should correctly initialize with given parameters', () {
      expect(filters.pendingFilter, pendingFilter);
      expect(filters.waitingFilter, waitingFilter);
      expect(filters.projectFilter, projectFilter);
      expect(filters.tagFilters.tagUnion, tagUnion);
      expect(filters.tagFilters.tags, tags);
    });

    test('should correctly toggle pending filter', () {
      filters.togglePendingFilter();
      expect(pendingFilter, isTrue);

      filters.togglePendingFilter();
      expect(pendingFilter, isFalse);
    });

    test('should correctly toggle waiting filter', () {
      filters.toggleWaitingFilter();
      expect(waitingFilter, isTrue);

      filters.toggleWaitingFilter();
      expect(waitingFilter, isFalse);
    });

    test('should correctly toggle project filter', () {
      const newProject = 'NewProject';
      filters.toggleProjectFilter(newProject);
      expect(projectFilter, newProject);

      const anotherProject = 'AnotherProject';
      filters.toggleProjectFilter(anotherProject);
      expect(projectFilter, anotherProject);
    });

    test('should correctly toggle tag union', () {
      filters.tagFilters.toggleTagUnion();
      expect(tagUnion, isTrue);

      filters.tagFilters.toggleTagUnion();
      expect(tagUnion, isFalse);
    });

    test('should correctly toggle tag filter', () {
      filters.tagFilters.toggleTagFilter('tag1');
      expect(tags['tag1']!.selected, isTrue);

      filters.tagFilters.toggleTagFilter('tag1');
      expect(tags['tag1']!.selected, isFalse);
    });
  });
}
