unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, Vcl.StdCtrls, Data.DB,
  FireDAC.Comp.Client;

type
  TForm1 = class(TForm)
    FDConnection1: TFDConnection;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    procedure GerarController(aTableName : String);
    procedure GerarClassController(aPath, aTableName : String);
    procedure GerarJS(aTableName : String; Fields : TStringList);
    procedure GerarLista(aPath, aTableName : String; Fields : TStringList);
    procedure GerarForm(aPath, aTableName : String; Fields : TStringList);
    
  public
    { Public declarations }
  end;

const
  DataBaseName = 'dbreact.';

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  Tabelas : TStringList;
  I: Integer;
  a: string;
begin
  FDConnection1.Connected := True;
  Tabelas := TStringList.Create;
  try
    FDConnection1.GetTableNames('','','',Tabelas, [osMy]);
    for I := 0 to Pred(Tabelas.Count) do
    begin
      Tabelas[I];
      GerarController(StringReplace(Tabelas[I], DataBaseName, '', [rfReplaceAll]));
    end;
  finally
    FDConnection1.Connected := False;
    Tabelas.Free;
    ShowMessage('Controller Gerado com Sucesso');
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  Tabelas, Fields : TStringList;
  I: Integer;
begin
  FDConnection1.Connected := True;
  Tabelas := TStringList.Create;
  try
    FDConnection1.GetTableNames('', '', '', Tabelas, [osMy]);
    for I := 0 to Pred(Tabelas.Count) do
    begin
      Fields := TStringList.Create;
      try
        FDConnection1.GetFieldNames('', '', Tabelas[I], '', Fields);
        GerarJS(StringReplace(Tabelas[I], DataBaseName, '', [rfReplaceAll]), Fields);
      finally
        Fields.Free;
      end;
    end;
  finally
    FDConnection1.Connected := False;
    Tabelas.Free;
    ShowMessage('Arquivos Gerados com Sucesso');
  end;
end;

procedure TForm1.GerarClassController(aPath, aTableName: String);
var
  ArqController : TStringList;
begin
  ArqController := TStringList.Create;
  try
    ArqController.Add('unit ServerReact.Controller.'+aTableName+';');
    ArqController.Add('');
    ArqController.Add('interface');
    ArqController.Add('');
    ArqController.Add('uses');
    ArqController.Add('Horse,');
    ArqController.Add('System.JSON,');
    ArqController.Add('ServerReact.Model.DAOGeneric,');
    ArqController.Add('ServerReact.Model.Entidades.'+aTableName+';');
    ArqController.Add('');
    ArqController.Add('procedure Registry(App : THorse);');
    ArqController.Add('procedure Get(Req: THorseRequest; Res: THorseResponse; Next: TProc);');
    ArqController.Add('procedure GetID(Req: THorseRequest; Res: THorseResponse; Next: TProc);');
    ArqController.Add('procedure Insert(Req: THorseRequest; Res: THorseResponse; Next: TProc);');
    ArqController.Add('procedure Update(Req: THorseRequest; Res: THorseResponse; Next: TProc);');
    ArqController.Add('procedure Delete(Req: THorseRequest; Res: THorseResponse; Next: TProc);');
    ArqController.Add('');
    ArqController.Add('implementation');
    ArqController.Add('');
    ArqController.Add('procedure Registry(App : THorse);');
    ArqController.Add('begin');
    ArqController.Add('App.Get(''/'+LowerCase(aTableName)+''', Get);');
    ArqController.Add('App.Get(''/'+LowerCase(aTableName)+'/:id'', GetID);');
    ArqController.Add('App.Post(''/'+LowerCase(aTableName)+''', Insert);');
    ArqController.Add('App.Put(''/'+LowerCase(aTableName)+'/:id'', Update);');
    ArqController.Add('App.Delete(''/'+LowerCase(aTableName)+'/:id'', Delete);');
    ArqController.Add('end;');
    ArqController.Add('');
    ArqController.Add('procedure Insert(Req: THorseRequest; Res: THorseResponse; Next: TProc);');
    ArqController.Add('var');
    ArqController.Add('FDAO : iDAOGeneric<T'+aTableName+'>;');
    ArqController.Add('begin');
    ArqController.Add('FDAO := TDAOGeneric<T'+aTableName+'>.New;');
    ArqController.Add('Res.Send<TJSONObject>(FDAO.Insert(Req.Body<TJsonObject>));');
    ArqController.Add('end;');
    ArqController.Add('');
    ArqController.Add('procedure GetID(Req: THorseRequest; Res: THorseResponse; Next: TProc);');
    ArqController.Add('var');
    ArqController.Add('FDAO : iDAOGeneric<T'+aTableName+'>;');
    ArqController.Add('begin');
    ArqController.Add('FDAO := TDAOGeneric<T'+aTableName+'>.New;');
    ArqController.Add('Res.Send<TJsonObject>(FDAO.Find(Req.Params.Items[''id'']));');
    ArqController.Add('end;');
    ArqController.Add('');
    ArqController.Add('procedure Get(Req: THorseRequest; Res: THorseResponse; Next: TProc);');
    ArqController.Add('var');
    ArqController.Add('FDAO : iDAOGeneric<T'+aTableName+'>;');
    ArqController.Add('begin');
    ArqController.Add('FDAO := TDAOGeneric<T'+aTableName+'>.New;');
    ArqController.Add('Res.Send<TJsonArray>(FDAO.Find);');
    ArqController.Add('end;');
    ArqController.Add('');
    ArqController.Add('procedure Update(Req: THorseRequest; Res: THorseResponse; Next: TProc);');
    ArqController.Add('var');
    ArqController.Add('FDAO : iDAOGeneric<T'+aTableName+'>;');
    ArqController.Add('begin');
    ArqController.Add('FDAO := TDAOGeneric<T'+aTableName+'>.New;');
    ArqController.Add('Res.Send<TJsonObject>(FDAO.Update(Req.Body<TJsonObject>));');
    ArqController.Add('end;');
    ArqController.Add('');
    ArqController.Add('procedure Delete(Req: THorseRequest; Res: THorseResponse; Next: TProc);');
    ArqController.Add('var');
    ArqController.Add('FDAO : iDAOGeneric<T'+aTableName+'>;');
    ArqController.Add('begin');
    ArqController.Add('FDAO := TDAOGeneric<T'+aTableName+'>.New;');
    ArqController.Add('Res.Send<TJsonObject>(FDAO.Delete(''ID'', Req.Params.Items[''id'']));');
    ArqController.Add('end;');
    ArqController.Add('');
    ArqController.Add('end.');
  finally
    ArqController.SaveToFile(aPath + '/Controller.' + aTableName + '.pas');
    ArqController.Free;
  end;
end;

procedure TForm1.GerarController(aTableName: String);
var
  Path : String;
begin
  Path := ExtractFilePath(Application.ExeName) + '/src';
  if not DirectoryExists(Path) then
    ForceDirectories(Path);

  Path := Path + '/Controller';
  if not DirectoryExists(Path) then
    ForceDirectories(Path);

  GerarClassController(Path, aTableName);
  
end;

procedure TForm1.GerarForm(aPath, aTableName: String; Fields: TStringList);
var
  ArqJS : TStringList;
  I: Integer;
begin
  ArqJS := TStringList.Create;
  try
    ArqJS.Add('import React, { Component } from ''react'';');
    ArqJS.Add('import api from ''../../services/api'';');
    ArqJS.Add('import { Link, withRouter } from ''react-router-dom'';');
    ArqJS.Add('');
    ArqJS.Add('class '+aTableName+'Form extends Component {');
    ArqJS.Add('');
    ArqJS.Add('state = {');
    ArqJS.Add('data : {');

    for I := 0 to Pred(Fields.Count) do
    begin
      ArqJS.Add(''+Fields[I]+' : '''',');
    end;

    ArqJS.Add('},');
    ArqJS.Add('flags : {');
    ArqJS.Add('new : null');
    ArqJS.Add('}');
    ArqJS.Add('}');
    ArqJS.Add('');
    ArqJS.Add('dataChange(ev) {');
    ArqJS.Add('let name = [ev.target.name];');
    ArqJS.Add('let value = ev.target.value;');
    ArqJS.Add('this.setState(prevState => ({');
    ArqJS.Add('data : { ...prevState.data, [name] : value }');
    ArqJS.Add('}))');
    ArqJS.Add('}');
    ArqJS.Add('');
    ArqJS.Add('async componentDidMount() {');
    ArqJS.Add('const { id } = this.props.match.params;');
    ArqJS.Add('if (typeof id !== "undefined") {');
    ArqJS.Add('await api.get(`/'+aTableName+'/${id}`)');
    ArqJS.Add('.then(res => {');
    ArqJS.Add('this.setState({ data : res.data });');
    ArqJS.Add('this.setState({ flags : { new : false }});');
    ArqJS.Add('})');
    ArqJS.Add('} else {');
    ArqJS.Add('this.setState({ flags : { new : true }});');
    ArqJS.Add('}');
    ArqJS.Add('}');
    ArqJS.Add('');
    ArqJS.Add('handleSubmit = event => {');
    ArqJS.Add('event.preventDefault();');
    ArqJS.Add('if (this.state.flags.new) {');
    ArqJS.Add('api.post(''/'+aTableName+''', this.state.data)');
    ArqJS.Add('.then(res => {');
    ArqJS.Add('this.props.history.push(''/'+aTableName+''');');
    ArqJS.Add('})');
    ArqJS.Add('} else {');
    ArqJS.Add('api.put(`/'+aTableName+'/${this.state.data.ID}`, this.state.data)');
    ArqJS.Add('.then(res => {');
    ArqJS.Add('this.props.history.push(''/'+aTableName+''');');
    ArqJS.Add('})');
    ArqJS.Add('}');
    ArqJS.Add('}');
    ArqJS.Add('');
    ArqJS.Add('render() {');
    ArqJS.Add('return (');
    ArqJS.Add('<div className="col-sm-12">');
    ArqJS.Add('<h1>Editar '+aTableName+'</h1>');
    ArqJS.Add('<form onSubmit={this.handleSubmit}>');

    for I := 0 to Pred(Fields.Count) do
    begin
      ArqJS.Add('<div className="form-group">');
      ArqJS.Add('<label>'+Fields[I]+'</label>');
      ArqJS.Add('<input type="text" name="'+Fields[I]+'" value={this.state.data.'+Fields[I]+'} onChange={this.dataChange.bind(this)} className="form-control" />');
      ArqJS.Add('</div>');
    end;

    ArqJS.Add('<button type="submit" className="btn btn-primary">Submit</button>');
    ArqJS.Add('<Link className=''btn btn-primary'' to={`/'+aTableName+'`}>Back</Link>');
    ArqJS.Add('</form>');
    ArqJS.Add('</div>');
    ArqJS.Add(')');
    ArqJS.Add('}');
    ArqJS.Add('}');
    ArqJS.Add('');
    ArqJS.Add('export default withRouter('+aTableName+'Form);');
    
  finally
    ArqJS.SaveToFile(aPath + '/form.js');
    ArqJS.Free;
  end;
end;

procedure TForm1.GerarJS(aTableName: String; Fields: TStringList);
var
  Path : String;
begin
  Path := ExtractFilePath(Application.ExeName) + '/src';
  if not DirectoryExists(Path) then
    ForceDirectories(Path);

  Path := Path + '/components';
  if not DirectoryExists(Path) then
    ForceDirectories(Path);

  Path := Path + '/' + LowerCase(aTableName);
  if not DirectoryExists(Path) then
    ForceDirectories(Path);

  GerarLista(Path, LowerCase(aTableName), Fields);
  GerarForm(Path, LowerCase(aTableName), Fields);
end;

procedure TForm1.GerarLista(aPath, aTableName: String; Fields: TStringList);
var
  ArqJS : TStringList;
  I: Integer;
begin
  ArqJS := TStringList.Create;
  try
    ArqJS.Add('import React, { Component } from ''react'';');
    ArqJS.Add('import api from ''../../services/api'';');
    ArqJS.Add('import { Link } from ''react-router-dom'';');
    ArqJS.Add('');
    ArqJS.Add('const $ = require(''jquery'');');
    ArqJS.Add('$.dataTable = require(''datatables.net'');');
    ArqJS.Add('');
    ArqJS.Add('export default class '+aTableName+'Table extends Component {');
    ArqJS.Add('');
    ArqJS.Add('state = {');
    ArqJS.Add('_'+aTableName+' : [],');
    ArqJS.Add('}');
    ArqJS.Add('');
    ArqJS.Add('async componentDidMount() {');
    ArqJS.Add('await this.get'+aTableName+'();');
    ArqJS.Add('this.$el = $(this.el);');
    ArqJS.Add('this.$el.DataTable({});');
    ArqJS.Add('}');
    ArqJS.Add('');
    ArqJS.Add('async get'+aTableName+'() {');
    ArqJS.Add('const response = await api.get(''/'+aTableName+''');');
    ArqJS.Add('this.setState({ _'+aTableName+' : response.data });');
    ArqJS.Add('}');
    ArqJS.Add('');
    ArqJS.Add('onDelete(id) {');
    ArqJS.Add('api.delete(`/'+aTableName+'/${id}`)');
    ArqJS.Add('.then(res => {');
    ArqJS.Add('console.log(res);');
    ArqJS.Add('this.get'+aTableName+'();');
    ArqJS.Add('})');
    ArqJS.Add('}');
    ArqJS.Add('');
    ArqJS.Add('render() {');
    ArqJS.Add('return(');
    ArqJS.Add('<div className=''col-sm-12''>');
    ArqJS.Add('<br></br>');
    ArqJS.Add('<h3>Lista de '+aTableName+' ( {this.state._'+aTableName+'.length} )</h3>');
    ArqJS.Add('<br></br>');
    ArqJS.Add('<div className="row">');
    ArqJS.Add('<div className="col-sm-12">');
    ArqJS.Add('<Link to={''/'+aTableName+'/new''} className="btn btn-success">Novo</Link>');
    ArqJS.Add('</div>');
    ArqJS.Add('</div>');
    ArqJS.Add('<br></br>');
    ArqJS.Add('<table className="display" width="100%" ref={el => this.el = el}>');
    ArqJS.Add('<thead>');
    ArqJS.Add('<tr>');

    for I := 0 to Pred(Fields.Count) do
    begin
      ArqJS.Add('<th>'+Fields[I]+'</th>');
    end;
    
    ArqJS.Add('<th scope="col">ACOES</th>');
    ArqJS.Add('</tr>');
    ArqJS.Add('</thead>');
    ArqJS.Add('<tbody>');
    ArqJS.Add('{this.state._'+aTableName+'.map('+aTableName+' => (');
    ArqJS.Add('<tr key={'+aTableName+'.ID}>');

    for I := 0 to Pred(Fields.Count) do
    begin
      ArqJS.Add('<td>{'+aTableName+'.'+Fields[I]+'}</td>');
    end;
  
    ArqJS.Add('<td>');
    ArqJS.Add('<Link to={`/'+aTableName+'/${'+aTableName+'.ID}`}> <i className="fa fa-pencil"></i> </Link>');
    ArqJS.Add('<Link to={''/'+aTableName+'''}  onClick={() => this.onDelete('+aTableName+'.ID)}> <i className="fa fa-trash-o"></i> </Link>');
    ArqJS.Add('</td>');
    ArqJS.Add('</tr>');
    ArqJS.Add('))}');
    ArqJS.Add('</tbody>');
    ArqJS.Add('</table>');
    ArqJS.Add('</div>');
    ArqJS.Add('');
    ArqJS.Add(')');
    ArqJS.Add('}');
    ArqJS.Add('}');
    
  finally
    ArqJS.SaveToFile(aPath + '/list.js');
    ArqJS.Free;
  end;
end;

end.
