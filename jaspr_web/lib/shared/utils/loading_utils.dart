import 'package:universal_web/web.dart' as web;

/// Global helper function to show or hide a full-screen loading overlay.
/// Modifies the browser DOM directly for seamless overlays without local state overhead.
void showLoading(bool show, {String? message}) {
  const overlayId = 'global-loading-overlay';
  final existing = web.document.getElementById(overlayId);

  if (!show) {
    existing?.remove();
    return;
  }

  if (existing != null) {
    final messageEl = existing.querySelector('.loading-overlay-message') as web.HTMLParagraphElement?;
    if (messageEl != null) {
      if (message != null) {
        messageEl.textContent = message;
        messageEl.style.display = 'block';
      } else {
        messageEl.style.display = 'none';
      }
    }
    return;
  }

  // Create overlay container
  final overlay = web.document.createElement('div') as web.HTMLDivElement;
  overlay.id = overlayId;
  overlay.style.position = 'fixed';
  overlay.style.inset = '0';
  overlay.style.zIndex = '99999';
  overlay.style.backgroundColor = 'rgba(15, 23, 42, 0.75)';
  overlay.style.backdropFilter = 'blur(6px)';
  overlay.style.display = 'flex';
  overlay.style.flexDirection = 'column';
  overlay.style.alignItems = 'center';
  overlay.style.justifyContent = 'center';
  overlay.style.gap = '20px';
  overlay.style.transition = 'opacity 0.3s ease';

  // Spinner Wrapper
  final spinnerWrapper = web.document.createElement('div') as web.HTMLDivElement;
  spinnerWrapper.style.position = 'relative';
  spinnerWrapper.style.width = '60px';
  spinnerWrapper.style.height = '60px';

  // Outer Spinner
  final spinnerOuter = web.document.createElement('div') as web.HTMLDivElement;
  spinnerOuter.style.width = '100%';
  spinnerOuter.style.height = '100%';
  spinnerOuter.style.borderRadius = '50%';
  spinnerOuter.style.border = '4px solid rgba(255, 255, 255, 0.1)';
  spinnerOuter.style.borderTopColor = '#6C63FF';
  spinnerOuter.style.animation = 'spin 1s linear infinite';

  // Inner Spinner
  final spinnerInner = web.document.createElement('div') as web.HTMLDivElement;
  spinnerInner.style.position = 'absolute';
  spinnerInner.style.top = '25%';
  spinnerInner.style.left = '25%';
  spinnerInner.style.width = '50%';
  spinnerInner.style.height = '50%';
  spinnerInner.style.borderRadius = '50%';
  spinnerInner.style.border = '3px solid transparent';
  spinnerInner.style.borderBottomColor = '#8B5CF6';
  spinnerInner.style.animation = 'spin-reverse 1.5s linear infinite';

  spinnerWrapper.appendChild(spinnerOuter);
  spinnerWrapper.appendChild(spinnerInner);
  overlay.appendChild(spinnerWrapper);

  // Message element
  final messageEl = web.document.createElement('p') as web.HTMLParagraphElement;
  messageEl.className = 'loading-overlay-message';
  messageEl.style.fontSize = '15px';
  messageEl.style.fontWeight = '600';
  messageEl.style.color = '#FFFFFF';
  messageEl.style.margin = '0';
  messageEl.style.letterSpacing = '0.03em';
  messageEl.style.textShadow = '0 2px 4px rgba(0,0,0,0.2)';
  if (message != null) {
    messageEl.textContent = message;
  } else {
    messageEl.style.display = 'none';
  }

  overlay.appendChild(messageEl);
  web.document.body?.appendChild(overlay);
}
