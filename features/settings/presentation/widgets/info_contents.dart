import 'package:flutter/material.dart';

class InfoContents {

  // --- 1. POLÍTICA DE PRIVACIDAD ---
  static Widget privacyPolicy(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHighlightBox(
          context,
          icon: Icons.security,
          text: 'AVISO DE PRIVACIDAD\nBienestar Integral es el responsable del uso y protección de sus datos personales.',
        ),
        const SizedBox(height: 24),

        _buildSectionTitle(context, '¿Quiénes somos?'),
        const SizedBox(height: 8),
        Text(
          'Bienestar Integral, con domicilio en Carretera Tuxtla Gutiérrez-Portillo Zaragoza Km. 21+500, Colonia Las Brisas, Suchiapa, Chiapas, C.P. 29150.',
          style: theme.textTheme.bodyMedium,
        ),

        const SizedBox(height: 24),
        _buildSectionTitle(context, '¿Para qué fines utilizaremos sus datos?'),
        const SizedBox(height: 8),
        Text('Finalidades necesarias para el servicio:', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _buildCheckItem(context, 'Conectarle con cocinas comunitarias o voluntarios.'),
        _buildCheckItem(context, 'Facilitar la comunicación para coordinar actividades.'),
        _buildCheckItem(context, 'Garantizar la seguridad y funcionamiento del servicio.'),

        const SizedBox(height: 12),
        Text('Finalidades adicionales:', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _buildCheckItem(context, 'Mejorar y personalizar su experiencia.'),

        const SizedBox(height: 12),
        Text(
          'Si no desea que sus datos se usen para fines adicionales, contáctenos en: bienestarintegral78@gmail.com.',
          style: theme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
        ),

        const SizedBox(height: 24),
        _buildSectionTitle(context, '¿Cómo protegemos sus datos?'),
        const SizedBox(height: 8),
        _buildHighlightBox(
            context,
            icon: Icons.lock_outline,
            text: 'Su información sensible (contacto, credenciales, datos financieros, recetas) es tratada como confidencial y secreta con estrictas medidas de seguridad.'
        ),

        const SizedBox(height: 24),
        _buildSectionTitle(context, '¿Cómo puede eliminar su cuenta?'),
        const SizedBox(height: 8),
        Text('Usted tiene derecho a cancelar sus datos. El proceso es:', style: theme.textTheme.bodyMedium),
        const SizedBox(height: 12),
        _buildCheckItem(context, 'Entre al apartado de "Configuración".', isTick: true),
        _buildCheckItem(context, 'Presione el botón "Eliminar Cuenta".', isTick: true),
        const SizedBox(height: 8),
        Text(
          'Se enviará una solicitud a soporte técnico y se le notificará la baja en los próximos 5 días hábiles.',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  // --- 2. TÉRMINOS Y CONDICIONES ---
  static Widget termsAndConditions(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '¡Bienvenido a Bienestar Integral! Al registrarte, aceptas nuestros términos:',
          style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),

        _buildSectionTitle(context, '1. Tu Cuenta'),
        const SizedBox(height: 8),
        Text(
          'Debes ser mayor de edad. Tu cuenta es personal e intransferible. Eres responsable de tu contraseña y de toda actividad realizada en ella.',
          style: theme.textTheme.bodyMedium,
        ),

        const SizedBox(height: 24),
        _buildSectionTitle(context, '2. Tu Información'),
        const SizedBox(height: 8),
        Text(
          'Te comprometes a proporcionar datos verdaderos y mantenerlos actualizados (habilidades y disponibilidad). Su tratamiento se describe en nuestro Aviso de Privacidad.',
          style: theme.textTheme.bodyMedium,
        ),

        const SizedBox(height: 24),
        _buildSectionTitle(context, '3. Límite de Responsabilidad'),
        const SizedBox(height: 8),
        Text(
          '"Bienestar Integral" es una plataforma tecnológica de organización. No somos responsables por:',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 12),
        _buildCheckItem(context, 'Acciones, disputas o conductas en el mundo real.', icon: Icons.warning_amber_rounded),
        _buildCheckItem(context, 'Calidad, higiene o seguridad de alimentos.', icon: Icons.warning_amber_rounded),
        _buildCheckItem(context, 'Veracidad de datos financieros registrados por Admins.', icon: Icons.warning_amber_rounded),

        const SizedBox(height: 24),
        _buildSectionTitle(context, '4. Protección de Datos'),
        const SizedBox(height: 8),
        Text(
          'El uso y protección de tus datos se rige por nuestro Aviso de Privacidad y la Ley Federal de Protección de Datos Personales en Posesión de los Particulares.',
          style: theme.textTheme.bodyMedium,
        ),

        const SizedBox(height: 24),
        _buildSectionTitle(context, '5. Propiedad Intelectual'),
        const SizedBox(height: 8),
        Text(
          'La plataforma, el código y la marca son propiedad de "Bienestar Integral", protegidos por la Ley Federal del Derecho de Autor.',
          style: theme.textTheme.bodyMedium,
        ),

        const SizedBox(height: 32),
        _buildHighlightBox(
          context,
          icon: Icons.volunteer_activism,
          text: 'Uso Gratuito: El servicio es gratuito como parte de un proyecto de impacto social.',
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  // --- 3. ACERCA DE (CRÉDITOS Y COLABORADORES) ---
  static Widget aboutApp(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        const SizedBox(height: 10),
        // Logo de la app (simulado con icono)
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.groups_3, size: 60, color: theme.colorScheme.primary),
        ),
        const SizedBox(height: 16),
        Text('Bienestar Integral', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        Text('Versión 1.0.0', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey)),

        const SizedBox(height: 32),
        _buildSectionTitle(context, 'Colaboradores del Proyecto'),
        const SizedBox(height: 16),

        // Lista de Colaboradores
        _buildCollaboratorItem(context, 'Didier Antonio Mendoza Figueira'),
        _buildCollaboratorItem(context, 'Beatriz Margarita Hernandez Olivera'),
        _buildCollaboratorItem(context, 'Irving Osvaldo Champo Narcia'),
        _buildCollaboratorItem(context, 'Brandon Gomez Alcazar'),

        const SizedBox(height: 32),
        _buildHighlightBox(
          context,
          icon: Icons.school,
          text: 'Agradecimiento especial a nuestros maestros por su guía, paciencia y conocimientos compartidos para hacer realidad este proyecto.',
        ),

        const SizedBox(height: 40),
        Center(
          child: Text(
            'Hecho en Chiapas', // <--- CAMBIO AQUÍ: Se eliminó el emoji
            style: theme.textTheme.labelMedium?.copyWith(color: Colors.grey),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  // --- 4. AYUDA Y SOPORTE (UP CHIAPAS) ---
  static Widget helpAndSupport(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        const SizedBox(height: 10),
        Icon(Icons.school_outlined, size: 80, color: theme.colorScheme.primary),
        const SizedBox(height: 16),
        Text(
          'Universidad Politécnica de Chiapas',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Innovación y Tecnología',
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey, fontStyle: FontStyle.italic),
        ),
        const SizedBox(height: 32),

        _buildHighlightBox(
          context,
          icon: Icons.location_on,
          text: 'Carretera Tuxtla Gutiérrez - Portillo Zaragoza Km 21+500\nCol. Las Brisas, Suchiapa, Chiapas.',
        ),

        const SizedBox(height: 24),
        _buildSectionTitle(context, 'Contacto y Soporte'),
        const SizedBox(height: 12),
        _buildCheckItem(context, 'Teléfono: (961) 617 1460', icon: Icons.phone),
        _buildCheckItem(context, 'Web: www.upchiapas.edu.mx', icon: Icons.language),
        _buildCheckItem(context, 'Email: bienestarintegral78@gmail.com', icon: Icons.email),

        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Este proyecto fue desarrollado como parte de la formación académica en Ingeniería en Desarrollo de Software.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall,
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  // --- WIDGETS AUXILIARES DE DISEÑO ---

  static Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  static Widget _buildHighlightBox(BuildContext context, {required IconData icon, required String text}) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: theme.colorScheme.primary, width: 4)),
      ),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.onSurfaceVariant, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildCheckItem(BuildContext context, String text, {bool isTick = false, IconData? icon}) {
    final theme = Theme.of(context);
    IconData displayIcon = icon ?? (isTick ? Icons.check : Icons.circle);
    double iconSize = icon != null ? 20 : 8;
    Color iconColor = (icon == Icons.warning_amber_rounded)
        ? theme.colorScheme.secondary
        : theme.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Icon(displayIcon, color: iconColor, size: iconSize),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }

  static Widget _buildCollaboratorItem(BuildContext context, String name) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(Icons.person_outline, color: theme.colorScheme.primary, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}