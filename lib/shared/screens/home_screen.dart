import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isDesktop = screenWidth >= 768;
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Section - Banner principal como la imagen
          _buildHeroBanner(context, isDark, screenWidth, screenHeight, isDesktop),
          
          const SizedBox(height: 32),
          
          // Contenido adicional
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isDesktop ? 40 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cards de información
                _buildInfoCards(context, isDark, isDesktop),
                
                const SizedBox(height: 32),
                
                // Sección de Polos
                _buildPolosSection(context, isDark, isDesktop),
                
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroBanner(BuildContext context, bool isDark, double screenWidth, double screenHeight, bool isDesktop) {
    // ============================================================
    // ALTURA DEL BANNER - Modifica estos valores para cambiar el tamaño
    // ============================================================
    // Porcentaje de la pantalla que ocupará el banner
    final bannerHeight = isDesktop 
        ? screenHeight * 0.20 + 275  // 60% en desktop (MÁS ALTO)
        : screenHeight * 0.30; // 45% en móvil (MÁS ALTO)
    
    // Altura mínima en pixeles para evitar que sea muy pequeño
    final minHeight = isDesktop ? 400.0 : 320.0;  // Mínimos más altos
    final finalHeight = bannerHeight < minHeight ? minHeight : bannerHeight;

    return SizedBox(
      height: finalHeight,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Fondo con gradiente guinda
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    AppTheme.primaryDark,
                    AppTheme.primaryColor,
                    Color(0xFF8B2942),
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),
          
          // Contenido principal - Row con logo y mujeres
          Row(
            children: [
              // Lado izquierdo - Logo y texto
              Expanded(
                flex: isDesktop ? 3 : 4,
                child: Container(
                  padding: EdgeInsets.only(
                    left: isDesktop ? 60 : 24,
                    right: 20,
                    top: 20,
                    bottom: 20,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Logo Plan México desde imagen
                      Image.asset(
                        'assets/images/logo_plan_mexico.png',
                        height: isDesktop ? 140 : 100,
                        fit: BoxFit.contain,
                        alignment: Alignment.centerLeft,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildFallbackLogo(isDesktop);
                        },
                      ),
                      
                      SizedBox(height: isDesktop ? 20 : 14),
                      
                      // Subtítulo
                      Text(
                        'Estrategia de Desarrollo Económico\nEquitativo y Sustentable para la\nProsperidad Compartida',
                        style: TextStyle(
                          fontSize: isDesktop ? 18 : 13,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withValues(alpha: 0.9),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Lado derecho - Imagen de mujeres
              Expanded(
                flex: isDesktop ? 5 : 4,
                child: ClipRect(
                  child: Image.asset(
                    'assets/images/mujeres.png',
                    fit: BoxFit.cover,
                    height: finalHeight,
                    alignment: Alignment.centerLeft,
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox();
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackLogo(bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 16 : 12,
            vertical: isDesktop ? 8 : 6,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Plan',
                style: TextStyle(
                  fontSize: isDesktop ? 28 : 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryDark,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.auto_awesome,
                size: isDesktop ? 28 : 20,
                color: AppTheme.primaryDark,
              ),
            ],
          ),
        ),
        SizedBox(height: isDesktop ? 4 : 2),
        Text(
          'México',
          style: TextStyle(
            fontSize: isDesktop ? 56 : 40,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCards(BuildContext context, bool isDark, bool isDesktop) {
    if (isDesktop) {
      return Row(
        children: [
          Expanded(
            child: _buildCard(
              context,
              isDark,
              icon: Icons.rocket_launch_rounded,
              title: 'Misión',
              description: 'Impulsar el desarrollo económico sostenible de México mediante la creación de Polos de Bienestar.',
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: _buildCard(
              context,
              isDark,
              icon: Icons.visibility_rounded,
              title: 'Visión',
              description: 'Un México próspero, equitativo y sustentable para todas y todos los mexicanos.',
              color: AppTheme.accentColor,
            ),
          ),
        ],
      );
    }
    
    return Column(
      children: [
        _buildCard(
          context,
          isDark,
          icon: Icons.rocket_launch_rounded,
          title: 'Misión',
          description: 'Impulsar el desarrollo económico sostenible de México mediante la creación de Polos de Bienestar.',
          color: AppTheme.primaryColor,
        ),
        const SizedBox(height: 12),
        _buildCard(
          context,
          isDark,
          icon: Icons.visibility_rounded,
          title: 'Visión',
          description: 'Un México próspero, equitativo y sustentable para todas y todos los mexicanos.',
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark 
              ? Colors.white.withValues(alpha: 0.08) 
              : Colors.black.withValues(alpha: 0.06),
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppTheme.lightText,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: isDark ? Colors.white70 : AppTheme.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPolosSection(BuildContext context, bool isDark, bool isDesktop) {
    final polos = [
      {'name': 'Polo Norte', 'icon': Icons.ac_unit_rounded, 'states': 'Sonora, Chihuahua, Coahuila'},
      {'name': 'Polo Centro', 'icon': Icons.location_city_rounded, 'states': 'CDMX, Estado de México'},
      {'name': 'Polo Sur', 'icon': Icons.wb_sunny_rounded, 'states': 'Oaxaca, Chiapas, Yucatán'},
      {'name': 'Polo Pacífico', 'icon': Icons.waves_rounded, 'states': 'Jalisco, Nayarit, Sinaloa'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.hub_rounded,
                color: AppTheme.primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Polos de Bienestar',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppTheme.lightText,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        SizedBox(
          height: 160,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: polos.length,
            separatorBuilder: (context, index) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final polo = polos[index];
              return _buildPoloCard(
                context,
                isDark,
                name: polo['name'] as String,
                icon: polo['icon'] as IconData,
                states: polo['states'] as String,
                index: index,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPoloCard(
    BuildContext context,
    bool isDark, {
    required String name,
    required IconData icon,
    required String states,
    required int index,
  }) {
    final colors = [
      AppTheme.primaryColor,
      AppTheme.accentColor,
      const Color(0xFF2E7D32),
      const Color(0xFF1565C0),
    ];
    final color = colors[index % colors.length];

    return Container(
      width: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color,
            color.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 26,
            ),
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
              const SizedBox(height: 4),
              Text(
                states,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
