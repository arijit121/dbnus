//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <audioplayers_linux/audioplayers_linux_plugin.h>
#include <file_selector_linux/file_selector_plugin.h>
#include <flutter_udid/flutter_udid_plugin.h>
#include <flutter_volume_controller/flutter_volume_controller_plugin.h>
#include <gtk/gtk_plugin.h>
#include <open_file_linux/open_file_linux_plugin.h>
#include <url_launcher_linux/url_launcher_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) audioplayers_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "AudioplayersLinuxPlugin");
  audioplayers_linux_plugin_register_with_registrar(audioplayers_linux_registrar);
  g_autoptr(FlPluginRegistrar) file_selector_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "FileSelectorPlugin");
  file_selector_plugin_register_with_registrar(file_selector_linux_registrar);
  g_autoptr(FlPluginRegistrar) flutter_udid_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "FlutterUdidPlugin");
  flutter_udid_plugin_register_with_registrar(flutter_udid_registrar);
  g_autoptr(FlPluginRegistrar) flutter_volume_controller_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "FlutterVolumeControllerPlugin");
  flutter_volume_controller_plugin_register_with_registrar(flutter_volume_controller_registrar);
  g_autoptr(FlPluginRegistrar) gtk_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "GtkPlugin");
  gtk_plugin_register_with_registrar(gtk_registrar);
  g_autoptr(FlPluginRegistrar) open_file_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "OpenFileLinuxPlugin");
  open_file_linux_plugin_register_with_registrar(open_file_linux_registrar);
  g_autoptr(FlPluginRegistrar) url_launcher_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "UrlLauncherPlugin");
  url_launcher_plugin_register_with_registrar(url_launcher_linux_registrar);
}
