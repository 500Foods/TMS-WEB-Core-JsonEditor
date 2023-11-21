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

  Vcl.Controls;

type
  TForm1 = class(TMiletusForm)
    divBackground: TWebHTMLDiv;
    divMain: TWebHTMLDiv;
    divOptions: TWebHTMLDiv;
    divFileTypes: TWebHTMLDiv;
    divWork: TWebHTMLDiv;
    divFileHistory: TWebHTMLDiv;
    procedure LogEvent(Details: String);
    procedure LogException(Details: String; EClass: String; EMessage: String; EData: String);
    procedure LoadConfigurationDefaults;
    procedure InitializeJavaScriptLibraries;
    [async] procedure MiletusFormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    AppEventLog: TMiletusStringList;
    AppEventLogLast: String;
    AppConfiguration: TJSONObject;
    AppName: String;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

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
begin
  // Default AppConfiguration if we couldn't find one to load

  if AppConfiguration.GetValue('App Name') = nil
  then AppConfiguration.AddPair('App Name', 'JSON Editor');

  if AppConfiguration.GetValue('CSS Background') = nil
  then AppConfiguration.AddPair('CSS Background', '');

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
  AppConfigurationName: String;
  AppConfigurationFile: TMiletusStringList;
  AppconfigurationPath: String;
begin

  // Initialize Application Event Log
  AppEventLog := TMiletusStringList.Create;
  LogEvent('Application Initialzing.');

  // Identify the configuration file
  GetMiletusPath(NP_APPPATH, AppConfigurationPath);
  AppConfigurationName := AppConfigurationPath+'\JSONEditor.config';
  AppConfigurationName := 'JSONEditor.config';

  // Override the above if one is passed on the commmand-line
  await(Boolean, TTMSParams.Execute);
  for i := 1 to ParamCount do
  begin
    if Copy(Uppercase(ParamStr(i)),1,7) = 'CONFIG=' then
    begin
      AppConfigurationName := Copy(ParamStr(i),8,Length(ParamStr(i)));
    end;
  end;

  // Load the configuration file
  LogEvent('- Loading Configuration: '+AppConfigurationName);
  AppConfigurationFile := TMiletusStringList.Create;
  try
    AppConfigurationFile.LoadFromFile(AppConfigurationName);
  except on E: Exception do
    begin
      LogException('- Load Configuration Failed', E.ClassName, E.Message, AppConfigurationName);
    end;
  end;

  // Empty handed
  if AppConfigurationFile.Text = '' then
  begin
    LogEvent('- Configuration File Not Found');
    AppConfigurationFile.Text := '{}';
  end;

  // See if we can get some JSON out of the loaded file
  LogEvent('- Parsing Configuration Data');
  try
    AppConfiguration := TJSONObject.ParseJSONValue(AppConfigurationFile.Text) as TJSONObject;
  except on E: Exception do
    begin
      LogException('- Parse Configuration Failed', E.ClassName, E.Message, AppConfigurationName);
    end;
  end;

  // No Configuration?
  if (AppConfiguration = nil) or (AppConfiguration.ToString = '{}') then
  begin
    LogEvent('- Using Configuration Defaults');
    LoadConfigurationDefaults;
  end
  else
  begin
    LogEvent('- Configuration Loaded: '+IntToStr(Length(Appconfiguration.ToString))+' bytes');
    LoadConfigurationDefaults; // Load in anything that might be missing as well
  end;

  // Get the basics out of the way.
  AppName := (Appconfiguration.GetValue('App Name') as TJSONString).Value;
  Form1.Caption := AppName;

  // Background
  divBackground.ElementHandle.style.cssText := window.atob((Appconfiguration.GetValue('CSS Background') as TJSONString).Value);

  InitializeJavaScriptLibraries;

  // All done here. Leet's continue there.
  LogEvent('Initialization Complete.');
  LogEvent('');

end;

initialization
  RegisterClass(TForm1);

end.