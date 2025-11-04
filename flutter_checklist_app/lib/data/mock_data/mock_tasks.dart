import '../../domain/entities/task.dart';

/// Provides sample task data for testing and demonstration.
class MockTasks {
  /// Returns a list of daily household chores.
  static List<Task> getDailyChores() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return [
      Task(
        id: 'mock_morning_1',
        name: 'Make the bed',
        description: 'Start the day with a clean bed',
        isCompleted: true,
        createdAt: today.add(const Duration(hours: 6, minutes: 30)),
        updatedAt: today.add(const Duration(hours: 7)),
      ),
      Task(
        id: 'mock_morning_2',
        name: 'Prepare breakfast',
        description: 'Cook healthy breakfast for the family',
        isCompleted: true,
        createdAt: today.add(const Duration(hours: 7)),
        updatedAt: today.add(const Duration(hours: 7, minutes: 45)),
      ),
      Task(
        id: 'mock_morning_3',
        name: 'Take out the trash',
        description: 'Put out trash and recycling bins',
        isCompleted: true,
        createdAt: today.add(const Duration(hours: 8)),
        updatedAt: today.add(const Duration(hours: 8, minutes: 15)),
      ),
      Task(
        id: 'mock_midday_1',
        name: 'Do the laundry',
        description: 'Wash, dry, and fold clothes',
        isCompleted: false,
        createdAt: today.add(const Duration(hours: 10)),
        updatedAt: null,
      ),
      Task(
        id: 'mock_midday_2',
        name: 'Grocery shopping',
        description: 'Buy ingredients for dinner and weekly essentials',
        isCompleted: false,
        createdAt: today.add(const Duration(hours: 11)),
        updatedAt: null,
      ),
      Task(
        id: 'mock_midday_3',
        name: 'Clean the kitchen',
        description: 'Wash dishes, wipe counters, and organize pantry',
        isCompleted: false,
        createdAt: today.add(const Duration(hours: 12)),
        updatedAt: null,
      ),
      Task(
        id: 'mock_afternoon_1',
        name: 'Vacuum the living room',
        description: 'Deep clean carpets and furniture',
        isCompleted: false,
        createdAt: today.add(const Duration(hours: 14)),
        updatedAt: null,
      ),
      Task(
        id: 'mock_afternoon_2',
        name: 'Water the plants',
        description: 'Check and water all indoor and outdoor plants',
        isCompleted: false,
        createdAt: today.add(const Duration(hours: 15)),
        updatedAt: null,
      ),
      Task(
        id: 'mock_afternoon_3',
        name: 'Organize workspace',
        description: 'Clean desk, organize files, and tidy up office area',
        isCompleted: false,
        createdAt: today.add(const Duration(hours: 16)),
        updatedAt: null,
      ),
      Task(
        id: 'mock_evening_1',
        name: 'Prepare dinner',
        description: 'Cook a healthy meal for the family',
        isCompleted: false,
        createdAt: today.add(const Duration(hours: 18)),
        updatedAt: null,
      ),
      Task(
        id: 'mock_evening_2',
        name: 'Clean the bathroom',
        description: 'Scrub shower, sink, and toilet',
        isCompleted: false,
        createdAt: today.add(const Duration(hours: 19)),
        updatedAt: null,
      ),
      Task(
        id: 'mock_evening_3',
        name: 'Pack lunch for tomorrow',
        description: 'Prepare tomorrow\'s lunch to save time',
        isCompleted: false,
        createdAt: today.add(const Duration(hours: 20)),
        updatedAt: null,
      ),
      Task(
        id: 'mock_weekly_1',
        name: 'Pay bills',
        description: 'Review and pay monthly bills and subscriptions',
        isCompleted: false,
        createdAt: today.add(const Duration(hours: 13)),
        updatedAt: null,
      ),
      Task(
        id: 'mock_weekly_2',
        name: 'Plan meals for the week',
        description: 'Create meal plan and grocery list for next week',
        isCompleted: false,
        createdAt: today.add(const Duration(hours: 17)),
        updatedAt: null,
      ),
    ];
  }

  /// Returns a list of weekend-specific chores.
  static List<Task> getWeekendChores() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return [
      Task(
        id: 'mock_weekend_1',
        name: 'Deep clean the house',
        description: 'Complete thorough cleaning of all rooms',
        isCompleted: false,
        createdAt: today.add(const Duration(hours: 9)),
        updatedAt: null,
      ),
      Task(
        id: 'mock_weekend_2',
        name: 'Do yard work',
        description: 'Mow lawn, trim bushes, and garden maintenance',
        isCompleted: false,
        createdAt: today.add(const Duration(hours: 10)),
        updatedAt: null,
      ),
      Task(
        id: 'mock_weekend_3',
        name: 'Organize garage',
        description: 'Sort items, donate unused items, and organize storage',
        isCompleted: false,
        createdAt: today.add(const Duration(hours: 11)),
        updatedAt: null,
      ),
      Task(
        id: 'mock_weekend_4',
        name: 'Meal prep for the week',
        description: 'Prepare healthy meals and snacks for the upcoming week',
        isCompleted: false,
        createdAt: today.add(const Duration(hours: 14)),
        updatedAt: null,
      ),
    ];
  }

  /// Returns all mock tasks (daily + weekend).
  static List<Task> getAllMockTasks() {
    return [
      ...getDailyChores(),
      ...getWeekendChores(),
    ];
  }
}

