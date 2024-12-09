Here’s the README in Markdown format:

---

# **Mikey State Management**

A lightweight and versatile state management package for Flutter, designed to handle both synchronous and asynchronous state updates efficiently. This package is perfect for managing complex state scenarios in modern Flutter applications while ensuring performance and reliability.

---

## **Features**

- **Synchronous State Updates**: Instantly update and notify listeners of state changes.
- **Asynchronous State Updates**: Handle complex workflows such as API calls with `Future` support.
- **Reset Functionality**: Reset individual states or the entire state back to their default values.
- **Support for Complex Data**: Manage lists, maps, and nested structures effortlessly.
- **Performance Optimized**: Designed to handle frequent and heavy state updates with minimal overhead.

---

## **Included Demo**

A task management app demonstrates the key features of the package:
1. **Synchronous Updates**: Add, edit, and reset tasks dynamically.
2. **Asynchronous Updates**: Simulate fetching tasks from an API and seamlessly update the state.
3. **Complex State Management**: Showcase the handling of nested lists and maps.

---

## **How to Review**

### **1. Explore the Package**
- **Core Files**:
  - `lib/my_state_manager.dart`: The main state management logic.
  - `lib/my_state_provider.dart`: Provider for integrating state management into the Flutter widget tree.
- **Public Interface**:
  - `lib/mikey_state.dart`: Exports core functionalities for easy integration.

### **2. Run the Demo**
Navigate to the `example/` directory and launch the demo app (iOS only for demo scope):
```bash
cd example
flutter run
```

### **3. Review the Test Cases**
- Located in `test/`.
- Run the tests to verify the package's behavior:
  ```bash
  flutter test
  ```

### **4. Analyze Performance**
- Use the **"Get Tasks from API"** feature in the demo app to observe asynchronous state updates.
- Review logs in the console for performance metrics logged by `MyStateManager`.

---

## **How to Use the Package**

### **Add to Your Project**
Import the package:
```dart
import 'package:mikey_state/mikey_state.dart';
```

### **Initialize State**
Create and pass a state manager with default values:
```dart
final stateManager = MyStateManager({
  'counter': 0,
  'tasks': [],
});
```

### **Update State**
#### Synchronous Update:
```dart
stateManager.set<int>('counter', 1);
```

#### Asynchronous Update:
```dart
await stateManager.setAsync<List<Map<String, dynamic>>>(
  'tasks',
  fetchTasksFromAPI(),
);
```

#### Reset State:
```dart
stateManager.reset('counter');
```

---

## **Conclusion**

This package and its accompanying demo showcase a robust and flexible state management solution. The included test cases and real-world scenarios ensure that the package meets performance, usability, and scalability standards.

Feel free to reach out if you have any questions or need additional clarifications!
