import 'package:jci/fitness_club/models/fitness_story_model.dart';

class ViewedStoryEntry {
  const ViewedStoryEntry({required this.group, required this.story});

  final MemberStoryGroup group;
  final FitnessStoryItem story;
}
