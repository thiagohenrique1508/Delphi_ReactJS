program ServerReact;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Horse,
  Horse.Jhonson,
  Horse.CORS,
  System.JSON,
  ServerReact.Model.Connection in 'src\Model\ServerReact.Model.Connection.pas',
  ServerReact.Model.Entidades.USER in 'src\Model\Entidades\ServerReact.Model.Entidades.USER.pas',
  ServerReact.Model.DAOGeneric in 'src\Model\ServerReact.Model.DAOGeneric.pas',
  ServerReact.Controller.USER in 'src\Controller\ServerReact.Controller.USER.pas',
  ServerReact.Controller.CATEGORIA in 'src\Controller\ServerReact.Controller.CATEGORIA.pas',
  ServerReact.Model.Entidades.CATEGORIA in 'src\Model\Entidades\ServerReact.Model.Entidades.CATEGORIA.pas',
  ServerReact.Controller.PRODUTO in 'src\Controller\ServerReact.Controller.PRODUTO.pas',
  ServerReact.Model.Entidades.PRODUTO in 'src\Model\Entidades\ServerReact.Model.Entidades.PRODUTO.pas';

var
  App: THorse;

begin
  App := THorse.Create(9000);
  App.Use(Jhonson);
  App.Use(CORS);

  //Controller de Entidades
  ServerReact.Controller.USER.Registry(App);
  ServerReact.Controller.CATEGORIA.Registry(App);
  ServerReact.Controller.PRODUTO.Registry(App);

  App.Start;
end.
