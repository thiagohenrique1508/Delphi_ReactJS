unit ServerReact.Controller.CATEGORIA;

interface

uses
  Horse,
  System.JSON,
  ServerReact.Model.DAOGeneric,
  ServerReact.Model.Entidades.CATEGORIA;

procedure Registry(App: THorse);
procedure Get(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure GetID(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Insert(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Update(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Delete(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure Registry(App: THorse);
begin
  App.Get('/categoria', Get);
  App.Get('/categoria/:id', GetID);
  App.Post('/categoria', Insert);
  App.Put('/categoria/:id', Update);
  App.Delete('/categoria/:id', Delete);
end;

procedure Insert(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  FDAO: iDAOGeneric<TCATEGORIA>;
begin
  FDAO := TDAOGeneric<TCATEGORIA>.New;
  Res.Send<TJSONObject>(FDAO.Insert(Req.Body<TJSONObject>));
end;

procedure GetID(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  FDAO: iDAOGeneric<TCATEGORIA>;
begin
  FDAO := TDAOGeneric<TCATEGORIA>.New;
  Res.Send<TJSONObject>(FDAO.Find(Req.Params.Items['id']));
end;

procedure Get(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  FDAO: iDAOGeneric<TCATEGORIA>;
begin
  FDAO := TDAOGeneric<TCATEGORIA>.New;
  Res.Send<TJsonArray>(FDAO.Find);
end;

procedure Update(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  FDAO: iDAOGeneric<TCATEGORIA>;
begin
  FDAO := TDAOGeneric<TCATEGORIA>.New;
  Res.Send<TJSONObject>(FDAO.Update(Req.Body<TJSONObject>));
end;

procedure Delete(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  FDAO: iDAOGeneric<TCATEGORIA>;
begin
  FDAO := TDAOGeneric<TCATEGORIA>.New;
  Res.Send<TJSONObject>(FDAO.Delete('ID', Req.Params.Items['id']));
end;

end.
