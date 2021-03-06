unit uSoModel;

interface

uses
  System.SyncObjs, uEngine2DClasses, System.SysUtils,
  uSoTypes, uCommonClasses,
  uClasses, uSoObjectKeeper, uSoRenderer, uSoCollider, uSoFormattor, uSoObject,
  uSoAnimator, uSoKeyProcessor, uSoMouseProcessor, uSoLogicKeeper, uSoContainerKeeper,
  uSoPropertyKeeper;

type
  TSoModel = class
  private
    FCritical: TCriticalSection;
    FImage: TAnonImage;
    FContainerKeeper: TSoContainerKeeper;
    // Workers
    FRenderer: TSoRenderer;
    FCollider: TSoCollider;
    FFormattor: TSoFormattor;
    FAnimator: TSoAnimator;
    // Keepers
    FObjectKeeper: TSoObjectKeeper;
    FLogicKeper: TSoLogicKeeper;
//    FPropertyKeeper: TSoPropertyKeeper;
    // Processors
    FKeyProcessor: TSoKeyProcessor;
    FMouseProcessor: TSoMouseProcessor;
    function GetEngineSize: TPointF;
  protected
    // Workers
    property Renderer: TSoRenderer read FRenderer;
    property Collider: TSoCollider read FCollider;
    property Formattor: TSoFormattor read FFormattor;
    property Animator: TSoAnimator read FAnimator;
    // Keepers
    property ObjectKeeper: TSoObjectKeeper read FObjectKeeper;
    property LogicKeeper: TSoLogicKeeper read FLogicKeper;
//    property PropertyKeeper: TSoPropertyKeeper read FPropertyKeeper;
    // Processors
    property KeyProcessor: TSoKeyProcessor read FKeyProcessor;
    property MouseProcessor: TSoMouseProcessor read FMouseProcessor;
    // Common
    property EngineSize: TPointF read GetEngineSize;
  public
    procedure ExecuteOnTick;
    procedure ExecuteKeyUp(ASender: TObject; Key: Word; KeyChar: Char; Shift: TShiftState); // Process key on tick
    procedure ExecuteKeyDown(ASender: TObject; Key: Word; KeyChar: Char; Shift: TShiftState); // Process key on tick
    procedure ExecuteMouseDown(ASender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure ExecuteMouseUp(ASender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure ExecuteMouseMove(X, Y: Single);
    constructor Create(const AImage: TAnonImage; const ACritical: TCriticalSection; const AIsHor: TBooleanFunction);
    destructor Destroy; override;
  end;

implementation

{ TSoModel }

constructor TSoModel.Create(const AImage: TAnonImage; const ACritical: TCriticalSection;
  const AIsHor: TBooleanFunction);
begin
  FCritical := ACritical;
  FImage := AImage;
  FContainerKeeper := TSoContainerKeeper.Create;
  FObjectKeeper := TSoObjectKeeper.Create(FCritical);
  FLogicKeper := TSoLogicKeeper.Create(FCritical);
  FRenderer := TSoRenderer.Create(FCritical, AImage);
  FCollider := TSoCollider.Create(FCritical);
  FFormattor := TSoFormattor.Create(FCritical);
  FAnimator := TSoAnimator.Create(FCritical);
  FKeyProcessor := TSoKeyProcessor.Create(FCritical);
  FMouseProcessor := TSoMouseProcessor.Create(FCritical, FCollider);
//  FPropertyKeeper := TSoPropertyKeeper.Create(FCritical);

  // Container Keeper changes on adding of unitpart
  FLogicKeper.OnAdd := FContainerKeeper.OnAdd;
  FRenderer.OnAdd := FContainerKeeper.OnAdd;
  FCollider.OnAdd := FContainerKeeper.OnAdd;
  FFormattor.OnAdd := FContainerKeeper.OnAdd;
  FAnimator.OnAdd := FContainerKeeper.OnAdd;
  FKeyProcessor.OnAdd := FContainerKeeper.OnAdd;
  FMouseProcessor.OnAdd := FContainerKeeper.OnAdd;
 // FPropertyKeeper.OnAdd := FContainerKeeper.OnAdd;
end;

destructor TSoModel.Destroy;
begin
    FContainerKeeper.Free;
    FObjectKeeper.Free;
    FLogicKeper.Free;
    FRenderer.Free;
    FCollider.Free;
    FFormattor.Free;
    FAnimator.Free;
    FKeyProcessor.Free;
    FMouseProcessor.Free;
//    FPropertyKeeper.Free;
  inherited;
end;

procedure TSoModel.ExecuteKeyDown(ASender: TObject; Key: Word; KeyChar: Char; Shift: TShiftState);
begin
  FKeyProcessor.ExecuteKeyDown(Key, KeyChar, Shift);
end;

procedure TSoModel.ExecuteKeyUp(ASender: TObject; Key: Word; KeyChar: Char; Shift: TShiftState);
begin
  FKeyProcessor.ExecuteKeyUp(Key, KeyChar, Shift);
end;

procedure TSoModel.ExecuteMouseDown(ASender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Single);
begin
  FMouseProcessor.ExecuteMouseDown(Button, Shift, X, Y);
end;

procedure TSoModel.ExecuteMouseMove(X, Y: Single);
begin
  FMouseProcessor.ExecuteMouseMove(X, Y);
end;

procedure TSoModel.ExecuteMouseUp(ASender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Single);
begin
  FMouseProcessor.ExecuteMouseUp(Button, Shift, X, Y);
end;

procedure TSoModel.ExecuteOnTick;
begin
  FAnimator.Execute;
  FLogicKeper.Execute;
  FCollider.Execute;
  FRenderer.Execute;
end;

function TSoModel.GetEngineSize: TPointF;
begin
  Result := TPointF.Create(FImage.Width, FImage.Height);
end;

end.
