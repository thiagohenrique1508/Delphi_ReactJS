unit ServerReact.Controller.USER;

interface

uses
  Horse,
  System.JSON,
  ServerReact.Model.DAOGeneric,
  ServerReact.Model.Entidades.USER;

procedure Registry(App : THorse);
procedure Get(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure GetID(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Insert(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Update(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Delete(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure Registry(App : THorse);
begin
  App.Get('/users', Get);
  App.Get('/users/:id', GetID);
  App.Post('/users', Insert);
  App.Put('/users/:id', Update);
  App.Delete('/users/:id', Delete);
end;

procedure Insert(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  FDAO : iDAOGeneric<TUSER>;
begin
  FDAO := TDAOGeneric<TUSER>.New;
  Res.Send<TJSONObject>(FDAO.Insert(Req.Body<TJsonObject>));
end;

procedure GetID(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  FDAO : iDAOGeneric<TUSER>;
begin
  FDAO := TDAOGeneric<TUSER>.New;
  Res.Send<TJsonObject>(FDAO.Find(Req.Params.Items['id']));
end;

procedure Get(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  FDAO : iDAOGeneric<TUSER>;
begin
  FDAO := TDAOGeneric<TUSER>.New;
  Res.Send<TJsonArray>(FDAO.Find);
end;

procedure Update(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  FDAO : iDAOGeneric<TUSER>;
begin
  FDAO := TDAOGeneric<TUSER>.New;
  Res.Send<TJsonObject>(FDAO.Update(Req.Body<TJsonObject>));
end;

procedure Delete(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  FDAO : iDAOGeneric<TUSER>;
begin
  FDAO := TDAOGeneric<TUSER>.New;
  Res.Send<TJsonObject>(FDAO.Delete('ID', Req.Params.Items['id']));
end;

end.
