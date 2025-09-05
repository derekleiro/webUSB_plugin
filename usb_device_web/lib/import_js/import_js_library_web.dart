import 'dart:async';
import 'package:web/web.dart' as web;

class ImportJsLibraryWeb {
  /// Injects the library by its [url]
  static Future<void> import(String url) {
    return _importJSLibraries([url]);
  }

  static web.HTMLScriptElement _createScriptTag(String library) {
    final web.HTMLScriptElement script = web.HTMLScriptElement();
    script.type = "text/javascript";
    script.charset = "utf-8";
    script.async = true;
    script.src = library;
    return script;
  }

  /// Injects a bunch of libraries in the <head> and returns a
  /// Future that resolves when all load.
  static Future<void> _importJSLibraries(List<String> libraries) {
    final List<Future<void>> loading = <Future<void>>[];
    final head = web.document.head;

    libraries.forEach((String library) {
      if (!isImported(library)) {
        final scriptTag = _createScriptTag(library);
        head!.appendChild(scriptTag);
        loading.add(scriptTag.onLoad.first);
      }
    });

    return Future.wait(loading);
  }

  static bool _isLoaded(web.HTMLHeadElement head, String url) {
    if (url.startsWith("./")) {
      url = url.replaceFirst("./", "");
    }

    final children = head.children; // HTMLCollection
    for (var i = 0; i < children.length; i++) {
      final element = children.item(i);
      if (element is web.HTMLScriptElement && element.src.isNotEmpty) {
        if (element.src.endsWith(url)) {
          return true;
        }
      }
    }
    return false;
  }

  static bool isImported(String url) {
    final head = web.document.head;
    return head != null && _isLoaded(head, url);
  }
}
