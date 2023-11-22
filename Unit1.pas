unit Unit1;

interface

uses
  System.SysUtils,
  System.Classes,
  System.StrUtils,

  WEBLib.REST,
  WEBLib.JSON,

  JS,
  Web,
  JSDelphiSystem,

  WEBLib.Graphics,
  WEBLib.Controls,
  WEBLib.Forms,
  WEBLib.Miletus,
  WEBLib.Dialogs,
  WEBLib.WebCtrls,

  Vcl.Controls, WEBLib.ExtCtrls, Vcl.StdCtrls, WEBLib.StdCtrls;

type
  TForm1 = class(TMiletusForm)
    divBackground: TWebHTMLDiv;
    divMain: TWebHTMLDiv;
    divOptions: TWebHTMLDiv;
    divConfigs: TWebHTMLDiv;
    divWork: TWebHTMLDiv;
    divWorkBG: TWebHTMLDiv;
    tmrStart: TWebTimer;
    divOptionsBG: TWebHTMLDiv;
    procedure LogEvent(Details: String);
    procedure LogException(Details: String; EClass: String; EMessage: String; EData: String);
    procedure LoadConfigurationDefaults;
    procedure InitializeJavaScriptLibraries;
    [async] procedure MiletusFormCreate(Sender: TObject);
    procedure tmrStartTimer(Sender: TObject);
    procedure AddConfigButton(ConfigName: String; ConfigIcon: String; ConfigClass: String; ConfigID: String);
    procedure ConfigClick(ConfigID: String);
  private
    { Private declarations }
  public
    { Public declarations }
    AppEventLog: TMiletusStringList;
    AppEventLogLast: String;
    AppConfig: TJSONObject;
    AllConfigs: TJSONArray;
    AppName: String;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.AddConfigButton(ConfigName, ConfigIcon: String; ConfigClass: String; ConfigID: String);
begin
  asm
    var btn = document.createElement('button');
    btn.id = ConfigID;
    btn.classList = 'btn '+ConfigClass;
    btn.innerHTML = '<i class="fa-solid fa-fw Icon '+ConfigIcon+' me-2"></i><span class="Label">'+ConfigName+'</span>';
    btn.addEventListener('click', function(e) {
      pas.Unit1.Form1.ConfigClick(e.target.id);
    });
    divConfigs.appendChild(btn);
  end;
end;

procedure TForm1.ConfigClick(ConfigID: String);
begin
  Showmessage(ConfigID);
end;

procedure TForm1.InitializeJavaScriptLibraries;
begin

  // InteractJS
  asm
     interact('.resize-right')
      .resizable({
        edges: { left: false, right: true, bottom:false, top: false },
        margin: 12, // size of resizing boundary interaction area
        listeners: {
          move (event) {
            var target = event.target
            var x = (parseFloat(target.getAttribute('data-x')) || 0)
            var y = (parseFloat(target.getAttribute('data-y')) || 0)
            target.style.width = event.rect.width + 'px'
            target.style.height = event.rect.height + 'px'
            x += event.deltaRect.left
            y += event.deltaRect.top
            target.style.transform = 'translate(' + x + 'px,' + y + 'px)'
            target.setAttribute('data-x', x)
            target.setAttribute('data-y', y)
          }
        },
        ignoreFrom: '.nointeract'
      })
      .pointerEvents({
        ignoreFrom: '.nointeract'
      });

    function dragMoveListener (event) {
      var target = event.target
      var x = (parseFloat(target.getAttribute('data-x')) || 0 ) + event.dx
      var y = (parseFloat(target.getAttribute('data-y')) || 0 ) + event.dy
      target.style.transform = 'translate(' + x + 'px, ' + y + 'px)'
      target.setAttribute('data-x', x)
      target.setAttribute('data-y', y)
    };
    window.dragMoveListener = dragMoveListener
  end;

end;

procedure TForm1.LoadConfigurationDefaults;
var
  ConfigsArray: TJSONArray;
  ConfigsItem: TJSONObject;
begin
  // Default AppConfig if we couldn't find one to load

  if AppConfig.GetValue('Name') = nil
  then AppConfig.AddPair('Name', 'JSON Editor');

  if AppConfig.GetValue('Icon') = nil
  then AppConfig.AddPair('Icon', 'fa-screwdriver-wrench');

  if AppConfig.GetValue('Class') = nil
  then AppConfig.AddPair('Class', 'btn-primary');

  if AppConfig.GetValue('CSS Background') = nil
  then AppConfig.AddPair('CSS Background', '');

  if AppConfig.GetValue('Configs') = nil then
  begin
    ConfigsItem := TJSONObject.Create;
    ConfigsItem.AddPair('Name', 'JSON Editor');
    ConfigsItem.AddPair('Filename', 'Default');

    ConfigsArray := TJSONArray.Create;
    ConfigsArray.Add(ConfigsItem);

    AppConfig.AddPair('Configs', TJSONObject.ParseJSONValue(ConfigsArray.toString));
  end;

end;

procedure TForm1.LogEvent(Details: String);
begin
  if AppEventLogLast <> Details then
  begin
    console.log(Details);
    AppEventLog.Add(FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now)+'  '+Details);
    AppEventLogLast := Details;
  end;
end;

procedure TForm1.LogException(Details, EClass, EMessage, EData: String);
begin
  LogEvent('[ EXCEPTION ] '+Details);
  LogEvent('[ '+EClass+' ] '+EMessage);
  LogEvent('[ DATA ] '+EData);
end;

procedure TForm1.MiletusFormCreate(Sender: TObject);
var
  i: Integer;
  AppConfigName: String;
  AppConfigFile: TMiletusStringList;
  AppconfigPath: String;
begin

  // Initialize Application Event Log
  AppEventLog := TMiletusStringList.Create;
  LogEvent('Application Initialzing.');

  // Identify the configuration file
  // NOTE: We're assuming it is in the same folder as the EXE
  // But we can use GetMiletusPath if it is stored elsewhere
  GetMiletusPath(NP_APPPATH, AppConfigPath);
  AppConfigName := AppConfigPath+'\JSONEditor.config';
  AppConfigName := 'JSONEditor.config';

  // Override the above if one is passed on the commmand-line
  await(Boolean, TTMSParams.Execute);
  for i := 1 to ParamCount do
  begin
    if Copy(Uppercase(ParamStr(i)),1,7) = 'CONFIG=' then
    begin
      AppConfigName := Copy(ParamStr(i),8,Length(ParamStr(i)));
    end;
  end;

  // Load the configuration file
  LogEvent('- Loading Configuration: '+AppConfigName);
  AppConfigFile := TMiletusStringList.Create;
  try
    AppConfigFile.LoadFromFile(AppConfigName);
  except on E: Exception do
    begin
      LogException('- Load Configuration Failed', E.ClassName, E.Message, AppConfigName);
    end;
  end;

  // Empty handed
  if AppConfigFile.Text = '' then
  begin
    LogEvent('- Configuration File Not Found');
    AppConfigFile.Text := '{}';
  end;

  // See if we can get some JSON out of the loaded file
  LogEvent('- Parsing Configuration Data');
  try
    AppConfig := TJSONObject.ParseJSONValue(AppConfigFile.Text) as TJSONObject;
  except on E: Exception do
    begin
      LogException('- Parse Configuration Failed', E.ClassName, E.Message, AppConfigName);
    end;
  end;

  // No Configuration?
  if (AppConfig = nil) or (AppConfig.ToString = '{}') then
  begin
    LogEvent('- Using Configuration Defaults');
    LoadConfigurationDefaults;
  end
  else
  begin
    LogEvent('- Configuration Loaded: '+IntToStr(Length(AppConfig.ToString))+' bytes');
    LoadConfigurationDefaults; // Load in anything that might be missing as well
  end;

  // Get the basics out of the way.
  AppName := (AppConfig.GetValue('Name') as TJSONString).Value;
  Form1.Caption := AppName;

  // Background
  divBackground.ElementHandle.style.cssText := window.atob((AppConfig.GetValue('CSS Background') as TJSONString).Value);

  // Put all the JavaScript here just to make FormCreate a little more organized
  InitializeJavaScriptLibraries;

  // All done here. Leet's continue there.
  LogEvent('Initialization Complete.');
  LogEvent('');

  tmrStart.Enabled := True;
end;

procedure TForm1.tmrStartTimer(Sender: TObject);
var
  i: Integer;
  Config: TJSONObject;
  Configs: TJSONArray;
  ConfigName: String;
  ConfigFile: TMiletusStringList;
  ConfigFilename: String;
begin

  tmrStart.Enabled := False;
  LogEvent('');
  LogEvent('Startup.');

  AllConfigs := TJSONArray.Create;

  // Let's start by adding buttons for each type of file we want to support.
  // We'll get these from the individual JSON files as well as from our own configuratin.
  i := 0;
  Configs := AppConfig.GetValue('Configs') as TJSONArray;
  LogEvent(' - Configs found: '+IntToStr(Configs.Count - 1));
  while i < Configs.Count do
  begin
    ConfigName := ((Configs[i] as TJSONObject).GetValue('Name') as TJSONString).Value;
    ConfigFilename := ((Configs[i] as TJSONObject).GetValue('Filename') as TJSONString).Value;

    LogEvent('- Loading Config: '+ConfigName);

    // Inlcude the JSON Editor in the list of Configs available (default)
    if (ConfigFilename = 'Default') then
    begin
      AddConfigButton(
        (AppConfig.GetValue('Name') as TJSONString).Value,
        (AppConfig.GetValue('Icon') as TJSONString).Value,
        (AppConfig.GetValue('Class') as TJSONString).Value,
        'Config'+IntToStr(i)
      );
      AllConfigs.Add(AppConfig);
    end

    // Otherwise, iterate through the list add retrieve the JSON for each
    else
    begin
      ConfigFile := TMiletusStringList.Create;
      try
        ConfigFile.LoadFromFile(ConfigFilename);
      except on E: Exception do
        begin
          LogException('Load Config Failed: '+ConfigName, E.ClassName, E.Message, ConfigFilename);
        end;
      end;

      try
        Config := TJSONObject.ParseJSONValue(ConfigFile.Text) as TJSONObject;
        AddConfigButton(
          (Config.GetValue('Name') as TJSONString).Value,
          (Config.GetValue('Icon') as TJSONString).Value,
          (Config.GetValue('Class') as TJSONString).Value,
          'Config'+IntToStr(i)
        );
        AllConfigs.Add(Config);
      except on E: Exception do
        begin
          LogException('Parse Config Failed: '+ConfigName, E.ClassName, E.Message, ConfigFilename);
        end;
      end;


    end;

    i := i + 1;
  end;
  LogEvent('Startup complete.');
  LogEvent('');

end;

initialization
  RegisterClass(TForm1);

end.