unit ServerReact.Controller.PRODUTO;

interface

uses
  Horse,
  System.JSON,
  ServerReact.Model.DAOGeneric,
  ServerReact.Model.Entidades.PRODUTO;

procedure Registry(App: THorse);
procedure Get(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure GetID(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Insert(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Update(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Delete(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure Registry(App: THorse);
begin
  App.Get('/produto', Get);
  App.Get('/produto/:id', GetID);
  App.Post('/produto', Insert);
  App.Put('/produto/:id', Update);
  App.Delete('/produto/:id', Delete);
end;

procedure Insert(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  FDAO: iDAOGeneric<TPRODUTO>;
begin
  FDAO := TDAOGeneric<TPRODUTO>.New;
  Res.Send<TJSONObject>(FDAO.Insert(Req.Body<TJSONObject>));
end;

procedure GetID(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  FDAO: iDAOGeneric<TPRODUTO>;
begin
  FDAO := TDAOGeneric<TPRODUTO>.New;

  FDAO
    .DAO
    .SQL
      .Fields('PRODUTO.ID, PRODUTO.DESCRICAO, PRODUTO.CATEGORIA, PRODUTO.PRECO, CATEGORIA.DESCRICAO AS CATEGORIA_DESCRICAO')
      .Join('INNER JOIN CATEGORIA ON PRODUTO.CATEGORIA = CATEGORIA.ID')
      .Where('PRODUTO.ID = ' + Req.Params.Items['id'])
    .&End
  .Find;

  Res.Send<TJSONObject>(FDAO.DataSetAsJsonObject);
end;

procedure Get(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  FDAO: iDAOGeneric<TPRODUTO>;
begin
  FDAO := TDAOGeneric<TPRODUTO>.New;

  FDAO
    .DAO
    .SQL
      .Fields('PRODUTO.ID, PRODUTO.DESCRICAO, PRODUTO.CATEGORIA, PRODUTO.PRECO, CATEGORIA.DESCRICAO AS CATEGORIA_DESCRICAO')
      .Join('INNER JOIN CATEGORIA ON PRODUTO.CATEGORIA = CATEGORIA.ID')
    .&End
  .Find;

  Res.Send<TJsonArray>(FDAO.DataSetAsJsonArray);
end;

procedure Update(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  FDAO: iDAOGeneric<TPRODUTO>;
begin
  FDAO := TDAOGeneric<TPRODUTO>.New;
  Res.Send<TJSONObject>(FDAO.Update(Req.Body<TJSONObject>));
end;

procedure Delete(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  FDAO: iDAOGeneric<TPRODUTO>;
begin
  FDAO := TDAOGeneric<TPRODUTO>.New;
  Res.Send<TJSONObject>(FDAO.Delete('ID', Req.Params.Items['id']));
end;

end.
