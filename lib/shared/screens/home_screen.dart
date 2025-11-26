import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con imagen y recorte curvo
          _buildHeroSection(context, isDark, screenWidth),
          
          const SizedBox(height: 24),
          
          // Contenido
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¿Qué es Plan México?',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppTheme.lightText,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Estrategia de Desarrollo Económico Equitativo y Sustentable para la Prosperidad Compartida.',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.6,
                    color: isDark ? Colors.white70 : AppTheme.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Cards de información
                _buildInfoCards(context, isDark),
                
                const SizedBox(height: 24),
                
                // Sección de Polos
                _buildPolosSection(context, isDark),
                
                const SizedBox(height: 100), // Espacio para el bottom nav
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, bool isDark, double screenWidth) {
    return Stack(
      children: [
        // Imagen con recorte curvo
        ClipPath(
          clipper: CurvedImageClipper(),
          child: Container(
            height: 280,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.3),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Imagen de fondo (placeholder con gradiente)
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppTheme.primaryColor.withOpacity(0.8),
                        AppTheme.primaryDark,
                      ],
                    ),
                  ),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1605001011156-cbf0b0f67a51?w=800',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppTheme.primaryColor,
                              AppTheme.primaryDark,
                            ],
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.landscape_rounded,
                            size: 80,
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Overlay oscuro
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.2),
                        Colors.black.withOpacity(0.6),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Contenido sobre la imagen
        Positioned(
          bottom: 50,
          left: 24,
          right: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Plan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withOpacity(0.9),
                  letterSpacing: 1,
                ),
              ),
              const Text(
                'México',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 60,
                height: 3,
                decoration: BoxDecoration(
                  color: AppTheme.accentColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
        
        // Ícono decorativo en la esquina
        Positioned(
          top: MediaQuery.of(context).padding.top + 60,
          right: 20,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.accentColor.withOpacity(0.4),
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.flag_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCards(BuildContext context, bool isDark) {
    return Column(
      children: [
        _buildCard(
          context,
          isDark,
          icon: Icons.rocket_launch_rounded,
          title: 'Misión',
          description: 'Impulsar el desarrollo económico sostenible de México.',
          color: AppTheme.primaryColor,
        ),
        const SizedBox(height: 12),
        _buildCard(
          context,
          isDark,
          icon: Icons.visibility_rounded,
          title: 'Visión',
          description: 'Un México próspero, equitativo y sustentable para todos.',
          color: AppTheme.accentColor,
        ),
      ],
    );
  }

  Widget _buildCard(
    BuildContext context,
    bool isDark, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark 
              ? Colors.white.withOpacity(0.08) 
              : Colors.black.withOpacity(0.06),
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppTheme.lightText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white60 : AppTheme.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16,
            color: isDark ? Colors.white30 : Colors.black26,
          ),
        ],
      ),
    );
  }

  Widget _buildPolosSection(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Polos de Bienestar',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppTheme.lightText,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'Ver todos',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildPoloCard(isDark, 'Norte', Icons.terrain_rounded, '12 proyectos'),
              _buildPoloCard(isDark, 'Centro', Icons.location_city_rounded, '18 proyectos'),
              _buildPoloCard(isDark, 'Sur', Icons.water_rounded, '15 proyectos'),
              _buildPoloCard(isDark, 'Sureste', Icons.forest_rounded, '20 proyectos'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPoloCard(bool isDark, String name, IconData icon, String projects) {
    return Container(
      width: 130,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor,
            AppTheme.primaryDark,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                projects,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Custom Clipper para el recorte curvo de la imagen
class CurvedImageClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    
    // Comenzar desde arriba a la izquierda
    path.lineTo(0, size.height - 60);
    
    // Curva en la parte inferior izquierda
    path.quadraticBezierTo(
      0, size.height,
      60, size.height,
    );
    
    // Línea hasta cerca de la esquina inferior derecha
    path.lineTo(size.width - 100, size.height);
    
    // Curva hacia arriba en la esquina inferior derecha
    path.quadraticBezierTo(
      size.width - 50, size.height,
      size.width - 50, size.height - 50,
    );
    
    // Línea hacia arriba
    path.lineTo(size.width - 50, size.height - 80);
    
    // Curva hacia la derecha
    path.quadraticBezierTo(
      size.width - 50, size.height - 120,
      size.width, size.height - 120,
    );
    
    // Subir al inicio
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
