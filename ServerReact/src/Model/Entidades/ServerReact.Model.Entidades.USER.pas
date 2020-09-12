unit ServerReact.Model.Entidades.USER;

interface

uses
  SimpleAttributes;

type
  [Tabela('USER')]
  TUSER = class
    private
    FID: Integer;
    FSTATUS: Integer;
    FPASSWORD: String;
    FUSERNAME: String;
    procedure SetID(const Value: Integer);
    procedure SetPASSWORD(const Value: String);
    procedure SetSTATUS(const Value: Integer);
    procedure SetUSERNAME(const Value: String);
    public
      constructor Create;
      destructor Destroy; override;
    published
      [Campo('ID'), Pk]
      property ID : Integer read FID write SetID;
      [Campo('USERNAME')]
      property USERNAME : String read FUSERNAME write SetUSERNAME;
      [Campo('PASSWORD')]
      property PASSWORD : String read FPASSWORD write SetPASSWORD;
      [Campo('STATUS')]
      property STATUS : Integer read FSTATUS write SetSTATUS;
  end;


implementation

{ TUSER }

constructor TUSER.Create;
begin

end;

destructor TUSER.Destroy;
begin

  inherited;
end;

procedure TUSER.SetID(const Value: Integer);
begin
  FID := Value;
end;

procedure TUSER.SetPASSWORD(const Value: String);
begin
  FPASSWORD := Value;
end;

procedure TUSER.SetSTATUS(const Value: Integer);
begin
  FSTATUS := Value;
end;

procedure TUSER.SetUSERNAME(const Value: String);
begin
  FUSERNAME := Value;
end;

end.
