unit uMain;

{
  author : ZuBy
  rzaripov1990@gmail.com

  ����� ������� ������� �������,
  ��� �������� ����� ������ � Content (TRectangle)

  IDE -> Project -> Version Info -> theme = No TitleBar
}

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Colors;

type
  TmyUI = record
    StatusBar, NavBar, ScaleInt: Integer;
    class function ContentColor: TAlphaColor; static;
  end;

  TFormMain = class(TForm)
    Content: TRectangle;
    ColorPanel1: TColorPanel;
    ColorBox1: TColorBox;
    chUseBlackNavBar: TCheckBox;
    rNavBar: TRectangle;
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ColorPanel1Change(Sender: TObject);
    procedure chUseBlackNavBarChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure myRealignContent;
  end;

var
  FormMain: TFormMain;
  myUI: TmyUI;

implementation

{$R *.fmx}

uses
  FMX.StatusBar;

{ TmyUI }

class function TmyUI.ContentColor: TAlphaColor;
begin
  TAlphaColorRec(Result).R := 238;
  TAlphaColorRec(Result).G := 238;
  TAlphaColorRec(Result).B := 238;
  TAlphaColorRec(Result).A := 255;
end;

procedure TFormMain.chUseBlackNavBarChange(Sender: TObject);
begin
  rNavBar.Visible := chUseBlackNavBar.IsChecked;
  myRealignContent;
end;

procedure TFormMain.ColorPanel1Change(Sender: TObject);
begin
  Fill.Color := ColorBox1.Color; // ������ ���� ��� ���� �����
{$IFDEF IOS} StatusBarSetColor(Fill.Color); {$ENDIF} // ����� ����� � run-time ��� IOS
end;

procedure TFormMain.FormActivate(Sender: TObject);
begin
  Content.Fill.Color := TmyUI.ContentColor; // ������ ���� ��� ������ ����������
  Fill.Kind := TBrushKind.Solid; // ����� �������� �����
  Fill.Color := ColorBox1.Color; // ������ ���� ��� ���� �����
{$IFDEF IOS} StatusBarSetColor(Fill.Color); {$ENDIF} // ����� ����� � run-time  ��� IOS
end;

procedure TFormMain.FormResize(Sender: TObject);
begin
  myRealignContent;
end;

procedure TFormMain.FormShow(Sender: TObject);
begin
  FormActivate(nil);
  StatusBarGetBounds(myUI.StatusBar, myUI.NavBar, myUI.ScaleInt); // �������� �������

  StatusBarSetColor(Fill.Color);
  { �� �������� ��� �������� ���:
    //  ����� ���������� �� ������ ������� (���� FullScreen �����)
    //  ������ ��� ���������� ��������������, ������� �� ����� ����� ����� �����
    //  � ���� ��� ����� ����� ���������, �� ����������� ������ ������
  }
  { �� ���� ��� �������� ���:
    // ������ ��� ��������� ���� �����, �� ���� � run-time ������ ����, �� �� �� �������� �����
    // ������� ����� ������� ����� ���� �����, ��� ������������ ����� �����
  }
  myRealignContent;
end;

procedure TFormMain.myRealignContent;
var
  aVert: boolean;
begin
  aVert := Height > Width; // �������� ����������
  if aVert then
  begin
    Content.Margins.Left := 0;
    Content.Margins.Top := myUI.StatusBar; // ����� ������, ��� ������� 5.0+
    Content.Margins.Right := 0;
    if chUseBlackNavBar.IsChecked then
    begin
      rNavBar.Align := TAlignLayout.MostBottom;
      rNavBar.Height := myUI.NavBar;
      Content.Margins.Bottom := 0; // ������� ������
    end
    else
      Content.Margins.Bottom := myUI.NavBar; // ������ �����, ��� ������� 5.0+ (��� ������� ���������� ������)
  end
  else
  begin
    // � �������������� ���������, ������ ����� ������
    Content.Margins.Left := 0;
    Content.Margins.Top := myUI.StatusBar; // ����� ������, ��� ������� 5.0+
    if chUseBlackNavBar.IsChecked then
    begin
      rNavBar.Align := TAlignLayout.MostRight;
      rNavBar.Width := myUI.NavBar;
      Content.Margins.Right := 0; // ������� ������
    end
    else
      Content.Margins.Right := myUI.NavBar; // ������ ������, ��� ������� 5.0+ (��� ������� ���������� ������)
    Content.Margins.Bottom := 0;
  end;
end;

end.
