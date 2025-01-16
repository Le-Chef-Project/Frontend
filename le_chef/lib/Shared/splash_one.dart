import 'package:flutter/material.dart';
import 'package:le_chef/Shared/splash_two.dart';

class SplashOne extends StatefulWidget {
  const SplashOne({super.key});

  @override
  State<SplashOne> createState() => _SplashOneState();
}

class _SplashOneState extends State<SplashOne> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<Offset> _logoAnimation;
  late AnimationController _avatarController;
  late Animation<double> _avatarAnimation;

  final Color _avatarBackgroundColor = const Color(0xFFF1FAFF);

  @override
  void initState() {
    super.initState();

    // Logo animation
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _logoAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.7, -0.85),
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeInOut,
    ));

    // Avatar expansion animation
    _avatarController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        _logoController.forward();
        _avatarController.forward().then((_) {
          // Navigate to SplashTwo screen after animations complete
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const SplashTwo(),
              transitionDuration: const Duration(milliseconds: 300),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _avatarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double maxRadius = size.width * 1.5;

    // Initialize avatar animation here, where MediaQuery is safe to use
    _avatarAnimation = Tween<double>(
      begin: 80 / maxRadius,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _avatarController,
      curve: Curves.easeInOut,
    ));

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/splash_Photo.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          // Expanding avatar background
          AnimatedBuilder(
            animation: _avatarAnimation,
            builder: (context, child) {
              final validRadius = maxRadius.isNaN || maxRadius <= 0 ? 1.0 : maxRadius;
              return Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(validRadius * (1 - _avatarAnimation.value)),
                  child: Container(
                    width: validRadius * _avatarAnimation.value * 2,
                    height: validRadius * _avatarAnimation.value * 2,
                    color: _avatarBackgroundColor,
                  ),
                ),
              );
            },
          ),
          // Animated logo
          AnimatedBuilder(
            animation: _logoAnimation,
            builder: (context, child) {
              return Positioned(
                left: size.width / 2 - 40 + _logoAnimation.value.dx * (size.width / 2 - 40) - 30,
                top: size.height / 2 - 40 + _logoAnimation.value.dy * (size.height / 2 - 40) - 60,
                child: Hero(
                  tag: 'logoAnimation',
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: Center(
                      child: Image.asset('assets/logo.png'),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}