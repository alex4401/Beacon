#tag Class
Protected Class BeaconListbox
Inherits Listbox
	#tag Event
		Function CellBackgroundPaint(g As Graphics, row As Integer, column As Integer) As Boolean
		  #Pragma Unused Column
		  
		  Dim ColumnWidth As Integer = Self.ColumnAt(Column).WidthActual
		  Dim RowHeight As Integer = Self.DefaultRowHeight
		  
		  Dim RowInvalid, RowSelected As Boolean
		  If Row < Self.RowCount Then
		    RowInvalid = RowIsInvalid(Row)
		    RowSelected = Self.Selected(Row)
		  End If
		  
		  // To ensure a consistent drawing experience. Partially obscure rows traditionally have a truncated g.height value.
		  Dim Clip As Graphics = G.Clip(0, 0, ColumnWidth, RowHeight)
		  
		  // Need to fill with color first so translucent system colors can apply correctly
		  #if TargetMacOS
		    Dim OSMajor, OSMinor, OSBug As Integer
		    UpdateChecker.OSVersion(OSMajor, OSMinor, OSBug)
		    If Self.Transparent And OSMajor >= 10 And OSMinor >= 14 Then
		      Clip.ClearRect(0, 0, Clip.Width, Clip.Height)
		    Else
		      Clip.DrawingColor = SystemColors.UnderPageBackgroundColor
		      Clip.FillRectangle(0, 0, Clip.Width, Clip.Height)
		    End If
		  #else
		    Clip.DrawingColor = SystemColors.UnderPageBackgroundColor
		    Clip.FillRectangle(0, 0, Clip.Width, Clip.Height)
		  #endif
		  
		  Dim BackgroundColor, TextColor, SecondaryTextColor As Color
		  Dim IsHighlighted As Boolean = Self.Highlighted And Self.Window.Focus = Self
		  If RowSelected Then
		    If IsHighlighted Then
		      BackgroundColor = If(RowInvalid, SystemColors.SystemRedColor, SystemColors.SelectedContentBackgroundColor)
		      TextColor = SystemColors.AlternateSelectedControlTextColor
		    Else
		      BackgroundColor = SystemColors.UnemphasizedSelectedContentBackgroundColor
		      TextColor = SystemColors.UnemphasizedSelectedTextColor
		    End If
		    SecondaryTextColor = TextColor
		  Else
		    BackgroundColor = If(Row Mod 2 = 0, SystemColors.ListEvenRowColor, SystemColors.ListOddRowColor)
		    TextColor = If(RowInvalid, SystemColors.SystemRedColor, SystemColors.TextColor)
		    SecondaryTextColor = If(RowInvalid, TextColor, SystemColors.SecondaryLabelColor)
		  End If
		  
		  Clip.DrawingColor = BackgroundColor
		  Clip.FillRectangle(0, 0, G.Width, G.Height)
		  
		  Call CellBackgroundPaint(Clip, Row, Column, BackgroundColor, TextColor, IsHighlighted)
		  
		  If Row >= Self.RowCount Then
		    Return True
		  End If
		  
		  // Text paint
		  
		  Const CellPadding = 4
		  Const LineSpacing = 6
		  
		  Dim Contents As String = Me.CellValueAt(Row, Column).ReplaceLineEndings(EndOfLine)
		  Dim Lines() As String = Contents.Split(EndOfLine)
		  Dim MaxDrawWidth As Integer = ColumnWidth - (CellPadding * 4)
		  
		  If Lines.LastRowIndex = -1 Then
		    Return True
		  End If
		  
		  Dim IsChecked As Boolean = Self.ColumnTypeAt(Column) = Listbox.CellTypes.CheckBox Or Self.CellTypeAt(Row, Column) = Listbox.CellTypes.CheckBox
		  If IsChecked Then
		    MaxDrawWidth = MaxDrawWidth - 20
		  End If
		  
		  Clip.FontSize = 0
		  Clip.FontName = "System"
		  Clip.Bold = RowInvalid
		  
		  // Need to compute the combined height of the lines
		  Dim TotalTextHeight As Double = Clip.CapHeight
		  Clip.FontName = "SmallSystem"
		  Clip.Bold = False
		  TotalTextHeight = TotalTextHeight + ((Clip.CapHeight + LineSpacing) * Lines.LastRowIndex)
		  Clip.FontName = "System"
		  Clip.Bold = RowInvalid
		  
		  Dim DrawTop As Double = (Clip.Height - TotalTextHeight) / 2
		  For I As Integer = 0 To Lines.LastRowIndex
		    Dim LineWidth As Integer = Min(Ceil(Clip.TextWidth(Lines(I))), MaxDrawWidth)
		    
		    Dim DrawLeft As Integer
		    Dim Align As Listbox.Alignments = Self.CellAlignmentAt(Row, Column)
		    If Align = Listbox.Alignments.Default Then
		      Align = Self.ColumnAlignmentAt(Column)
		    End If
		    Select Case Align
		    Case Listbox.Alignments.Left, Listbox.Alignments.Default
		      DrawLeft = CellPadding + If(IsChecked, 20, 0)
		    Case Listbox.Alignments.Center
		      DrawLeft = CellPadding + If(IsChecked, 20, 0) + ((MaxDrawWidth - LineWidth) / 2)
		    Case Listbox.Alignments.Right, Listbox.Alignments.Decimal
		      DrawLeft = Clip.Width - (LineWidth + CellPadding)
		    End Select
		    
		    Dim LineHeight As Double = Clip.CapHeight
		    Dim LinePosition As Integer = Round(DrawTop + LineHeight)
		    
		    If Not CellTextPaint(Clip, Row, Column, Lines(I), TextColor, DrawLeft, LinePosition, IsHighlighted) Then
		      Clip.DrawingColor = If(I = 0, TextColor, SecondaryTextColor)
		      Clip.DrawText(Lines(I), DrawLeft, LinePosition, MaxDrawWidth, True)
		    End If
		    
		    DrawTop = DrawTop + LineSpacing + LineHeight
		    If I = 0 Then
		      Clip.FontName = "SmallSystem"
		      Clip.FontSize = 0
		      Clip.Bold = False
		    End If
		  Next
		  
		  Return True
		End Function
	#tag EndEvent

	#tag Event
		Function CellTextPaint(g As Graphics, row As Integer, column As Integer, x as Integer, y as Integer) As Boolean
		  #Pragma Unused G
		  #Pragma Unused Row
		  #Pragma Unused Column
		  #Pragma Unused X
		  #Pragma Unused Y
		  
		  Return True
		End Function
	#tag EndEvent

	#tag Event
		Function ConstructContextualMenu(base as MenuItem, x as Integer, y as Integer) As Boolean
		  Dim Board As New Clipboard
		  Dim CanCopy As Boolean = RaiseEvent CanCopy()
		  Dim CanDelete As Boolean = RaiseEvent CanDelete()
		  Dim CanPaste As Boolean = RaiseEvent CanPaste(Board)
		  
		  Dim CutItem As New MenuItem("Cut", "cut")
		  CutItem.Shortcut = "X"
		  CutItem.Enabled = CanCopy And CanDelete
		  Base.AddMenu(CutItem)
		  
		  Dim CopyItem As New MenuItem("Copy", "copy")
		  CopyItem.Shortcut = "C"
		  CopyItem.Enabled = CanCopy
		  Base.AddMenu(CopyItem)
		  
		  Dim PasteItem As New MenuItem("Paste", "paste")
		  PasteItem.Shortcut = "V"
		  PasteItem.Enabled = CanPaste
		  Base.AddMenu(PasteItem)
		  
		  Dim DeleteItem As New MenuItem("Delete", "clear")
		  DeleteItem.Enabled = CanDelete
		  Base.AddMenu(DeleteItem)
		  
		  Call ConstructContextualMenu(Base, X, Y)
		  
		  Dim Bound As Integer = Base.Count - 1
		  For I As Integer = 0 To Bound
		    If Base.MenuAt(I) = DeleteItem And I < Bound Then
		      Base.AddMenuAt(I + 1, New MenuItem(MenuItem.TextSeparator))
		    End If
		  Next
		  
		  Return True
		End Function
	#tag EndEvent

	#tag Event
		Function ContextualMenuAction(hitItem as MenuItem) As Boolean
		  If HitItem.Tag <> Nil And HitItem.Tag.Type = Variant.TypeString Then
		    Select Case HitItem.Tag
		    Case "cut"
		      Self.DoCut()
		      Return True
		    Case "copy"
		      Self.DoCopy()
		      Return True
		    Case "paste"
		      Self.DoPaste()
		      Return True
		    Case "clear"
		      Self.DoClear()
		      Return True
		    End Select
		  End If
		  
		  Return ContextualMenuAction(HitItem)
		End Function
	#tag EndEvent

	#tag Event
		Function KeyDown(Key As String) As Boolean
		  If (Key = Encodings.UTF8.Chr(8) Or Key = Encodings.UTF8.Chr(127)) And CanDelete() Then
		    RaiseEvent PerformClear(True)
		    Return True
		  Else
		    Return RaiseEvent KeyDown(Key)
		  End If
		End Function
	#tag EndEvent

	#tag Event
		Sub MenuSelected()
		  If Self.Window = Nil Or Self.Window.Focus <> Self Then
		    Return
		  End If
		  
		  Dim Board As New Clipboard
		  Dim CanCopy As Boolean = RaiseEvent CanCopy()
		  Dim CanDelete As Boolean = RaiseEvent CanDelete()
		  Dim CanPaste As Boolean = RaiseEvent CanPaste(Board)
		  
		  EditCopy.Enabled = CanCopy
		  EditCut.Enabled = CanCopy And CanDelete
		  EditClear.Enabled = CanDelete
		  EditPaste.Enabled = CanPaste
		  
		  RaiseEvent MenuSelected()
		End Sub
	#tag EndEvent

	#tag Event
		Sub Opening()
		  Self.FontName = "SmallSystem"
		  Self.DefaultRowHeight = Max(26, Self.DefaultRowHeight)
		  
		  RaiseEvent Opening
		  
		  Self.mPostOpenInvalidateCallbackKey = CallLater.Schedule(0, WeakAddressOf PostOpenInvalidate)
		End Sub
	#tag EndEvent

	#tag Event
		Sub SelectionChanged()
		  If Self.mBlockSelectionChangeCount > 0 Then
		    Self.mFireChangeWhenUnlocked = True
		    Return
		  End If
		  
		  RaiseEvent SelectionChanged
		End Sub
	#tag EndEvent


	#tag MenuHandler
		Function EditClear() As Boolean Handles EditClear.Action
			Self.DoClear()
			Return True
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function EditCopy() As Boolean Handles EditCopy.Action
			Self.DoCopy()
			Return True
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function EditCut() As Boolean Handles EditCut.Action
			Self.DoCut()
			Return True
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function EditPaste() As Boolean Handles EditPaste.Action
			Self.DoPaste()
			Return True
		End Function
	#tag EndMenuHandler


	#tag Method, Flags = &h0
		Function CanCopy() As Boolean
		  Return RaiseEvent CanCopy()
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CanPaste() As Boolean
		  Dim Board As New Clipboard
		  Return RaiseEvent CanPaste(Board)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Destructor()
		  CallLater.Cancel(Self.mPostOpenInvalidateCallbackKey)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoClear()
		  RaiseEvent PerformClear(True)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoCopy()
		  Dim Board As New Clipboard
		  RaiseEvent PerformCopy(Board)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoCut()
		  Dim Board As New Clipboard
		  RaiseEvent PerformCopy(Board)
		  RaiseEvent PerformClear(False)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoPaste()
		  Dim Board As New Clipboard
		  RaiseEvent PerformPaste(Board)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EnsureSelectionIsVisible(Animated As Boolean = True)
		  If Self.SelectedRowCount = 0 Then
		    Return
		  End If
		  
		  Dim ViewportHeight As Integer = Self.Height
		  If Self.HasHeader Then
		    ViewportHeight = ViewportHeight - Self.HeaderHeight
		  End If
		  If Self.HasBorder Then
		    ViewportHeight = ViewportHeight - 2
		  End If
		  Dim VisibleStart As Integer = Self.ScrollPosition
		  Dim VisibleEnd As Integer = VisibleStart + Floor(ViewportHeight / Self.DefaultRowHeight)
		  Dim AtLeastOneVisible As Boolean
		  
		  For I As Integer = 0 To Self.RowCount - 1
		    If Self.Selected(I) Then
		      AtLeastOneVisible = AtLeastOneVisible Or (I >= VisibleStart And I <= VisibleEnd)
		    End If
		  Next
		  If Not AtLeastOneVisible Then
		    If Animated Then
		      Dim Task As New AnimationKit.ScrollTask(Self)
		      Task.DurationInSeconds = 0.4
		      Task.Position = Self.SelectedRowIndex
		      Task.Curve = AnimationKit.Curve.CreateEaseOut
		      
		      If Self.mScrollTask <> Nil Then
		        Self.mScrollTask.Cancel
		        Self.mScrollTask = Nil
		      End If
		      
		      Self.mScrollTask = Task
		      Task.Run
		    Else
		      Self.ScrollPosition = Self.SelectedRowIndex
		    End If
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Highlighted() As Boolean
		  If Self.Enabled Then
		    #if TargetCocoa
		      Declare Function IsMainWindow Lib "Cocoa.framework" Selector "isMainWindow" (Target As Integer) As Boolean
		      Declare Function IsKeyWindow Lib "Cocoa.framework" Selector "isKeyWindow" (Target As Integer) As Boolean
		      Return IsKeyWindow(Self.TrueWindow.Handle) Or IsMainWindow(Self.TrueWindow.Handle)
		    #else
		      Return True
		    #endif
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PostOpenInvalidate()
		  Self.ScrollPosition = Self.ScrollPosition
		  Self.Invalidate()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RowCount(Assigns Value As Integer)
		  If Self.RowCount = Value Then
		    Return
		  End If
		  
		  #if TargetWindows
		    Dim ScrollerVisible As Boolean = Self.HasVerticalScrollbar
		    If ScrollerVisible Then
		      Self.HasVerticalScrollbar = False
		    End If
		  #endif
		  
		  Dim Count As Integer = Self.RowCount
		  While Count < Value
		    Self.AddRow("")
		    Count = Count + 1
		  Wend
		  While Count > Value
		    Self.RemoveRowAt(Count - 1)
		    Count = Count - 1
		  Wend
		  
		  #if TargetWindows
		    If ScrollerVisible Then
		      Self.HasVerticalScrollbar = True
		    End If
		  #endif
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event CanCopy() As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event CanDelete() As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event CanPaste(Board As Clipboard) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event CellBackgroundPaint(G As Graphics, Row As Integer, Column As Integer, BackgroundColor As Color, TextColor As Color, IsHighlighted As Boolean)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event CellTextPaint(G As Graphics, Row As Integer, Column As Integer, Line As String, ByRef TextColor As Color, HorizontalPosition As Integer, VerticalPosition As Integer, IsHighlighted As Boolean) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event ConstructContextualMenu(Base As MenuItem, X As Integer, Y As Integer) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event ContextualMenuAction(HitItem As MenuItem) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event KeyDown(Key As String) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event MenuSelected()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Opening()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event PerformClear(Warn As Boolean)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event PerformCopy(Board As Clipboard)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event PerformPaste(Board As Clipboard)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event RowIsInvalid(Row As Integer) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event SelectionChanged()
	#tag EndHook


	#tag Property, Flags = &h21
		Private mBlockSelectionChangeCount As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mFireChangeWhenUnlocked As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPostOpenInvalidateCallbackKey As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mScrollTask As AnimationKit.ScrollTask
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mBlockSelectionChangeCount > 0
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If Value Then
			    Self.mBlockSelectionChangeCount = Self.mBlockSelectionChangeCount + 1
			  Else
			    Self.mBlockSelectionChangeCount = Self.mBlockSelectionChangeCount - 1
			  End If
			  
			  If Self.mBlockSelectionChangeCount = 0 And Self.mFireChangeWhenUnlocked Then
			    RaiseEvent SelectionChanged
			    Self.mFireChangeWhenUnlocked = False
			  End If
			End Set
		#tag EndSetter
		SelectionChangeBlocked As Boolean
	#tag EndComputedProperty


	#tag Constant, Name = AlternateRowColor, Type = Color, Dynamic = False, Default = \"&cFAFAFA", Scope = Public
	#tag EndConstant

	#tag Constant, Name = InvalidSelectedRowColor, Type = Color, Dynamic = False, Default = \"&c800000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = InvalidSelectedRowColorInactive, Type = Color, Dynamic = False, Default = \"&cD4BEBE", Scope = Public
	#tag EndConstant

	#tag Constant, Name = InvalidSelectedTextColor, Type = Color, Dynamic = False, Default = \"&cFFFFFF", Scope = Public
	#tag EndConstant

	#tag Constant, Name = InvalidSelectedTextColorInactive, Type = Color, Dynamic = False, Default = \"&c000000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = InvalidTextColor, Type = Color, Dynamic = False, Default = \"&c800000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = PrimaryRowColor, Type = Color, Dynamic = False, Default = \"&cFFFFFF", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SelectedRowColor, Type = Color, Dynamic = False, Default = \"&c0850CE", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SelectedRowColorInactive, Type = Color, Dynamic = False, Default = \"&cCACACA", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SelectedTextColor, Type = Color, Dynamic = False, Default = \"&cFFFFFF", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SelectedTextColorInactive, Type = Color, Dynamic = False, Default = \"&c000000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = TextColor, Type = Color, Dynamic = False, Default = \"&c000000", Scope = Public
	#tag EndConstant


	#tag Structure, Name = CGRect, Flags = &h21
		X As CGFloat
		  Y As CGFloat
		  W As CGFloat
		H As CGFloat
	#tag EndStructure


	#tag ViewBehavior
		#tag ViewProperty
			Name="RequiresSelection"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Tooltip"
			Visible=true
			Group="Appearance"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowAutoDeactivate"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="HasBorder"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="GridLinesHorizontalStyle"
			Visible=true
			Group="Appearance"
			InitialValue="0"
			Type="Borders"
			EditorType="Enum"
			#tag EnumValues
				"0 - Default"
				"1 - None"
				"2 - ThinDotted"
				"3 - ThinSolid"
				"4 - ThickSolid"
				"5 - DoubleThinSolid"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="GridLinesVerticalStyle"
			Visible=true
			Group="Appearance"
			InitialValue="0"
			Type="Borders"
			EditorType="Enum"
			#tag EnumValues
				"0 - Default"
				"1 - None"
				"2 - ThinDotted"
				"3 - ThinSolid"
				"4 - ThickSolid"
				"5 - DoubleThinSolid"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="HasHeader"
			Visible=true
			Group="Appearance"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="HasHorizontalScrollbar"
			Visible=true
			Group="Appearance"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="HasVerticalScrollbar"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="DropIndicatorVisible"
			Visible=true
			Group="Appearance"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowFocusRing"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FontName"
			Visible=true
			Group="Font"
			InitialValue="System"
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FontSize"
			Visible=true
			Group="Font"
			InitialValue="0"
			Type="Single"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FontUnit"
			Visible=true
			Group="Font"
			InitialValue="0"
			Type="FontUnits"
			EditorType="Enum"
			#tag EnumValues
				"0 - Default"
				"1 - Pixel"
				"2 - Point"
				"3 - Inch"
				"4 - Millimeter"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowAutoHideScrollbars"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowResizableColumns"
			Visible=true
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowRowDragging"
			Visible=true
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowRowReordering"
			Visible=true
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowExpandableRows"
			Visible=true
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="RowSelectionType"
			Visible=true
			Group="Behavior"
			InitialValue="0"
			Type="RowSelectionTypes"
			EditorType="Enum"
			#tag EnumValues
				"0 - Single"
				"1 - Multiple"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Height"
			Visible=true
			Group="Position"
			InitialValue="100"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="InitialParent"
			Visible=false
			Group="Position"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockBottom"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockLeft"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockRight"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockTop"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabIndex"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabPanelIndex"
			Visible=false
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabStop"
			Visible=true
			Group="Position"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Width"
			Visible=true
			Group="Position"
			InitialValue="100"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Transparent"
			Visible=true
			Group="Appearance"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ColumnCount"
			Visible=true
			Group="Appearance"
			InitialValue="1"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ColumnWidths"
			Visible=true
			Group="Appearance"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="DefaultRowHeight"
			Visible=true
			Group="Appearance"
			InitialValue="26"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Enabled"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="HeadingIndex"
			Visible=true
			Group="Appearance"
			InitialValue="-1"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="InitialValue"
			Visible=true
			Group="Appearance"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Visible"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="_ScrollOffset"
			Visible=false
			Group="Appearance"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="_ScrollWidth"
			Visible=false
			Group="Appearance"
			InitialValue="-1"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Bold"
			Visible=true
			Group="Font"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Italic"
			Visible=true
			Group="Font"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Underline"
			Visible=true
			Group="Font"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="DataField"
			Visible=true
			Group="Database Binding"
			InitialValue=""
			Type="String"
			EditorType="DataField"
		#tag EndViewProperty
		#tag ViewProperty
			Name="DataSource"
			Visible=true
			Group="Database Binding"
			InitialValue=""
			Type="String"
			EditorType="DataSource"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SelectionChangeBlocked"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
