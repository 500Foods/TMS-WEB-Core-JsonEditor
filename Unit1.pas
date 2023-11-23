unit Unit1;

interface

uses
  System.SysUtils,
  System.Classes,
  System.StrUtils,
  System.DateUtils,

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
  WEBLib.ExtCtrls,
  WEBLib.StdCtrls,
  WEBLib.ComCtrls,

  Vcl.Controls,
  Vcl.StdCtrls;

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
    divConfigButtons: TWebHTMLDiv;
    btnLoadConfig: TWebButton;
    btnViewActionLog: TWebButton;
    pageControl: TWebPageControl;
    pageActionLog: TWebTabSheet;
    pageFileHistory: TWebTabSheet;
    tabJSONEDIT: TWebTabSheet;
    divActionLog: TWebHTMLDiv;
    divFileHistory: TWebHTMLDiv;
    divJSONTree: TWebHTMLDiv;
    divJSONButtons: TWebHTMLDiv;
    btnEditJSON: TWebButton;
    btnQuitJSON: TWebButton;
    btnSaveJSON: TWebButton;
    AddConfig: TMiletusOpenDialog;
    OpenJSON: TMiletusOpenDialog;
    ErrorBox: TMiletusErrorBox;
    divJSONEDIT: TWebHTMLDiv;
    pageTextEdit: TWebTabSheet;
    WebButton1: TWebButton;
    WebButton2: TWebButton;
    procedure LogEvent(Details: String);
    procedure LogException(Details: String; EClass: String; EMessage: String; EData: String);
    procedure LoadConfigurationDefaults;
    procedure InitializeJavaScriptLibraries;
    [async] procedure MiletusFormCreate(Sender: TObject);
    procedure tmrStartTimer(Sender: TObject);
    procedure AddConfigButton(ConfigName: String; ConfigIcon: String; ConfigClass: String; ConfigID: String);
    procedure ConfigClick(ConfigID: String; ConfigName: String);
    procedure btnViewActionLogClick(Sender: TObject);
    procedure btnLoadConfigClick(Sender: TObject);
    procedure LoadConfig(AFilename: String);
    procedure AddConfigExecute(Sender: TObject; AFileName: string);
    procedure OpenJSONExecute(Sender: TObject; AFileName: string);
    procedure btnQuitJSONClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    AppEventLog: TMiletusStringList;
    AppEventLogLast: String;
    AppConfig: TJSONObject;
    AllConfigs: TJSONArray;
    AppName: String;

    tabFileHistory: JSValue;
    tabFileHistoryReady: Boolean;

    DataStr: String;
    DataJS: JSValue;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.AddConfigButton(ConfigName, ConfigIcon: String; ConfigClass: String; ConfigID: String);
begin
  {$IFNDEF WIN32} asm {
    var btn = document.createElement('button');
    btn.id = ConfigID;
    btn.classList = 'btn btn-'+ConfigClass;
    btn.innerHTML = '<i class="fa-solid fa-fw Icon '+ConfigIcon+' me-2"></i><span class="Label">'+ConfigName+'</span>';
    btn.addEventListener('click', function(e) {
      if (e.target.tagName == 'BUTTON') {
        pas.Unit1.Form1.ConfigClick(e.target.id, e.target.lastElementChild.innerHTML);
      }
      else if (e.target.parentElement.tagName == 'BUTTON') {
        pas.Unit1.Form1.ConfigClick(e.target.parentElement.id, e.target.parentElement.lastElementChild.innerHTML);
      }
    });
    divConfigs.appendChild(btn);
  } end; {$ENDIF}
end;

procedure TForm1.btnLoadConfigClick(Sender: TObject);
var
  StartPath: String;
begin
  LogEvent('Load Config Clicked');

  // Close Action Log Viewer if open
  if btnViewActionLog.Tag = 1
  then btnViewActionLogClick(nil);

  GetMiletusPath(NP_APPPATH, StartPath);
  AddConfig.Title := 'Open a '+Form1.Caption+' Config File';
  AddConfig.FileName := '';
  AddConfig.DefaultExt := '.config';
  AddConfig.InitialDir := StartPath;
  AddConfig.Execute;
end;

procedure TForm1.btnQuitJSONClick(Sender: TObject);
begin
  divJSONTree.Visible := False;
  divJSONButtons.Visible := False;

  divConfigs.Visible := True;
  divConfigButtons.Visible := True;

  pageControl.TabIndex := 1;
end;

procedure TForm1.btnViewActionLogClick(Sender: TObject);
begin
  if btnViewActionLog.Tag = 0 then
  begin
    LogEvent('Viewing Action Log');
    btnViewActionLog.Caption := '<i class="fa-solid fa-xmark fa-fw me-2 Icon fa-xl"></i><span class="Label">Close Action Log</span>';
    divActionLog.HTML.Text := '<pre>'+AppEventLog.Text+'</pre>';
    pageControl.TabIndex := 0;
    btnViewActionLog.Tag := 1;
  end
  else
  begin
    LogEvent('Closed Action Log');
    btnViewActionLog.Caption := '<i class="fa-solid fa-scroll fa-fw me-2 Icon fa-xl"></i><span class="Label">View Action Log</span>';
    pageControl.TabIndex := 1;
    btnViewActionLog.Tag := 0;
  end;
end;

procedure TForm1.ConfigClick(ConfigID: String; ConfigName: String);
var
  i: Integer;
  StartPath: String;
begin
  LogEvent('Config Clicked: '+ConfigName+' [ '+ConfigID+' ]');

  // Close Action Log Viewer if open
  if btnViewActionLog.Tag = 1
  then btnViewActionLogClick(nil);

  GetMiletusPath(NP_APPPATH, StartPath);
  OpenJSON.Title := 'Open a JSON File: '+ConfigName;
  OpenJSON.FileName := '';
  OpenJSON.DefaultExt := '.json';
  OpenJSON.InitialDir := StartPath;
  OpenJSON.Execute;
end;

procedure TForm1.InitializeJavaScriptLibraries;
begin

  // InteractJS
  {$IFNDEF WIN32} asm {
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
  } end; {$ENDIF}

  // Tabulator Defaults
  {$IFNDEF WIN32} asm {
    Tabulator.defaultOptions.layout = "fitColumns";
    Tabulator.defaultOptions.selectable = 1;
    Tabulator.defaultOptions.columnHeaderSortMulti = true,
    Tabulator.defaultOptions.clipboard = "copy";
    Tabulator.defaultOptions.groupToggleElement = "header",
    Tabulator.defaultOptions.headerSortElement = function(column, dir) {
      switch(dir){
        case "asc":  return "<i class='fa-solid fa-sort-up'>";
                     break;
        case "desc": return "<i class='fa-solid fa-sort-down'>";
                     break;
        default:     return "<i class='fa-solid fa-sort'>";
      }
    },
    Tabulator.defaultOptions.columnDefaults = {
      headerHozAlign: "left",
      hozAlign: "left",
      headerSortStartingDir: "desc",
      headerSortTristate: true
    };
  } end; {$ENDIF}

  // File History
  {$IFNDEF WIN32} asm {
    this.tabFileHistory = new Tabulator("#divFileHistory", {
      index: "ID",
      layout: "fitColumns",
      selectable: 1,
      rowHeight: 28,
      columnDefaults:{
        resizable: false
      },
      columns: [
        { title: "ID", field: "ID", visible: false },
        { title: "Type", field: "Icon", visible: false },
        { title: "Class", field: "Class", visible: false },
        { title: false, field: "Type", hozAlign: "center", formatter: "html", minWidth: 40, width: 40, bottomCalc: "count",
            formatter: function(cell, formatterParams, onRendered) {
              return '<div title="'+cell.getValue()+'" style="margin:-4px;height:28px;padding-top:4px;" class="bg-'+cell.getRow().getCell('Class').getValue()+'"><i class="fa-solid Icon fa-fw '+cell.getRow().getCell('Icon').getValue()+'"></i></div>';
            }
        },
        { title: "Description", field: "Name" },
        { title: "Filename", field: "Filename" },
        { title: "Accessed", field: "Accessed", width: 160 }
      ]
    });
    this.tabFileHistory.on("tableBuilt", function(){
      pas.Unit1.Form1.tabFileHistoryReady = true;
    });
  } end; {$ENDIF}

end;

procedure TForm1.LoadConfig(AFilename: String);
var
  ConfigFile: TMiletusStringList;
  Config: TJSONObject;
begin
  ConfigFile := TMiletusStringList.Create;
  try
    ConfigFile.LoadFromFile(AFilename);
  except on E: Exception do
    begin
      LogException('Load Config Failed', E.ClassName, E.Message, AFilename);
    end;
  end;

  try
    Config := TJSONObject.ParseJSONValue(ConfigFile.Text) as TJSONObject;
    AddConfigButton(
      (Config.GetValue('Name') as TJSONString).Value,
      (Config.GetValue('Icon') as TJSONString).Value,
      (Config.GetValue('Class') as TJSONString).Value,
      'Config'+IntToStr(AllConfigs.Count)
    );
    AllConfigs.Add(Config);
  except on E: Exception do
    begin
      LogException('Parse Config Failed', E.ClassName, E.Message, AFilename);
    end;
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
  then AppConfig.AddPair('Class', 'primary');

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
  ElapsedTime: TDateTime;
begin
  ElapsedTime := Now;
  tabFileHistoryReady := False;

  // Initialize Application Event Log
  AppEventLog := TMiletusStringList.Create;
  LogEvent('Application Initialzing');

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

  // Default Tab
  pageControl.TabIndex := 1;  // File History

  // Put all the JavaScript here just to make FormCreate a little more organized
  LogEvent('- Initializing Third-Party JS Libraries');
  InitializeJavaScriptLibraries;

  // All done here. Leet's continue there.
  LogEvent('Initialization Complete ('+IntToStr(MillisecondsBetween(Now, ElapsedTime))+'ms)');
  LogEvent('');

  tmrStart.Enabled := True;
end;

procedure TForm1.OpenJSONExecute(Sender: TObject; AFileName: string);
var
  JSONObj: TJSONObject;
  JSONArr: TJSONArray;
  JSONFile: TMiletusStringList;

begin
  LogEvent('Loading JSON: '+AFilename);

  JSONFile := TMiletusStringList.Create;
  try
    JSONFile.LoadFromFile(AFileName);
  except on E: Exception do
    begin
      LogException('Load Failed', E.ClassName, E.Message, AFileName);
      ErrorBox.Title := 'Error Loading JSON File';
      ErrorBox.Content := 'An error was encountered trying to access the selected file. ';
      ErrorBox.Execute;
      exit;
    end;
  end;

  LogEvent('Loaded JSON: '+IntToStr(Length(JSONFile.Text))+' bytes');

  // Got anything at all? No? Then we're done here.
  try
    JSONArr := TJSONArray.Create;
    JSONObj := TJSONObject.Create;

    if Copy(Trim(JSONFile.Text),1,1) = '['
    then JSONArr := TJSONObject.ParseJSONValue(JSONFile.Text) as TJSONArray
    else JSONObj := TJSONObject.ParseJSONValue(JSONFile.Text) as TJSONObject;
  except on E: Exception do
    begin
      LogException('Parse Failed', E.ClassName, E.Message, AFileName);
      ErrorBox.Title := 'Error Parsing JSON File';
      ErrorBox.Content := 'An error was encountered trying to parse the JSON in the selected file. '+
                          'It will be loaded into an editor where corrections can be made.';
      ErrorBox.Execute;
    end;
  end;

  if JSONObj.Count > 0 then
  begin
    LogEvent('JSON Object Parsing Successful: '+InttoStr(JSONObj.Count)+' object elements');
    DataStr := JSONObj.ToString;
  end
  else if JSONArr.Count > 0 then
  begin
    if Assigned(JSONArr) then LogEvent('JSON Array Parsing Successful: '+IntToStr(JSONArr.Count)+' array elements');
    DataStr := JSONArr.ToString;
  end
  else
  begin
    DataStr := JSONFile.Text;
  end;

  if DataStr <> '' then
  begin
    // Hid the Config Interface
    divConfigs.Visible := False;
    divConfigButtons.Visible := False;

    // Show the Edit Interface
    divJSONTree.Visible := True;
    divJSONButtons.Visible := True;

    if (JSONObj.Count + JSONArr.Count) = 0
    then pageControl.TabIndex := 2
    else
    begin
      pageControl.TabIndex := 3
    end;
  end;
end;

procedure TForm1.AddConfigExecute(Sender: TObject; AFileName: string);
begin
  LogEvent('- Loading Config: '+AFilename);
  LoadConfig(AFilename);
end;

procedure TForm1.tmrStartTimer(Sender: TObject);
var
  i: Integer;
  s: String;
  Config: TJSONObject;
  Configs: TJSONArray;
  ConfigName: String;
  ConfigFile: TMiletusStringList;
  ConfigFilename: String;
  ElapsedTime: TDateTime;
begin
  if not(tabFileHistoryReady) then exit;

  tmrStart.Enabled := False;
  ElapsedTime := Now;

  LogEvent('');
  LogEvent('Startup');

  AllConfigs := TJSONArray.Create;

  // Let's start by adding buttons for each type of file we want to support.
  // We'll get these from the individual JSON files as well as from our own configuratin.
  i := 0;
  Configs := AppConfig.GetValue('Configs') as TJSONArray;
  LogEvent('- Configs Found: '+IntToStr(Configs.Count - 1));
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
      LoadConfig(ConfigFileName);
    end;

    i := i + 1;
  end;


  // Load Recent File history
  LogEvent('- Loading File History');
  ConfigFile := TMiletusStringList.Create;
  ConfigFile.Text := '';
  i := 0;
  try
    ConfigFile.LoadFromFile('Recent.history');
  except on E: Exception do
    begin
      LogException('Load History Failed', E.ClassName, E.Message, 'Recent.history');
    end;
  end;

  if ConfigFile.Text <> '' then
  begin
    s := ConfigFile.Text;
    asm
      var filehistory = JSON.parse(s);
      this.tabFileHistory.replaceData(filehistory);
      i = this.tabFileHistory.getDataCount();
    end;
  end;
  LogEvent('- File History Records Found: '+IntToStr(i));


  LogEvent('Startup complete ('+IntToStr(MillisecondsBetween(Now, Elapsedtime))+'ms)');
  LogEvent('');
  LogEvent('Ready');
  LogEvent('');

end;

initialization
  RegisterClass(TForm1);

end.