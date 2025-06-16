// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show Platform;
import 'package:timezone/timezone.dart' as tz;

// === MODEL ===
class TextItem {
  final String text;
  final int timestamp;
  final int? notificationTime;

  TextItem({
    required this.text,
    required this.timestamp,
    this.notificationTime,
  });

  Map<String, dynamic> toJson() => {
        'text': text,
        'timestamp': timestamp,
        'notificationTime': notificationTime,
      };

  factory TextItem.fromJson(Map<String, dynamic> json) => TextItem(
        text: json['text'],
        timestamp: json['timestamp'],
        notificationTime: json['notificationTime'],
      );
}

// === STATE NOTIFIER ===
class TextListNotifier extends StateNotifier<List<TextItem>> {
  static const String _storageKey = 'text_list';
  static const int _expirationDuration = 48 * 60 * 60 * 1000;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  TextListNotifier(this.flutterLocalNotificationsPlugin) : super([]) {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedData = prefs.getString(_storageKey);
    if (storedData != null) {
      final List<dynamic> jsonData = jsonDecode(storedData);
      final List<TextItem> items =
          jsonData.map((item) => TextItem.fromJson(item)).toList();
      _filterExpiredItems(items);
    }
  }

  void _filterExpiredItems(List<TextItem> items) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final validItems = items
        .where((item) => now - item.timestamp < _expirationDuration)
        .toList();
    state = validItems;
    _saveToPrefs();
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData =
        jsonEncode(state.map((item) => item.toJson()).toList());
    await prefs.setString(_storageKey, encodedData);
  }

  Future<void> addText(String text, int? notificationTime) async {
    if (text.trim().isNotEmpty) {
      final newItem = TextItem(
        text: text.trim(),
        timestamp: DateTime.now().millisecondsSinceEpoch,
        notificationTime: notificationTime,
      );
      state = [...state, newItem];
      _saveToPrefs();
      _filterExpiredItems(state);

      if (notificationTime != null) {
        final notificationId = state.length - 1;
        await _scheduleNotification(notificationId, newItem.text, notificationTime);
      }
    }
  }

  Future<void> _scheduleNotification(
      int id, String text, int notificationTime) async {
    try {
      final scheduledDate = tz.TZDateTime.from(
        DateTime.fromMillisecondsSinceEpoch(notificationTime),
        tz.local,
      );
      if (scheduledDate.isBefore(DateTime.now())) {
        print('Xato: Eslatma vaqti o‘tmishda!');
        return;
      }

      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'todo_channel',
        'Todo Notifications',
        channelDescription: 'Notifications for new todo items',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
        sound: RawResourceAndroidNotificationSound('notification'),
      );

      const NotificationDetails platformDetails =
          NotificationDetails(android: androidDetails);

      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        'Todo Eslatmasi',
        text,
        scheduledDate,
        platformDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (e) {
      print('Notification xatosi: $e');
    }
  }

  Future<void> removeText(int index) async {
    final updatedList = List<TextItem>.from(state);
    await flutterLocalNotificationsPlugin.cancel(index);
    updatedList.removeAt(index);
    state = updatedList;
    _saveToPrefs();
  }

  Future<void> clearList() async {
    for (int i = 0; i < state.length; i++) {
      await flutterLocalNotificationsPlugin.cancel(i);
    }
    state = [];
    _saveToPrefs();
  }
}

// === RIVERPOD PROVIDER ===
final textListProvider =
    StateNotifierProvider<TextListNotifier, List<TextItem>>((ref) {
  final plugin = FlutterLocalNotificationsPlugin();
  return TextListNotifier(plugin);
});

// === UI (HOME PAGE) ===
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late final TextEditingController _controller;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('ic_launcher');
    const InitializationSettings settings =
        InitializationSettings(android: androidSettings);
    await flutterLocalNotificationsPlugin.initialize(settings);

    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
  }

  Future<void> _showNotification(String text) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'todo_channel',
      'Todo Notifications',
      channelDescription: 'Notifications for new todo items',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      sound: RawResourceAndroidNotificationSound('notification'),
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Yangi Todo Qo‘shildi',
      text,
      platformDetails,
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textList = ref.watch(textListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Todo',
          style: TextStyle(
            fontSize: 30,
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep, color: Colors.red),
            onPressed: () {
              ref.read(textListProvider.notifier).clearList();
            },
          ),
        ],
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: ClipOval(
            child: Image.network(
              'https://scontent.ftas5-1.fna.fbcdn.net/...jpg',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Matn kiriting',
                      labelText: 'Matn',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.access_time, color: Colors.blue),
                  onPressed: () => _selectTime(context),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _selectedTime != null
                    ? 'Eslatma vaqti: ${_selectedTime!.format(context)}'
                    : 'Vaqt tanlanmadi',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_controller.text.trim().isNotEmpty &&
                  _selectedTime != null) {
                final now = DateTime.now();
                final selectedDateTime = DateTime(
                  now.year,
                  now.month,
                  now.day,
                  _selectedTime!.hour,
                  _selectedTime!.minute,
                );
                final notificationTime =
                    selectedDateTime.millisecondsSinceEpoch;
                ref
                    .read(textListProvider.notifier)
                    .addText(_controller.text, notificationTime);
                _showNotification(_controller.text);
                _controller.clear();
                setState(() {
                  _selectedTime = null;
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Matn va vaqtni kiriting!')),
                );
              }
            },
            child: const Text('Todo Qo‘shish'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: textList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(textList[index].text),
                  subtitle: textList[index].notificationTime != null
                      ? Text(
                          'Eslatma: ${DateTime.fromMillisecondsSinceEpoch(textList[index].notificationTime!).toString().substring(0, 16)}',
                        )
                      : null,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      ref.read(textListProvider.notifier).removeText(index);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
