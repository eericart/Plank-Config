using Gtk;



public class PlankSettings : Object
{

  static PlankSettings? instance;

  static File configs_path;
  static KeyFile configs;

  public int icon_size {
    get {
      try {
        return configs.get_integer ("PlankDockPreferences", "IconSize");
      } catch (Error e) { warning (e.message); }
      return 0;
    }
    set {
      configs.set_integer ("PlankDockPreferences", "IconSize", value);
      save ();
    }
  }

  public int hide_mode {
    get {
      try {
        return configs.get_integer ("PlankDockPreferences", "HideMode");
      } catch (Error e) { warning (e.message); }
      return 0;
    }
    set {
      configs.set_integer ("PlankDockPreferences", "HideMode", value);
      save ();
    }
  }

  private string _theme;
  public string theme {
    get {
      try {
        _theme = configs.get_value ("PlankDockPreferences", "Theme");
        return _theme;
      } catch (Error e) { warning (e.message); }
      return "";
    }
    set {
      configs.set_string ("PlankDockPreferences", "Theme", value);
      save ();
    }
  }

  public int monitor {
    get {
      try {
        return configs.get_integer ("PlankDockPreferences", "Monitor");
      } catch (Error e) { warning (e.message); }
      return 0;
    }
    set {
      configs.set_integer ("PlankDockPreferences", "Monitor", value);
      save ();
    }
  }

  PlankSettings ()
  {
    configs_path = File.new_for_path (Environment.get_user_config_dir () + "/plank/dock1/settings");
    if (!configs_path.query_exists ())
      error ("Plank config file could not be found!");

    configs = new KeyFile ();
    try {
      configs.load_from_file (configs_path.get_path (),
        KeyFileFlags.KEEP_COMMENTS | KeyFileFlags.KEEP_TRANSLATIONS);
    } catch (Error e) { error (e.message); }


  }

  void save ()
  {
    try {
      FileUtils.set_contents (configs_path.get_path (), configs.to_data ());
    } catch (Error e) { warning (e.message); }
  }

  public static PlankSettings get_default ()
  {
    if (instance == null)
      instance = new PlankSettings ();

    return instance;
  }

}



class PlankConfigWindow : ApplicationWindow {

   internal PlankConfigWindow (PlankConfig app) {
        Object (application: app, title: "Plank Configuration");

        // Set window properties
        this.window_position = WindowPosition.CENTER;
        this.resizable = false;
        this.border_width = 10;

        // Set window icon
        try {
            this.icon = IconTheme.get_default ().load_icon ("gtk-theme-config", 48, 0);
        } catch (Error e) {
            stderr.printf ("Could not load application icon: %s\n", e.message);
        }

        // Methods
        create_widgets ();
    }

    void create_widgets () {
        var grid = new Gtk.Grid ();
        grid.column_spacing = 12;
        grid.row_spacing = 6;
        grid.margin = 24;
        grid.column_homogeneous = true;

        //Icons

        var current = PlankSettings.get_default ().icon_size;

        var icon_size = new Gtk.ComboBoxText ();

        icon_size.append ("32", "Small");
        icon_size.append ("48", "Medium");
        icon_size.append ("64", "Large");
        icon_size.append ("128", "Extra Large");
        icon_size.append ("custom", "Custom");

        var icon_custome_size = new Gtk.SpinButton.with_range (0, 255, 1);
        icon_custome_size.set_sensitive(false);
        icon_custome_size.set_value (current);

        if (current != 32 && current != 48 && current != 64 && current != 128) {
          icon_size.active_id = "custom";
          icon_custome_size.set_sensitive(true);
          icon_custome_size.value_changed.connect(() => PlankSettings.get_default ().icon_size = int.parse( icon_custome_size.value.to_string ()));
          icon_size.halign = Gtk.Align.START;
          icon_size.width_request = 164;
        }

        icon_size.active_id = current.to_string ();
        icon_size.changed.connect (() => {
          PlankSettings.get_default ().icon_size = int.parse (icon_size.active_id);
         if (icon_size.active_id == "custom") icon_custome_size.set_sensitive(true);
         else icon_custome_size.set_sensitive(false);
          });
        icon_size.halign = Gtk.Align.START;
        icon_size.width_request = 164;



        grid.attach (new Label ("Icon Size:"), 0, 0, 2, 1);
        grid.attach (icon_size, 2, 0, 1, 1);
        grid.attach (new Label ("Custom:"), 0, 1, 2, 1);
        grid.attach (icon_custome_size, 2, 1, 1, 1);

        this.add (grid);
    }


}
class PlankConfig : Gtk.Application {
  public PlankConfig( ) {
    Object( application_id: "org.plankconfig.app",
      flags: ApplicationFlags.FLAGS_NONE );
  }
  public override void activate( ) {
    var window = new PlankConfigWindow (this);
    window.show_all ();
  }

}
public static void main( string[] args ) {
  var app = new PlankConfig( );
            app.run( );
}