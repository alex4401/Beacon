#tag Window
Begin BeaconContainer ItemSetEditor
   AcceptFocus     =   False
   AcceptTabs      =   True
   AutoDeactivate  =   True
   BackColor       =   &cFFFFFF00
   Backdrop        =   0
   DoubleBuffer    =   False
   Enabled         =   True
   EraseBackground =   True
   HasBackColor    =   False
   Height          =   428
   HelpTag         =   ""
   InitialParent   =   ""
   Left            =   0
   LockBottom      =   True
   LockLeft        =   True
   LockRight       =   True
   LockTop         =   True
   TabIndex        =   0
   TabPanelIndex   =   0
   TabStop         =   True
   Top             =   0
   Transparent     =   True
   UseFocusRing    =   False
   Visible         =   True
   Width           =   560
   Begin BeaconListbox EntryList
      AutoDeactivate  =   True
      AutoHideScrollbars=   True
      Bold            =   False
      Border          =   False
      ColumnCount     =   4
      ColumnsResizable=   False
      ColumnWidths    =   "*,80,120,140"
      DataField       =   ""
      DataSource      =   ""
      DefaultRowHeight=   22
      Enabled         =   True
      EnableDrag      =   False
      EnableDragReorder=   False
      GridLinesHorizontal=   1
      GridLinesVertical=   1
      HasHeading      =   True
      HeadingIndex    =   0
      Height          =   343
      HelpTag         =   ""
      Hierarchical    =   False
      Index           =   -2147483648
      InitialParent   =   ""
      InitialValue    =   "Description	Quantity	Quality	Figures"
      Italic          =   False
      Left            =   0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      RequiresSelection=   False
      RowCount        =   "0"
      Scope           =   2
      ScrollbarHorizontal=   False
      ScrollBarVertical=   True
      SelectionChangeBlocked=   False
      SelectionType   =   1
      ShowDropIndicator=   False
      TabIndex        =   3
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   64
      Transparent     =   True
      Underline       =   False
      UseFocusRing    =   False
      Visible         =   True
      Width           =   560
      _ScrollOffset   =   0
      _ScrollWidth    =   -1
   End
   Begin BeaconToolbar Header
      AcceptFocus     =   False
      AcceptTabs      =   False
      AutoDeactivate  =   True
      Backdrop        =   0
      Caption         =   "Item Set Contents"
      DoubleBuffer    =   False
      Enabled         =   True
      EraseBackground =   "False"
      Height          =   40
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      Resizer         =   ""
      ResizerEnabled  =   True
      Scope           =   2
      ScrollSpeed     =   20
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      Top             =   0
      Transparent     =   False
      UseFocusRing    =   True
      Visible         =   True
      Width           =   560
   End
   Begin FadedSeparator FadedSeparator1
      AcceptFocus     =   False
      AcceptTabs      =   False
      AutoDeactivate  =   True
      Backdrop        =   0
      DoubleBuffer    =   False
      Enabled         =   True
      EraseBackground =   "True"
      Height          =   1
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      Scope           =   2
      ScrollSpeed     =   20
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      Top             =   40
      Transparent     =   True
      UseFocusRing    =   True
      Visible         =   True
      Width           =   560
   End
   Begin ItemSetSettingsContainer Settings
      AcceptFocus     =   False
      AcceptTabs      =   True
      AutoDeactivate  =   True
      BackColor       =   &cFFFFFF00
      Backdrop        =   0
      DoubleBuffer    =   False
      Enabled         =   True
      EraseBackground =   True
      HasBackColor    =   False
      Height          =   23
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      Scope           =   2
      TabIndex        =   2
      TabPanelIndex   =   0
      TabStop         =   True
      Top             =   41
      Transparent     =   True
      UseFocusRing    =   False
      Visible         =   True
      Width           =   560
   End
   Begin StatusBar StatusBar1
      AcceptFocus     =   False
      AcceptTabs      =   False
      AutoDeactivate  =   True
      Backdrop        =   0
      Borders         =   1
      Caption         =   ""
      DoubleBuffer    =   False
      Enabled         =   True
      EraseBackground =   "True"
      Height          =   21
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   False
      Scope           =   2
      ScrollSpeed     =   20
      TabIndex        =   4
      TabPanelIndex   =   0
      TabStop         =   True
      Top             =   407
      Transparent     =   True
      UseFocusRing    =   True
      Visible         =   True
      Width           =   560
   End
End
#tag EndWindow

#tag WindowCode
	#tag Method, Flags = &h21
		Private Function Document() As Beacon.Document
		  Return RaiseEvent GetDocument()
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub EditSelectedEntries(Prefilter As String = "")
		  Dim Sources() As Beacon.SetEntry
		  For I As Integer = 0 To EntryList.RowCount - 1
		    If Not EntryList.Selected(I) Then
		      Continue
		    End If
		    
		    Sources.AddRow(EntryList.RowTagAt(I))
		  Next
		  
		  Dim Entries() As Beacon.SetEntry = EntryEditor.Present(Self, Self.Document.Mods, Sources, Prefilter)
		  If Entries = Nil Or Entries.LastRowIndex <> Sources.LastRowIndex Then
		    Return
		  End If
		  
		  For I As Integer = 0 To Entries.LastRowIndex
		    Dim Source As Beacon.SetEntry = Sources(I)
		    Dim Idx As Integer = Self.mSet.IndexOf(Source)
		    If Idx > -1 Then
		      Self.mSet(Idx) = Entries(I)
		    End If
		  Next
		  
		  Self.UpdateEntryList()
		  RaiseEvent Updated
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EnableMenuItems()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GoToChild(Entry As Beacon.SetEntry, Option As Beacon.SetEntryOption = Nil) As Boolean
		  For I As Integer = 0 To Self.EntryList.RowCount - 1
		    If Self.EntryList.RowTagAt(I) = Entry Then
		      Self.EntryList.SelectedRowIndex = I
		      Self.EntryList.EnsureSelectionIsVisible()
		      If Option <> Nil And Option.Engram <> Nil Then
		        Self.EditSelectedEntries(Option.Engram.ClassString)
		      End If
		      Return True
		    End If
		  Next
		  Self.EntryList.SelectedRowIndex = -1
		  Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RemoveSelectedEntries()
		  Dim Changed As Boolean
		  
		  For I As Integer = EntryList.RowCount - 1 DownTo 0
		    If Not EntryList.Selected(I) Then
		      Continue
		    End If
		    
		    Dim Entry As Beacon.SetEntry = EntryList.RowTagAt(I)
		    Dim Idx As Integer = Self.mSet.IndexOf(Entry)
		    Self.mSet.Remove(Idx)
		    Changed = True
		  Next
		  
		  If Changed Then
		    Self.UpdateEntryList()
		    RaiseEvent Updated
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ShowSettings(FocusOnName As Boolean = False)
		  Self.Settings.Expand()
		  If FocusOnName Then
		    Self.Settings.EditName()
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UpdateEntryList(SelectEntries() As Beacon.SetEntry)
		  Dim Selected() As String
		  Dim ScrollToSelection As Boolean
		  If SelectEntries <> Nil Then
		    For Each Entry As Beacon.SetEntry In SelectEntries
		      If Entry <> Nil Then
		        Selected.AddRow(Entry.UniqueID)
		      End If
		    Next
		    ScrollToSelection = True
		  Else
		    For I As Integer = 0 To EntryList.RowCount - 1
		      If EntryList.Selected(I) Then
		        Dim Entry As Beacon.SetEntry = EntryList.RowTagAt(I)
		        Selected.AddRow(Entry.UniqueID)
		      End If
		    Next
		  End If
		  
		  EntryList.RemoveAllRows()
		  
		  If Self.mSet = Nil Then
		    Self.UpdateStatus()
		    Return
		  End If
		  
		  
		  If Self.mSet = Nil Then
		    EntryList.RemoveAllRows
		    Return
		  End If
		  
		  For I As Integer = 0 To Self.mSet.LastRowIndex
		    Dim Entry As Beacon.SetEntry = Self.mSet(I)
		    If Entry = Nil Then
		      Continue
		    End If
		    Dim BlueprintChance As Double = if(Entry.CanBeBlueprint, Entry.ChanceToBeBlueprint, 0)
		    Dim RelativeWeight As Double = Self.mSet.RelativeWeight(I)
		    Dim ChanceText As String
		    If RelativeWeight < 0.01 Then
		      ChanceText = "< 1%"
		    Else
		      ChanceText = Str(RelativeWeight * 100, "0") + "%"
		    End If
		    
		    Dim QualityText As String
		    If Entry.MinQuality = Entry.MaxQuality Then
		      QualityText = Language.LabelForQuality(Entry.MinQuality)
		    Else
		      QualityText = Language.LabelForQuality(Entry.MinQuality, True) + " - " + Language.LabelForQuality(Entry.MaxQuality, True)
		    End If
		    
		    Dim QuantityText As String
		    If Entry.MinQuantity = Entry.MaxQuantity Then
		      QuantityText = Entry.MinQuantity.ToString
		    Else
		      QuantityText = Entry.MinQuantity.ToString + " - " + Entry.MaxQuantity.ToString
		    End If
		    
		    Dim FiguresText As String
		    Dim Weight As Double = Entry.RawWeight
		    If Floor(Weight) = Weight Then
		      FiguresText = Format(Weight, "-0,")
		    Else
		      FiguresText = Format(Weight, "-0,.0####")
		    End If
		    FiguresText = FiguresText + " wt"
		    
		    If Entry.CanBeBlueprint Then
		      FiguresText = FiguresText + ", " + Str(BlueprintChance, "0%") + " bp"
		    End If
		    
		    EntryList.AddRow("")
		    Dim Idx As Integer = EntryList.LastAddedRowIndex
		    EntryList.CellValueAt(Idx, Self.ColumnLabel) = Entry.Label
		    EntryList.CellValueAt(Idx, Self.ColumnQuality) = QualityText
		    EntryList.CellValueAt(Idx, Self.ColumnQuantity) = QuantityText
		    EntryList.CellValueAt(Idx, Self.ColumnFigures) = FiguresText
		    
		    EntryList.RowTagAt(Idx) = Entry
		    EntryList.Selected(Idx) = Selected.IndexOf(Entry.UniqueID) > -1
		  Next
		  
		  EntryList.Sort
		  
		  If ScrollToSelection Then
		    EntryList.EnsureSelectionIsVisible()
		  End If
		  
		  Self.UpdateStatus()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UpdateEntryList(ParamArray SelectEntries() As Beacon.SetEntry)
		  Self.UpdateEntryList(SelectEntries)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UpdateStatus()
		  Dim TotalCount As UInteger = Self.EntryList.RowCount
		  Dim SelectedCount As UInteger = Self.EntryList.SelectedRowCount
		  
		  Dim Caption As String = Format(TotalCount, "0,") + " " + If(TotalCount = 1, "Item Set Entry", "Item Set Entries")
		  If SelectedCount > 0 Then
		    Caption = Format(SelectedCount, "0,") + " of " + Caption + " Selected"
		  End If
		  Self.StatusBar1.Caption = Caption
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event GetDocument() As Beacon.Document
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Updated()
	#tag EndHook


	#tag Property, Flags = &h21
		Private mSet As Beacon.ItemSet
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mSet
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Self.mSet = Value
			  Self.Settings.ItemSet = Value
			  Self.UpdateEntryList()
			End Set
		#tag EndSetter
		Set As Beacon.ItemSet
	#tag EndComputedProperty


	#tag Constant, Name = ColumnFigures, Type = Double, Dynamic = False, Default = \"3", Scope = Private
	#tag EndConstant

	#tag Constant, Name = ColumnLabel, Type = Double, Dynamic = False, Default = \"0", Scope = Private
	#tag EndConstant

	#tag Constant, Name = ColumnQuality, Type = Double, Dynamic = False, Default = \"2", Scope = Private
	#tag EndConstant

	#tag Constant, Name = ColumnQuantity, Type = Double, Dynamic = False, Default = \"1", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kClipboardType, Type = String, Dynamic = False, Default = \"com.thezaz.beacon.setentry", Scope = Private
	#tag EndConstant


#tag EndWindowCode

#tag Events EntryList
	#tag Event
		Function CanCopy() As Boolean
		  Return Me.SelectedRowIndex > -1
		End Function
	#tag EndEvent
	#tag Event
		Function CanPaste(Board As Clipboard) As Boolean
		  Return Board.RawDataAvailable(Self.kClipboardType)
		End Function
	#tag EndEvent
	#tag Event
		Sub PerformClear(Warn As Boolean)
		  #Pragma Unused Warn
		  
		  Self.RemoveSelectedEntries()
		End Sub
	#tag EndEvent
	#tag Event
		Sub PerformCopy(Board As Clipboard)
		  Dim Entries() As Dictionary
		  For I As Integer = 0 To Me.RowCount - 1
		    If Me.Selected(I) Then
		      Entries.AddRow(Beacon.SetEntry(Me.RowTagAt(I)).Export)
		    End If
		  Next
		  
		  If Entries.LastRowIndex = -1 Then
		    Return
		  End If
		  
		  Dim Contents As String
		  If Entries.LastRowIndex = 0 Then
		    Contents = Beacon.GenerateJSON(Entries(0), False)
		  Else
		    Contents = Beacon.GenerateJSON(Entries, False)
		  End If
		  
		  Board.AddRawData(Contents, Self.kClipboardType)
		End Sub
	#tag EndEvent
	#tag Event
		Sub PerformPaste(Board As Clipboard)
		  If Not Board.RawDataAvailable(Self.kClipboardType) Then
		    Return
		  End If
		  
		  Dim Contents As String = DefineEncoding(Board.RawData(Self.kClipboardType), Encodings.UTF8)
		  Dim Parsed As Variant
		  Try
		    Parsed = Beacon.ParseJSON(Contents)
		  Catch Err As RuntimeException
		    System.Beep
		    Return
		  End Try
		  
		  Dim Modified As Boolean
		  Dim Info As Introspection.TypeInfo = Introspection.GetType(Parsed)
		  If Info.FullName = "Dictionary" Then
		    // Single item
		    Dim Entry As Beacon.SetEntry = Beacon.SetEntry.ImportFromBeacon(Parsed)
		    If Entry <> Nil Then
		      Self.mSet.Append(Entry)
		      Modified = True
		    End If
		  ElseIf Info.FullName = "Object()" Then
		    // Multiple items
		    Dim Dicts() As Variant = Parsed
		    For Each Dict As Dictionary In Dicts
		      Dim Entry As Beacon.SetEntry = Beacon.SetEntry.ImportFromBeacon(Dict)
		      If Entry <> Nil Then
		        Self.mSet.Append(Entry)
		        Modified = True
		      End If
		    Next
		  End If
		  
		  If Modified Then
		    Self.UpdateEntryList()
		    RaiseEvent Updated
		  End If
		End Sub
	#tag EndEvent
	#tag Event
		Function CanDelete() As Boolean
		  Return Me.SelectedRowIndex > -1
		End Function
	#tag EndEvent
	#tag Event
		Function RowComparison(row1 as Integer, row2 as Integer, column as Integer, ByRef result as Integer) As Boolean
		  Dim Entry1 As Beacon.SetEntry = Me.RowTagAt(Row1)
		  Dim Entry2 As Beacon.SetEntry = Me.RowTagAt(Row2)
		  
		  Dim Value1, Value2 As Double
		  Select Case Column
		  Case Self.ColumnLabel
		    Return False
		  Case Self.ColumnQuantity
		    If Entry1.MinQuantity = Entry2.MinQuantity Then
		      Value1 = Entry1.MaxQuantity
		      Value2 = Entry2.MaxQuantity
		    Else
		      Value1 = Entry1.MinQuantity
		      Value2 = Entry2.MinQuantity
		    End If
		  Case Self.ColumnQuality
		    If Entry1.MinQuality = Entry2.MinQuality Then
		      Value1 = Entry1.MaxQuality.BaseValue
		      Value2 = Entry2.MaxQuality.BaseValue
		    Else
		      Value1 = Entry1.MinQuality.BaseValue
		      Value2 = Entry2.MinQuality.BaseValue
		    End If
		  Case Self.ColumnFigures
		    Value1 = Entry1.RawWeight
		    Value2 = Entry2.RawWeight
		  End Select
		  
		  If Value1 = Value2 Then
		    Result = 0
		  ElseIf Value1 > Value2 Then
		    Result = 1
		  Else
		    Result = -1
		  End If
		  Return True
		End Function
	#tag EndEvent
	#tag Event
		Sub Opening()
		  
		End Sub
	#tag EndEvent
	#tag Event
		Sub DoubleClicked()
		  Self.EditSelectedEntries()
		End Sub
	#tag EndEvent
	#tag Event
		Function ConstructContextualMenu(Base As MenuItem, X As Integer, Y As Integer) As Boolean
		  #Pragma Unused X
		  #Pragma Unused Y
		  
		  Dim Item As MenuItem
		  
		  Item = New MenuItem
		  Item.Value = "Create Blueprint Entry"
		  Item.Enabled = Me.SelectedRowCount > 0
		  Item.Tag = "createblueprintentry"
		  
		  Base.AddMenu(Item)
		  Return True
		End Function
	#tag EndEvent
	#tag Event
		Function ContextualMenuAction(HitItem As MenuItem) As Boolean
		  Select Case hitItem.Tag
		  Case "createblueprintentry"
		    Dim Entries() As Beacon.SetEntry
		    For I As Integer = 0 To Me.RowCount - 1
		      If Me.Selected(I) Then
		        Entries.AddRow(Me.RowTagAt(I))
		      End If
		    Next
		    
		    Dim BlueprintEntry As Beacon.SetEntry = Beacon.SetEntry.CreateBlueprintEntry(Entries)
		    If BlueprintEntry = Nil Then
		      Return True
		    End If
		    
		    For Each Entry As Beacon.SetEntry In Entries
		      Entry.ChanceToBeBlueprint = 0.0
		    Next
		    
		    Self.mSet.Append(BlueprintEntry)
		    Self.UpdateEntryList(BlueprintEntry)
		    RaiseEvent Updated
		  End Select
		End Function
	#tag EndEvent
	#tag Event
		Sub SelectionChanged()
		  Self.Header.EditEntry.Enabled = Me.SelectedRowCount > 0
		  Self.UpdateStatus()
		End Sub
	#tag EndEvent
	#tag Event
		Function RowIsInvalid(Row As Integer) As Boolean
		  Dim Entry As Beacon.SetEntry = Me.RowTagAt(Row)
		  Return Not Entry.IsValid(Self.Document)
		End Function
	#tag EndEvent
#tag EndEvents
#tag Events Header
	#tag Event
		Sub Pressed(Item As BeaconToolbarItem)
		  Select Case Item.Name
		  Case "AddEntry"
		    Dim Entries() As Beacon.SetEntry = EntryEditor.Present(Self, Self.Document.Mods)
		    If Entries = Nil Then
		      Return
		    End If
		    
		    For Each Entry As Beacon.SetEntry In Entries
		      Self.mSet.Append(Entry)
		    Next
		    
		    Self.UpdateEntryList(Entries)
		    RaiseEvent Updated
		  Case "EditEntry"
		    Self.EditSelectedEntries()
		  End Select
		End Sub
	#tag EndEvent
	#tag Event
		Sub Opening()
		  Dim AddButton As New BeaconToolbarItem("AddEntry", IconToolbarAdd)
		  AddButton.HelpTag = "Add engrams to this item set."
		  
		  Dim EditButton As New BeaconToolbarItem("EditEntry", IconToolbarEdit, False)
		  EditButton.HelpTag = "Edit the selected entries."
		  
		  Me.LeftItems.Append(AddButton)
		  Me.LeftItems.Append(EditButton)
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events Settings
	#tag Event
		Sub Resized()
		  Dim ListTop As Integer = Me.Top + Me.Height
		  If Self.EntryList.Top = ListTop Then
		    Return
		  End If
		  
		  Dim Diff As Integer = ListTop - Self.EntryList.Top
		  Self.EntryList.Top = Self.EntryList.Top + Diff
		  Self.EntryList.Height = Self.EntryList.Height - Diff
		End Sub
	#tag EndEvent
	#tag Event
		Sub SettingsChanged()
		  RaiseEvent Updated
		End Sub
	#tag EndEvent
#tag EndEvents
#tag ViewBehavior
	#tag ViewProperty
		Name="EraseBackground"
		Visible=false
		Group="Behavior"
		InitialValue="True"
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
		Name="AllowFocusRing"
		Visible=true
		Group="Appearance"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="BackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="&hFFFFFF"
		Type="Color"
		EditorType="Color"
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasBackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="AllowFocus"
		Visible=true
		Group="Behavior"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="AllowTabs"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="DoubleBuffer"
		Visible=true
		Group="Windows Behavior"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Backdrop"
		Visible=true
		Group="Background"
		InitialValue=""
		Type="Picture"
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
		Name="Height"
		Visible=true
		Group="Size"
		InitialValue="300"
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
		InitialValue=""
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
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Transparent"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
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
		Name="Width"
		Visible=true
		Group="Size"
		InitialValue="300"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
#tag EndViewBehavior
