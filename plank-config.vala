using Gtk;

<<<<<<< HEAD
=======


>>>>>>> origin/master
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

  public int position {
    get {
      try {
        return configs.get_integer ("PlankDockPreferences", "Position");
      } catch (Error e) { warning (e.message); }
      return 0;
    }
    set {
      configs.set_integer ("PlankDockPreferences", "Position", value);
      save ();
    }
  }

  public int alignment {
    get {
      try {
        return configs.get_integer ("PlankDockPreferences", "Alignment");
      } catch (Error e) { warning (e.message); }
      return 0;
    }
    set {
      configs.set_integer ("PlankDockPreferences", "Alignment", value);
      save ();
    }
  }

  public int items_alignment {
    get {
      try {
        return configs.get_integer ("PlankDockPreferences", "ItemsAlignment");
      } catch (Error e) { warning (e.message); }
      return 0;
    }
    set {
      configs.set_integer ("PlankDockPreferences", "ItemsAlignment", value);
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
        this.border_width = 20;

        Gtk.HeaderBar headerBar = new Gtk.HeaderBar ();
        headerBar.set_title ("Plank Configuration");
        headerBar.set_show_close_button (true);

        this.set_titlebar(headerBar);

        // Methods
        create_widgets ();
    }

    void create_widgets () {
        var grid = new Gtk.Grid ();
        grid.column_spacing = 12;
        grid.row_spacing = 12;
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
        }
        else icon_size.active_id = current.to_string ();
        icon_size.changed.connect (() => {
          PlankSettings.get_default ().icon_size = int.parse (icon_size.active_id);
         if (icon_size.active_id == "custom") icon_custome_size.set_sensitive(true);
         else icon_custome_size.set_sensitive(false);
          });
        icon_custome_size.value_changed.connect(() => PlankSettings.get_default ().icon_size = int.parse( icon_custome_size.value.to_string ()));
        icon_size.halign = Gtk.Align.START;
        icon_size.width_request = 164;

        var hide_mode = new Gtk.ComboBoxText ();
        hide_mode.append ("0", "Don't hide");
        hide_mode.append ("1", "Intelligent hide");
        hide_mode.append ("2", "Auto hide");
        hide_mode.append ("3", "Hide on maximize");
        hide_mode.active_id = PlankSettings.get_default ().hide_mode.to_string ();
        hide_mode.changed.connect (() => PlankSettings.get_default ().hide_mode = int.parse (hide_mode.active_id));
        hide_mode.halign = Gtk.Align.START;
        hide_mode.width_request = 164;

        var theme = new Gtk.ComboBoxText ();

        int theme_index = 0;
        try {

            string name;
            var dirs = Environment.get_system_data_dirs ();
            dirs += Environment.get_user_data_dir ();

            foreach (string dir in dirs) {
                if (FileUtils.test (dir + "/plank/themes", FileTest.EXISTS)) {
                    var d = Dir.open(dir + "/plank/themes");
                    while ((name = d.read_name()) != null) {
                        theme.append(theme_index.to_string (), name.to_string());
                        if (PlankSettings.get_default ().theme.to_string () == name)
                            theme.active = theme_index;
                        theme_index++;
                    }
                }
            }
        } catch (GLib.FileError e){
            warning (e.message);
        }

        theme.changed.connect (() => PlankSettings.get_default ().theme = theme.get_active_text ());
        theme.halign = Gtk.Align.START;
        theme.width_request = 164;

        var position = new Gtk.ComboBoxText ();
        position.append ("0", "Left");
        position.append ("1", "Right");
        position.append ("2", "Top");
        position.append ("3", "Buttom");
        position.active_id = PlankSettings.get_default ().position.to_string ();
        position.changed.connect (() => PlankSettings.get_default ().position = int.parse (position.active_id));
        position.halign = Gtk.Align.START;
        position.width_request = 164;

        var alignment = new Gtk.ComboBoxText ();
        var items_alignment = new Gtk.ComboBoxText ();

        alignment.append ("0", "Panel");
        alignment.append ("1", "Left");
        alignment.append ("2", "Right");
        alignment.append ("3", "Center");
        alignment.active_id = PlankSettings.get_default ().alignment.to_string ();
        if (PlankSettings.get_default ().alignment == 0) items_alignment.set_sensitive(true);
        alignment.changed.connect (() =>  {
          PlankSettings.get_default ().alignment = int.parse (alignment.active_id);
          if (int.parse(alignment.active_id) == 0) items_alignment.set_sensitive (true);
          else items_alignment.set_sensitive(false);
        });
        alignment.halign = Gtk.Align.START;
        alignment.width_request = 164;

        if (PlankSettings.get_default ().alignment != 0) items_alignment.set_sensitive(false);
        items_alignment.append ("1", "Right");
        items_alignment.append ("2", "Left");
        items_alignment.append ("3", "Center");
        items_alignment.active_id = PlankSettings.get_default ().items_alignment.to_string ();
        items_alignment.changed.connect (() => PlankSettings.get_default ().items_alignment = int.parse (items_alignment.active_id));
        items_alignment.halign = Gtk.Align.START;
        items_alignment.width_request = 164;

        grid.attach (new Label ("Icon Size:"), 0, 0, 2, 1);
        grid.attach (icon_size, 2, 0, 1, 1);
        grid.attach (new Label ("Custom:"), 0, 1, 2, 1);
        grid.attach (icon_custome_size, 2, 1, 1, 1);
        grid.attach (new Label("Hide Mode:"), 0, 2, 2, 1);
        grid.attach (hide_mode, 2, 2, 2, 1);
        grid.attach (new Label("Position:"), 0, 4, 2, 1);
        grid.attach (position, 2, 4, 2, 1);
        grid.attach (new Label("Alignment:"), 0, 5, 2, 1);
        grid.attach (alignment, 2, 5, 2, 1);
        grid.attach (new Label("Panel Alignment:"), 0, 6, 2, 1);
        grid.attach (items_alignment, 2, 6, 2, 1);

         if (theme_index > 1) {
            grid.attach (new Label ("Theme:"), 0, 3, 2, 1);
            grid.attach (theme, 2, 3, 1, 1);
        }

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
<<<<<<< HEAD
}
=======
}
>>>>>>> origin/master
