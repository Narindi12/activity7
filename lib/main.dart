import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Define a custom color scheme
  final Color primaryColor = Colors.teal;
  final Color secondaryColor = Colors.orangeAccent;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fading Animation App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.teal,
        ).copyWith(
          secondary: Colors.orangeAccent, // Replaces accentColor
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // Define a custom font family if desired
        fontFamily: 'Georgia',
      ),
      home: FadingTextAndImageAnimation(),
    );
  }
}

class FadingTextAndImageAnimation extends StatefulWidget {
  @override
  _FadingTextAndImageAnimationState createState() => _FadingTextAndImageAnimationState();
}

class _FadingTextAndImageAnimationState extends State<FadingTextAndImageAnimation> with SingleTickerProviderStateMixin {
  bool _isTextVisible = true;
  bool _isImageVisible = true;
  bool _showFrame = false;

  // For rotating animation
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    // Initialize the rotation controller
    _rotationController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(); // Repeat the animation indefinitely
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  void toggleTextVisibility() {
    setState(() {
      _isTextVisible = !_isTextVisible;
    });
  }

  void toggleImageVisibility() {
    setState(() {
      _isImageVisible = !_isImageVisible;
    });
  }

  void toggleFrame(bool value) {
    setState(() {
      _showFrame = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Access the current color scheme
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Fading Text & Image Animation',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontSize: 22,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // Center vertically
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Fading Text
            AnimatedOpacity(
              opacity: _isTextVisible ? 1.0 : 0.0,
              duration: Duration(seconds: 2),
              curve: Curves.easeInOut,
              child: const Text(
                'Hello, Flutter!',
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 30),
            // Fading and Rotating Image
            GestureDetector(
              onTap: toggleImageVisibility,
              child: AnimatedOpacity(
                opacity: _isImageVisible ? 1.0 : 0.0,
                duration: Duration(seconds: 2),
                curve: Curves.easeInOut,
                child: RotationTransition(
                  turns: _rotationController,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      border: _showFrame ? Border.all(color: colorScheme.secondary, width: 5) : null,
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: NetworkImage('https://via.placeholder.com/150'), // Replace with any image URL
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Switch to toggle frame
            SwitchListTile(
              title: const Text('Show Frame'),
              value: _showFrame,
              onChanged: toggleFrame,
              secondary: Icon(
                _showFrame ? Icons.check_box : Icons.check_box_outline_blank,
                color: _showFrame ? colorScheme.secondary : Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            // Additional Animation: Fading Image
            AnimatedOpacity(
              opacity: _isImageVisible ? 1.0 : 0.0,
              duration: Duration(seconds: 2),
              curve: Curves.easeInOut,
              child: const Text(
                'Tap the image to fade it in or out!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Toggle Text Visibility
          FloatingActionButton(
            onPressed: toggleTextVisibility,
            child: const Icon(Icons.text_fields),
            tooltip: 'Toggle Text Visibility',
            backgroundColor: colorScheme.primary,
          ),
          SizedBox(width: 15),
          // Toggle Image Visibility
          FloatingActionButton(
            onPressed: toggleImageVisibility,
            child: const Icon(Icons.image),
            tooltip: 'Toggle Image Visibility',
            backgroundColor: colorScheme.secondary,
          ),
        ],
      ),
    );
  }
}
