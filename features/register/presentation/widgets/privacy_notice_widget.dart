// features/register/presentation/widgets/privacy_notice_widget.dart (NUEVO ARCHIVO)

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyNoticeWidget extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const PrivacyNoticeWidget({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<PrivacyNoticeWidget> createState() => _PrivacyNoticeWidgetState();
}

class _PrivacyNoticeWidgetState extends State<PrivacyNoticeWidget> {
  bool _isExpanded = false;

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      // ignore: avoid_print
      print('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.outline.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Aviso de Privacidad',
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: colors.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: RichText(
                text: TextSpan(
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: colors.onSurfaceVariant),
                  children: [
                    const TextSpan(
                      text:
                      'Bienestar Integral, con domicilio en Carretera Tuxtla Gutiérrez-Portillo Zaragoza Km. 21+500, Colonia Las Brisas, Suchiapa, Chiapas, C.P. 29150, utilizará sus datos personales recabados para conectarle con cocinas comunitarias y voluntarios, facilitar la comunicación, garantizar el funcionamiento de nuestros servicios y mejorar su experiencia. Para mayor información acerca del tratamiento y de los derechos que puede hacer valer, usted puede acceder al aviso de privacidad integral en: ',
                    ),
                    TextSpan(
                      text: 'https://bienestar-integral.bim2.xyz/privacidad',
                      style: TextStyle(
                        color: colors.primary,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => _launchURL(
                            'https://bienestar-integral.bim2.xyz/privacidad'),
                    ),
                  ],
                ),
              ),
            ),
          const Divider(height: 1),
          CheckboxListTile(
            title: Text(
              'He leído y acepto el Aviso de Privacidad',
              style: theme.textTheme.bodyMedium,
            ),
            value: widget.value,
            onChanged: (bool? newValue) {
              if (newValue != null) {
                widget.onChanged(newValue);
              }
            },
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: colors.primary,
          ),
        ],
      ),
    );
  }
}