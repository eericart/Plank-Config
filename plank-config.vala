using Gtk,Notify;

/*
[CCode (cheader_filename = "config.h,gi18n.h",
        before_include = "gi18n.h",
        cname = "GETTEXT_PACKAGE")]
*/
extern const string GETTEXT_PACKAGE;

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
        Intl.setlocale(LocaleCategory.MESSAGES, "");
        Intl.textdomain(GETTEXT_PACKAGE);
        Intl.bind_textdomain_codeset(GETTEXT_PACKAGE, "utf-8");
        Intl.bindtextdomain(GETTEXT_PACKAGE, "/usr/share/locale");

        Object (application: app, title: _("Plank Configuration"));

        // Set window properties
        this.window_position = WindowPosition.CENTER;
        this.resizable = false;
        this.border_width = 20;


        Gtk.HeaderBar headerBar = new Gtk.HeaderBar ();
        headerBar.set_title (_("Plank Configuration"));
        headerBar.set_show_close_button (true);

        this.set_titlebar(headerBar);

        var about_action = new SimpleAction ("about", null);

        about_action.activate.connect (this.about_cb);
        this.add_action (about_action);
        this.show_all ();

        // Methods
        create_widgets ();
    }

    private void create_widgets () {
        var grid = new Gtk.Grid ();
        grid.column_spacing = 12;
        grid.row_spacing = 12;
        grid.margin = 24;
        grid.column_homogeneous = true;

        //Icons

        var current = PlankSettings.get_default ().icon_size;

        var icon_size = new Gtk.ComboBoxText ();

        icon_size.append ("32", _("Small"));
        icon_size.append ("48", _("Medium"));
        icon_size.append ("64", _("Large"));
        icon_size.append ("128", _("Extra Large"));
        icon_size.append ("custom", _("Custom"));

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
        hide_mode.append ("0", _("Don't hide"));
        hide_mode.append ("1", _("Intelligent hide"));
        hide_mode.append ("2", _("Auto hide"));
        hide_mode.append ("3", _("Hide on maximize"));
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

        var button_install = new Gtk.Button ();
        var img = new Gtk.Image.from_icon_name ("document-open", Gtk.IconSize.BUTTON);
        button_install.image = img;
        button_install.label = (_("Install"));
        button_install.clicked.connect (() => {
          on_open_clicked();
                    });


        var position = new Gtk.ComboBoxText ();
        position.append ("0", _("Left"));
        position.append ("1", _("Right"));
        position.append ("2", _("Top"));
        position.append ("3", _("Bottom"));
        position.active_id = PlankSettings.get_default ().position.to_string ();
        position.changed.connect (() => PlankSettings.get_default ().position = int.parse (position.active_id));
        position.halign = Gtk.Align.START;
        position.width_request = 164;

        var alignment = new Gtk.ComboBoxText ();
        var items_alignment = new Gtk.ComboBoxText ();

        alignment.append ("0", _("Panel"));
        alignment.append ("1", _("Left"));
        alignment.append ("2", _("Right"));
        alignment.append ("3", _("Center"));
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
        items_alignment.append ("1", _("Right"));
        items_alignment.append ("2", _("Left"));
        items_alignment.append ("3", _("Center"));
        items_alignment.active_id = PlankSettings.get_default ().items_alignment.to_string ();
        items_alignment.changed.connect (() => PlankSettings.get_default ().items_alignment = int.parse (items_alignment.active_id));
        items_alignment.halign = Gtk.Align.START;
        items_alignment.width_request = 164;

        grid.attach (new Label (_("Icon Size:")), 0, 0, 2, 1);
        grid.attach (icon_size, 2, 0, 1, 1);
        grid.attach (new Label (_("Custom:")), 0, 1, 2, 1);
        grid.attach (icon_custome_size, 2, 1, 1, 1);
        grid.attach (new Label(_("Hide Mode:")), 0, 2, 2, 1);
        grid.attach (hide_mode, 2, 2, 2, 1);
        grid.attach (new Label(_("Position:")), 0, 4, 2, 1);
        grid.attach (position, 2, 4, 2, 1);
        grid.attach (new Label(_("Alignment:")), 0, 5, 2, 1);
        grid.attach (alignment, 2, 5, 2, 1);
        grid.attach (new Label(_("Panel Alignment:")), 0, 6, 2, 1);
        grid.attach (items_alignment, 2, 6, 1, 1);
        grid.attach (button_install, 3,3,1,1);

         if (theme_index > 1) {
            grid.attach (new Label (_("Theme:")), 0, 3, 2, 1);
            grid.attach (theme, 2, 3, 1, 1);
        }

        this.add (grid);
    }

    void about_cb (SimpleAction simple, Variant? parameter) {
        var about = new Gtk.AboutDialog ();

        string[] authors = { "Ernesto Ricart", null };
        string[] documenters = { "Ernesto Ricart", null };
        string[] contributors = { "Jeff Bai","xiangzhai", null };

        about.set_program_name (_("Plank-Config"));
        about.set_copyright (_("Copyright \xc2\xa9 2014 Ernesto Ricart"));
        about.set_comments(_("This little tool allows anyone to change settings of Plank Dock."));
        about.set_authors(authors);
        about.set_logo_icon_name(_("plank-config"));
        about.set_documenters(documenters);
        about.set_version ("1.3.1");
        about.add_credit_section(_("Contributors"), (string) contributors);
        about.set_license_type(Gtk.License.GPL_2_0);

        about.show_all();
    }

    private void on_open_clicked () {
      var file_chooser = new FileChooserDialog (_("Open File"), this,
                                      FileChooserAction.OPEN,
                                      Stock.CANCEL, ResponseType.CANCEL,
                                      Stock.OPEN, ResponseType.ACCEPT);
        if (file_chooser.run () == ResponseType.ACCEPT) {
          install_theme(file_chooser.get_file());
        }
        file_chooser.destroy ();
    }

    private void install_theme (GLib.File file){
            var regex = /\.(?i:zip)$/;
            var path = file.get_path () ;
            var name = file.get_basename() ;

            if(regex.match (path)){
              var tmp_dir ="/tmp/"+string_random();
              Posix.system("unzip "+path+" -d "+tmp_dir);
              string name_files_dir;
              string theme_n = regex.replace (name,-1,0,"");
              var theme_file = false;
              var d = Dir.open(tmp_dir+"/"+theme_n);
              while ((name_files_dir = d.read_name()) != null) {
                     if (name_files_dir.to_string () == "dock.theme" ){
                      theme_file = true;
                      break;
                      }

              }
              if (theme_file){
                Posix.system("cp -r "+tmp_dir+"/"+theme_n+" "+Environment.get_user_data_dir ()+"/plank/themes");
                send_notification(false,theme_n);
              }
              else{
                send_notification();
              }

            }

            else {
              send_notification();
            }

    }

    private void send_notification (bool error = true, string theme_name = ""){

      var summary = theme_name+(_(" theme installed"));
      var body = (_("Please Restart the app for update themes"));
      var icon = (_("dialog-information"));

      if (error)
      {
        summary = (_("Invalid theme"));
        body ="";
      }
      Notify.init ("org.plankconfig.app");
      try{
      Notify.Notification notification = new Notify.Notification (summary,body,icon);
      notification.show ();
      }  catch(GLib.Error e) {
        print("%s\n", e.message);
   }

  }

    private string string_random(int length = 10, string charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890"){
      string random = "";

      for(int i=0;i<length;i++){
        int random_index = Random.int_range(0,charset.length);
        string ch = charset.get_char(charset.index_of_nth_char(random_index)).to_string();
        random += ch;
      }

      return random;
}


}


class PlankConfig : Gtk.Application {
  public PlankConfig( ) {
    Object( application_id: "org.plankconfig.app",
      flags: ApplicationFlags.FLAGS_NONE );
  }
  public override void activate( ) {
    var win = new PlankConfigWindow (this);
    win.show_all ();
  }
  protected override void startup () {
        base.startup ();

        var menu = new GLib.Menu ();
        menu.append ("About", "win.about");
        menu.append ("Quit", "app.quit");
        this.app_menu = menu;

        var quit_action = new SimpleAction ("quit", null);
        quit_action.activate.connect (this.quit);
        this.add_action (quit_action);
    }
}
public static void main( string[] args ) {
  var app = new PlankConfig( );
            app.run( );
}

