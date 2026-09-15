import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../globals.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Center(
        child: Container(
          width: size.width * 0.92,
          height: size.height * 0.82,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFF8F2FF),
                Color(0xFFE8DBFF),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withOpacity(0.18),
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
            ],
            border: Border.all(
              color: Colors.white.withOpacity(0.9),
              width: 2,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Stack(
              children: [
                /// Soft waves
                const _WaveLayer1(),
                const _WaveLayer2(),

                /// Glass blur
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                  child: Container(
                    color: Colors.white.withOpacity(0.15),
                  ),
                ),

                /// Screen content
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: child,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WaveLayer1 extends StatelessWidget {
  const _WaveLayer1();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.deepPurple.withOpacity(0.10),
              Colors.transparent,
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
      ),
    );
  }
}

class _WaveLayer2 extends StatelessWidget {
  const _WaveLayer2();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: -40,
      right: -40,
      child: Container(
        width: 300,
        height: 220,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Colors.deepPurple.withOpacity(0.12),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}

class BackgroundScaffold extends StatelessWidget {
  final Widget body;

  const BackgroundScaffold({super.key, required this.body, Container? bottomNavigationBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white
          // image: DecorationImage(
          //   image: AssetImage('assets/image/appbackground.png'),
          //   fit: BoxFit.cover,
          // ),
        ),
        child: Stack(
          children: [body,
          Positioned(bottom: 0,left: MediaQuery.of(context).size.width * 0.4, child: Center(child: footerTrans()))],
        ),
      ),
    );
  }
}

