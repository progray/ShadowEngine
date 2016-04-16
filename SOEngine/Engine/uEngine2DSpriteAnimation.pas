unit uEngine2DSpriteAnimation;

interface

uses
  FMX.Dialogs, FMX.Graphics, Sysutils,
  uNamedList, uEngine2DClasses, uEngine2DAnimation, uEngine2DSprite, uEngine2DObject;

type
  tSpriteAnimation = class(TAnimation)
  strict private
    FFrames: TNamedList<TSpriteFrame>; // ������ ������ ��������
  public
    property Frames: TNamedList<TSpriteFrame> read FFrames write FFrames; // ������ �� ������� �� ��������� ��������
    function Animate: Byte; override;
    procedure AddFrames(newFrames: tIntArray); // ��������� � ������� ������� ������ ����� �������, ���� �� �����, ������� false
    procedure Setup; override;
    constructor Create; override;
    destructor Destroy; override;
  end;

implementation

procedure tSpriteAnimation.addFrames(newFrames: tIntArray);
begin

end;

function tSpriteAnimation.Animate: Byte;
begin
  Result := inherited;
end;

constructor tSpriteAnimation.Create;
begin
  inherited;
  FFrames := TNamedList<TSpriteFrame>.Create{(Parent)};
end;

destructor tSpriteAnimation.Destroy;
begin
  inherited;
end;

procedure tSpriteAnimation.Setup;
begin
  inherited;

end;

end.




