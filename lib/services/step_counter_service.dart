import 'dart:async';
import 'package:fitness_app/services/notification_service.dart';
import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StepCounterService {
  static final StepCounterService _instance = StepCounterService._();
  static StepCounterService get instance => _instance;

  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  
  final _stepController = StreamController<int>.broadcast();
  Stream<int> get stepStream => _stepController.stream;

  int _steps = 0;
  int get steps => _steps;
  
  String _status = 'unknown';
  String get status => _status;

  static const String _stepsKey = 'daily_steps';
  static const String _lastResetKey = 'last_reset_date';

  // List of step count listeners
  final List<Function(int)> _stepCountListeners = [];

  StepCounterService._();

  Future<void> init() async {
    await _checkAndResetDaily();
    _initPlatformState();
  }

  // Add a listener for step count updates
  void addStepCountListener(Function(int) listener) {
    _stepCountListeners.add(listener);
  }

  // Remove a listener
  void removeStepCountListener(Function(int) listener) {
    _stepCountListeners.remove(listener);
  }

  // Get current step count
  Future<int> getStepCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_stepsKey) ?? 0;
  }

  Future<void> _checkAndResetDaily() async {
    final prefs = await SharedPreferences.getInstance();
    final lastResetDate = prefs.getString(_lastResetKey) ?? '';
    final today = DateTime.now().toString().split(' ')[0];

    if (lastResetDate != today) {
      await prefs.setInt(_stepsKey, 0);
      await prefs.setString(_lastResetKey, today);
      _steps = 0;
    } else {
      _steps = prefs.getInt(_stepsKey) ?? 0;
    }
    _stepController.add(_steps);
    
    // Notify listeners
    for (var listener in _stepCountListeners) {
      listener(_steps);
    }
  }

  void _initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _stepCountStream = Pedometer.stepCountStream;

    _pedestrianStatusStream.listen(
      _onPedestrianStatusChanged,
      onError: _onPedestrianStatusError,
    );

    _stepCountStream.listen(
      _onStepCount,
      onError: _onStepCountError,
    );
  }

  void _onStepCount(StepCount event) async {
    final prefs = await SharedPreferences.getInstance();
    final lastResetDate = prefs.getString(_lastResetKey) ?? '';
    final today = DateTime.now().toString().split(' ')[0];

    if (lastResetDate != today) {
      _steps = 0;
      await prefs.setInt(_stepsKey, 0);
      await prefs.setString(_lastResetKey, today);
    }

    _steps++;
    await prefs.setInt(_stepsKey, _steps);
    _stepController.add(_steps);
    
    // Notify listeners
    for (var listener in _stepCountListeners) {
      listener(_steps);
    }

    // Check for milestone
    if (_steps % 1000 == 0) {
      // Notify milestone reached
      NotificationService.instance.notifyStepMilestone(_steps);
    }
  }

  void _onPedestrianStatusChanged(PedestrianStatus event) {
    _status = event.status;
  }

  void _onStepCountError(error) {
    print('Step count error: $error');
  }

  void _onPedestrianStatusError(error) {
    print('Pedestrian status error: $error');
  }

  Future<void> dispose() async {
    await _stepController.close();
  }
}

class StepDetailsPage extends StatefulWidget {
  const StepDetailsPage({super.key});

  @override
  State<StepDetailsPage> createState() => _StepDetailsPageState();
}

class _StepDetailsPageState extends State<StepDetailsPage> {
  final StepCounterService _stepService = StepCounterService.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Step Tracking'),
      ),
      body: StreamBuilder<int>(
        stream: _stepService.stepStream,
        builder: (context, snapshot) {
          final steps = snapshot.data ?? 0;
          final progress = (steps / 10000).clamp(0.0, 1.0);
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStepProgressCard(steps, progress),
                const SizedBox(height: 24),
                _buildStatsGrid(steps),
                const SizedBox(height: 24),
                _buildWeeklyChart(),
                const SizedBox(height: 24),
                _buildActivityTimeline(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStepProgressCard(int steps, double progress) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Today's Steps",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 150,
                  width: 150,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 12,
                    backgroundColor: Colors.grey[200],
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      steps.toString(),
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'of 10,000 steps',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(int steps) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildStatCard(
          'Calories Burned',
          '${(steps * 0.04).toStringAsFixed(0)} kcal',
          Icons.local_fire_department,
          Colors.orange,
        ),
        _buildStatCard(
          'Distance',
          '${(steps * 0.0008).toStringAsFixed(2)} km',
          Icons.straighten,
          Colors.green,
        ),
        _buildStatCard(
          'Active Time',
          '${(steps * 0.01).toStringAsFixed(0)} min',
          Icons.timer,
          Colors.blue,
        ),
        _buildStatCard(
          'Goal Progress',
          '${((steps / 10000) * 100).toStringAsFixed(0)}%',
          Icons.flag,
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Weekly Progress',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 12000,
                  barGroups: [
                    _makeBarGroup(0, 8500, 'Mon'),
                    _makeBarGroup(1, 7200, 'Tue'),
                    _makeBarGroup(2, 9800, 'Wed'),
                    _makeBarGroup(3, 6500, 'Thu'),
                    _makeBarGroup(4, 9200, 'Fri'),
                    _makeBarGroup(5, 8800, 'Sat'),
                    _makeBarGroup(6, 7500, 'Sun'),
                  ],
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                          return Text(
                            days[value.toInt()],
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${(value / 1000).toStringAsFixed(0)}k',
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                  ),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _makeBarGroup(int x, double y, String title) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: Colors.blue,
          width: 20,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
      ],
    );
  }

  Widget _buildActivityTimeline() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Today\'s Activity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildTimelineItem('Morning Walk', '2,500 steps', '8:00 AM'),
            _buildTimelineItem('Lunch Break', '1,200 steps', '1:30 PM'),
            _buildTimelineItem('Evening Walk', '3,300 steps', '6:00 PM'),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(String title, String steps, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$steps • $time',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 