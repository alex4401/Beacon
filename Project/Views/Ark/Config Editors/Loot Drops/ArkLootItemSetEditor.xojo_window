#tag Window
Begin BeaconContainer ArkLootItemSetEditor
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
   Index           =   -2147483648
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
      AllowInfiniteScroll=   False
      AutoDeactivate  =   True
      AutoHideScrollbars=   True
      Bold            =   False
      Border          =   False
      ColumnCount     =   1
      ColumnsResizable=   False
      ColumnWidths    =   ""
      DataField       =   ""
      DataSource      =   ""
      DefaultRowHeight=   47
      DefaultSortColumn=   0
      DefaultSortDirection=   0
      EditCaption     =   "Edit"
      Enabled         =   True
      EnableDrag      =   False
      EnableDragReorder=   False
      GridLinesHorizontal=   1
      GridLinesVertical=   1
      HasHeading      =   False
      HeadingIndex    =   0
      Height          =   343
      HelpTag         =   ""
      Hierarchical    =   False
      Index           =   -2147483648
      InitialParent   =   ""
      InitialValue    =   ""
      Italic          =   False
      Left            =   0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      PreferencesKey  =   ""
      RequiresSelection=   False
      Scope           =   2
      ScrollbarHorizontal=   False
      ScrollBarVertical=   True
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
      TypeaheadColumn =   0
      Underline       =   False
      UseFocusRing    =   False
      Visible         =   True
      VisibleRowCount =   0
      Width           =   560
      _ScrollOffset   =   0
      _ScrollWidth    =   -1
   End
   Begin ArkLootItemSetSettingsContainer Settings
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
      ContentHeight   =   0
      DoubleBuffer    =   False
      Enabled         =   True
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
      ScrollActive    =   False
      ScrollingEnabled=   False
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
   Begin OmniBar EditorToolbar
      Alignment       =   0
      AllowAutoDeactivate=   True
      AllowFocus      =   False
      AllowFocusRing  =   True
      AllowTabs       =   False
      Backdrop        =   0
      BackgroundColor =   ""
      ContentHeight   =   0
      DoubleBuffer    =   False
      Enabled         =   True
      Height          =   41
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   0
      LeftPadding     =   -1
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      RightPadding    =   -1
      Scope           =   2
      ScrollActive    =   False
      ScrollingEnabled=   False
      ScrollSpeed     =   20
      TabIndex        =   5
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   0
      Transparent     =   True
      Visible         =   True
      Width           =   560
   End
End
#tag EndWindow

#tag WindowCode
	#tag Method, Flags = &h21
		Private Sub DrawEntryCell(Entry As Ark.LootItemSetEntry, G As Graphics, Width As Integer, ForegroundColor As Color)
		  Const Margin = 10
		  
		  Var QuantityText As String
		  If Entry.MinQuantity = Entry.MaxQuantity Then
		    QuantityText = Entry.MinQuantity.ToString
		  Else
		    QuantityText = Entry.MinQuantity.ToString + " to " + Entry.MaxQuantity.ToString
		  End If
		  
		  Var MainLine As String = QuantityText + " of " + Entry.Label
		  Var MainBaseline As Integer = Round(Margin + G.CapHeight)
		  G.DrawingColor = ForegroundColor
		  G.FontUnit = FontUnits.Point
		  G.FontSize = 0
		  G.FontName = "System"
		  G.DrawText(MainLine, Margin, MainBaseline, Width - (Margin * 2), True)
		  G.FontName = "SmallSystem"
		  
		  Var StatLineTop As Integer = MainBaseline + Margin
		  Var StatLineHeight As Integer = Max(12, Round(G.CapHeight))
		  Var StatMidLine As Double = StatLineTop + (StatLineHeight / 2)
		  Var StatBaseline As Integer = Round(StatMidLine + (G.CapHeight / 2))
		  Var StatIconTop As Integer = Round(StatMidLine - 6)
		  Var StatTextLeft As Integer = Margin
		  
		  #if false
		    // Odd place to do this, but it knows the metrics
		    If Self.mHasSizedRows = False Then
		      Self.EntryList.DefaultRowHeight = StatLineTop + StatLineHeight + Margin
		      Self.EntryList.Invalidate
		      Self.mHasSizedRows = True
		    End If
		  #endif
		  
		  Var SecondaryColor As Color = ForegroundColor.AtOpacity(0.4)
		  G.DrawingColor = SecondaryColor
		  
		  Var QualityIcon As Picture = BeaconUI.IconWithColor(IconMiniQuality, SecondaryColor, G.ScaleX, G.ScaleX)
		  G.DrawPicture(QualityIcon, StatTextLeft, StatIconTop)
		  StatTextLeft = StatTextLeft + QualityIcon.Width + (Margin / 2)
		  Var QualityText As String
		  If Entry.MinQuality = Entry.MaxQuality Then
		    QualityText = Entry.MinQuality.Label
		  Else
		    QualityText = Entry.MinQuality.Label(False) + " to " + Entry.MaxQuality.Label(False)
		  End If
		  G.DrawText(QualityText, StatTextLeft, StatBaseline)
		  StatTextLeft = StatTextLeft + Ceiling(G.TextWidth(QualityText)) + Margin
		  
		  Var WeightIcon As Picture = BeaconUI.IconWithColor(IconMiniWeight, SecondaryColor, G.ScaleX, G.ScaleX)
		  G.DrawPicture(WeightIcon, StatTextLeft, StatIconTop)
		  StatTextLeft = StatTextLeft + WeightIcon.Width + (Margin / 2)
		  Var WeightText As String
		  If Entry.RawWeight = Floor(Entry.RawWeight) Then
		    // Show as integer
		    WeightText = Entry.RawWeight.ToString(Locale.Current, ",##0")
		  Else
		    WeightText = Entry.RawWeight.ToString(Locale.Current, ",##0.00")
		  End If
		  G.DrawText(WeightText, StatTextLeft, StatBaseline)
		  StatTextLeft = StatTextLeft + Ceiling(G.TextWidth(WeightText)) + Margin
		  
		  Var BlueprintIcon As Picture = BeaconUI.IconWithColor(IconMiniBlueprint, SecondaryColor, G.ScaleX, G.ScaleX)
		  G.DrawPicture(BlueprintIcon, StatTextLeft, StatIconTop)
		  StatTextLeft = StatTextLeft + BlueprintIcon.Width + (Margin / 2)
		  Var BlueprintText As String = Entry.ChanceToBeBlueprint.ToString(Locale.Current, "0%")
		  G.DrawText(BlueprintText, StatTextLeft, StatBaseline)
		  StatTextLeft = StatTextLeft + Ceiling(G.TextWidth(BlueprintText)) + Margin
		  
		  If Entry.StatClampMultiplier <> 1.0 Then
		    Var StatIcon As Picture = BeaconUI.IconWithColor(IconMiniStats, SecondaryColor, G.ScaleX, G.ScaleX)
		    G.DrawPicture(StatIcon, StatTextLeft, StatIconTop)
		    StatTextLeft = StatTextLeft + StatIcon.Width + (Margin / 2)
		    Var StatText As String = Entry.StatClampMultiplier.ToString(Locale.Current, ",##0.0####")
		    G.DrawText(StatText, StatTextLeft, StatBaseline)
		    StatTextLeft = StatTextLeft + Ceiling(G.TextWidth(StatText)) + Margin
		  End If
		  
		  If Entry.SingleItemQuantity And Entry.Count > 1 Then
		    Var SingleIcon As Picture = BeaconUI.IconWithColor(IconMiniSingle, SecondaryColor, G.ScaleX, G.ScaleX)
		    G.DrawPicture(SingleIcon, StatTextLeft, StatIconTop)
		    StatTextLeft = StatTextLeft + SingleIcon.Width + Margin
		  End If
		  
		  If Entry.PreventGrinding Then
		    Var UngrindableIcon As Picture = BeaconUI.IconWithColor(IconMiniUngrindable, SecondaryColor, G.ScaleX, G.ScaleX)
		    G.DrawPicture(UngrindableIcon, StatTextLeft, StatIconTop)
		    StatTextLeft = StatTextLeft + UngrindableIcon.Width + Margin
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub EditSelectedEntries(Prefilter As String = "")
		  Var Sources() As Ark.LootItemSetEntry
		  For I As Integer = 0 To EntryList.RowCount - 1
		    If Not EntryList.Selected(I) Then
		      Continue
		    End If
		    
		    Sources.Add(EntryList.RowTagAt(I))
		  Next
		  
		  Var Entries() As Ark.LootItemSetEntry = ArkLootEntryEditor.Present(Self, Self.Project.ContentPacks, Sources, Prefilter)
		  If Entries = Nil Or Entries.LastIndex <> Sources.LastIndex Then
		    Return
		  End If
		  
		  Var ItemSet As Ark.MutableLootItemSet = Self.LootItemSet
		  If ItemSet Is Nil Then
		    Return
		  End If
		  
		  For I As Integer = 0 To Entries.LastIndex
		    Var Source As Ark.LootItemSetEntry = Sources(I)
		    Var Idx As Integer = ItemSet.IndexOf(Source)
		    If Idx > -1 Then
		      ItemSet(Idx) = Entries(I)
		    End If
		  Next
		  
		  Self.UpdateEntryList()
		  RaiseEvent Updated
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GoToChild(Entry As Ark.LootItemSetEntry, Option As Ark.LootItemSetEntryOption = Nil) As Boolean
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

	#tag Method, Flags = &h0
		Function LootItemSet() As Ark.MutableLootItemSet
		  If (Self.mRef Is Nil) = False And (Self.mRef.Value Is Nil) = False Then
		    Return Ark.MutableLootItemSet(Self.mRef.Value)
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LootItemSet(Assigns ItemSet As Ark.MutableLootItemSet)
		  If ItemSet = Self.LootItemSet Then
		    Return
		  End If
		  
		  If ItemSet Is Nil Then
		    Self.mRef = Nil
		  Else
		    Self.mRef = New WeakRef(ItemSet)
		  End If
		  
		  Self.Settings.ItemSet = ItemSet
		  Self.UpdateEntryList()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Project() As Ark.Project
		  Return RaiseEvent GetProject()
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RemoveSelectedEntries()
		  Var Changed As Boolean
		  Var ItemSet As Ark.MutableLootItemSet = Self.LootItemSet
		  If ItemSet Is Nil Then
		    Return
		  End If
		  
		  For I As Integer = EntryList.RowCount - 1 DownTo 0
		    If Not EntryList.Selected(I) Then
		      Continue
		    End If
		    
		    Var Entry As Ark.LootItemSetEntry = EntryList.RowTagAt(I)
		    Var Idx As Integer = ItemSet.IndexOf(Entry)
		    If Idx > -1 Then
		      ItemSet.RemoveAt(Idx)
		      Changed = True
		    End If
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
		Private Sub UpdateEntryList(SelectEntries() As Ark.LootItemSetEntry)
		  Var Selected() As String
		  Var ScrollToSelection As Boolean
		  If (SelectEntries Is Nil) = False Then
		    For Each Entry As Ark.LootItemSetEntry In SelectEntries
		      If (Entry Is Nil) = False Then
		        Selected.Add(Entry.UUID)
		      End If
		    Next
		    ScrollToSelection = True
		  Else
		    For I As Integer = 0 To EntryList.RowCount - 1
		      If EntryList.Selected(I) Then
		        Var Entry As Ark.LootItemSetEntry = EntryList.RowTagAt(I)
		        Selected.Add(Entry.UUID)
		      End If
		    Next
		  End If
		  
		  Self.EntryList.RemoveAllRows()
		  
		  Var ItemSet As Ark.MutableLootItemSet = Self.LootItemSet
		  If ItemSet Is Nil Then
		    Self.UpdateStatus()
		    Return
		  End If
		  
		  For I As Integer = 0 To ItemSet.LastIndex
		    Var Entry As Ark.LootItemSetEntry = ItemSet(I)
		    If Entry Is Nil Then
		      Continue
		    End If
		    
		    Var QuantityText As String
		    If Entry.MinQuantity = Entry.MaxQuantity Then
		      QuantityText = Entry.MinQuantity.ToString
		    Else
		      QuantityText = Entry.MinQuantity.ToString + " to " + Entry.MaxQuantity.ToString
		    End If
		    
		    Var MainLine As String = QuantityText + " of " + Entry.Label
		    
		    EntryList.AddRow(MainLine) // Even though we're drawing over it, this can help screen readers
		    Var Idx As Integer = EntryList.LastAddedRowIndex
		    EntryList.RowTagAt(Idx) = Entry
		    EntryList.Selected(Idx) = Selected.IndexOf(Entry.UUID) > -1
		  Next
		  
		  EntryList.Sort
		  
		  If ScrollToSelection Then
		    EntryList.EnsureSelectionIsVisible()
		  End If
		  
		  Self.UpdateStatus()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UpdateEntryList(ParamArray SelectEntries() As Ark.LootItemSetEntry)
		  Self.UpdateEntryList(SelectEntries)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UpdateStatus()
		  Var TotalCount As Integer = Self.EntryList.RowCount
		  Var SelectedCount As Integer = Self.EntryList.SelectedRowCount
		  
		  Var Caption As String = TotalCount.ToString(Locale.Current, ",##0") + " " + If(TotalCount = 1, "Item Set Entry", "Item Set Entries")
		  If SelectedCount > 0 Then
		    Caption = SelectedCount.ToString(Locale.Current, ",##0") + " of " + Caption + " Selected"
		  End If
		  Self.StatusBar1.Caption = Caption
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event GetProject() As Ark.Project
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Updated()
	#tag EndHook


	#tag Property, Flags = &h21
		Private mHasSizedRows As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mRef As WeakRef
	#tag EndProperty


	#tag Constant, Name = kClipboardType, Type = String, Dynamic = False, Default = \"com.thezaz.beacon.ark.loot.itemsetentry", Scope = Private
	#tag EndConstant

	#tag Constant, Name = MinEditorWidth, Type = Double, Dynamic = False, Default = \"300", Scope = Public
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
		  Var Entries() As Dictionary
		  For I As Integer = 0 To Me.RowCount - 1
		    If Me.Selected(I) Then
		      Entries.Add(Ark.LootItemSetEntry(Me.RowTagAt(I)).SaveData)
		    End If
		  Next
		  
		  If Entries.LastIndex = -1 Then
		    Return
		  End If
		  
		  Var Contents As String
		  If Entries.LastIndex = 0 Then
		    Contents = Beacon.GenerateJSON(Entries(0), False)
		  Else
		    Contents = Beacon.GenerateJSON(Entries, False)
		  End If
		  
		  Board.RawData(Self.kClipboardType) = Contents
		End Sub
	#tag EndEvent
	#tag Event
		Sub PerformPaste(Board As Clipboard)
		  If Not Board.RawDataAvailable(Self.kClipboardType) Then
		    Return
		  End If
		  
		  Var Contents As String = DefineEncoding(Board.RawData(Self.kClipboardType), Encodings.UTF8)
		  Var Parsed As Variant
		  Try
		    Parsed = Beacon.ParseJSON(Contents)
		  Catch Err As RuntimeException
		    System.Beep
		    Return
		  End Try
		  
		  Var Modified As Boolean
		  Var Info As Introspection.TypeInfo = Introspection.GetType(Parsed)
		  If Info.FullName = "Dictionary" Then
		    // Single item
		    Var Entry As Ark.LootItemSetEntry = Ark.LootItemSetEntry.FromSaveData(Parsed)
		    If (Entry Is Nil) = False Then
		      Self.LootItemSet.Add(Entry)
		      Modified = True
		    End If
		  ElseIf Info.FullName = "Object()" Then
		    // Multiple items
		    Var Dicts() As Variant = Parsed
		    For Each Dict As Dictionary In Dicts
		      Var Entry As Ark.LootItemSetEntry = Ark.LootItemSetEntry.FromSaveData(Dict)
		      If Entry <> Nil Then
		        Self.LootItemSet.Add(Entry)
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
		Function ConstructContextualMenu(Base As MenuItem, X As Integer, Y As Integer) As Boolean
		  #Pragma Unused X
		  #Pragma Unused Y
		  
		  Var CreateBlueprintItem As New MenuItem("Create Blueprint Entry", "createblueprintentry")
		  CreateBlueprintItem.Enabled = Me.SelectedRowCount > 0
		  Base.AddMenu(CreateBlueprintItem)
		  
		  Var SplitEngramsItem As New MenuItem("Split Engrams", "splitengrams")
		  SplitEngramsItem.Enabled = False
		  For I As Integer = 0 To Me.LastRowIndex
		    If Not Me.Selected(I) Then
		      Continue
		    End If
		    Var Entry As Ark.LootItemSetEntry = Me.RowTagAt(I)
		    If Entry.Count > 1 Then
		      SplitEngramsItem.Enabled = True
		      Exit
		    End If
		  Next
		  Base.AddMenu(SplitEngramsItem)
		  
		  Var MergeEngramsItem As New MenuItem("Merge Engrams", "mergeengrams")
		  MergeEngramsItem.Enabled = Me.SelectedRowCount > 1
		  Base.AddMenu(MergeEngramsItem)
		  
		  Return True
		End Function
	#tag EndEvent
	#tag Event
		Function ContextualMenuAction(HitItem As MenuItem) As Boolean
		  Select Case hitItem.Tag
		  Case "createblueprintentry"
		    Var Entries() As Ark.MutableLootItemSetEntry
		    For Idx As Integer = 0 To Me.LastRowIndex
		      If Me.Selected(Idx) Then
		        Entries.Add(Ark.LootItemSetEntry(Me.RowTagAt(Idx)).MutableClone)
		      End If
		    Next Idx
		    
		    Var BlueprintEntry As Ark.LootItemSetEntry = Self.LootItemSet.AddBlueprintEntry(Entries)
		    If (BlueprintEntry Is Nil) = False Then
		      Self.UpdateEntryList(BlueprintEntry)
		      RaiseEvent Updated
		    End If
		    Return True
		  Case "splitengrams"
		    Var ItemSet As Ark.MutableLootItemSet = Self.LootItemSet
		    If ItemSet Is Nil Then
		      Return True
		    End If
		    
		    Var Entries() As Ark.LootItemSetEntry
		    For I As Integer = 0 To Me.LastRowIndex
		      If Me.Selected(I) And Ark.LootItemSetEntry(Me.RowTagAt(I)).Count > 1 Then
		        Entries.Add(Me.RowTagAt(I))
		      End If
		    Next
		    
		    Var Replacements() As Ark.LootItemSetEntry = Ark.LootItemSetEntry.Split(Entries)
		    If Replacements = Nil Or Replacements.LastIndex = -1 Then
		      Return True
		    End If
		    
		    // This is probably not very fast, but it's accurate.
		    For Each Entry As Ark.LootItemSetEntry In Entries
		      Var Idx As Integer = ItemSet.IndexOf(Entry)
		      If Idx > -1 Then
		        ItemSet.RemoveAt(Idx)
		      End If
		    Next
		    
		    For Each Replacement As Ark.LootItemSetEntry In Replacements
		      ItemSet.Add(Replacement)
		    Next
		    Self.UpdateEntryList(Replacements)
		    RaiseEvent Updated
		    Return True
		  Case "mergeengrams"
		    Var ItemSet As Ark.MutableLootItemSet = Self.LootItemSet
		    If ItemSet Is Nil Then
		      Return True
		    End If
		    
		    Var Entries() As Ark.LootItemSetEntry
		    For I As Integer = 0 To Me.LastRowIndex
		      If Me.Selected(I) Then
		        Entries.Add(Me.RowTagAt(I))
		      End If
		    Next
		    
		    Var Replacement As Ark.LootItemSetEntry = Ark.LootItemSetEntry.Merge(Entries)
		    If Replacement = Nil Then
		      Return True
		    End If
		    
		    // This is probably not very fast, but it's accurate.
		    For Each Entry As Ark.LootItemSetEntry In Entries
		      Var Idx As Integer = ItemSet.IndexOf(Entry)
		      If Idx > -1 Then
		        ItemSet.RemoveAt(Idx)
		      End If
		    Next
		    
		    ItemSet.Add(Replacement)
		    Self.UpdateEntryList(Replacement)
		    RaiseEvent Updated
		    Return True
		  End Select
		End Function
	#tag EndEvent
	#tag Event
		Sub Change()
		  Var EditButton As OmniBarItem = Self.EditorToolbar.Item("EditEntryButton")
		  If (EditButton Is Nil) = False Then
		    EditButton.Enabled = Me.CanEdit
		  End If
		  Self.UpdateStatus()
		End Sub
	#tag EndEvent
	#tag Event
		Function CompareRows(row1 as Integer, row2 as Integer, column as Integer, ByRef result as Integer) As Boolean
		  Var Entry1 As Ark.LootItemSetEntry = Me.RowTagAt(Row1)
		  Var Entry2 As Ark.LootItemSetEntry = Me.RowTagAt(Row2)
		  
		  Result = Entry1.Label.Compare(Entry2.Label, ComparisonOptions.CaseInsensitive)
		  Return True
		End Function
	#tag EndEvent
	#tag Event
		Function CanEdit() As Boolean
		  Return Me.SelectedRowCount > 0
		End Function
	#tag EndEvent
	#tag Event
		Sub PerformEdit()
		  Self.EditSelectedEntries()
		End Sub
	#tag EndEvent
	#tag Event
		Sub CellBackgroundPaint(G As Graphics, Row As Integer, Column As Integer, BackgroundColor As Color, TextColor As Color, IsHighlighted As Boolean)
		  #Pragma Unused BackgroundColor
		  #Pragma Unused IsHighlighted
		  
		  If Column <> 0 Or Row >= Me.RowCount Then
		    Return
		  End If
		  
		  Self.DrawEntryCell(Me.RowTagAt(Row), G, Me.ColumnAt(Column).WidthActual, TextColor)
		End Sub
	#tag EndEvent
	#tag Event
		Function CellTextPaint(G As Graphics, Row As Integer, Column As Integer, Line As String, ByRef TextColor As Color, HorizontalPosition As Integer, VerticalPosition As Integer, IsHighlighted As Boolean) As Boolean
		  #Pragma Unused G
		  #Pragma Unused Row
		  #Pragma Unused Line
		  #Pragma Unused TextColor
		  #Pragma Unused HorizontalPosition
		  #Pragma Unused VerticalPosition
		  #Pragma Unused IsHighlighted
		  
		  Return True
		End Function
	#tag EndEvent
#tag EndEvents
#tag Events Settings
	#tag Event
		Sub Resized()
		  Var ListTop As Integer = Me.Top + Me.Height
		  If Self.EntryList.Top = ListTop Then
		    Return
		  End If
		  
		  Var Diff As Integer = ListTop - Self.EntryList.Top
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
#tag Events EditorToolbar
	#tag Event
		Sub ItemPressed(Item As OmniBarItem, ItemRect As Rect)
		  #Pragma Unused ItemRect
		  
		  Select Case Item.Name
		  Case "AddEntryButton"
		    Var Entries() As Ark.LootItemSetEntry = ArkLootEntryEditor.Present(Self, Self.Project.ContentPacks)
		    If Entries = Nil Then
		      Return
		    End If
		    
		    Var ItemSet As Ark.MutableLootItemSet = Self.LootItemSet
		    If ItemSet Is Nil Then
		      Return
		    End If
		    For Each Entry As Ark.LootItemSetEntry In Entries
		      ItemSet.Add(Entry)
		    Next
		    
		    Self.UpdateEntryList(Entries)
		    RaiseEvent Updated
		  Case "EditEntryButton"
		    Self.EditSelectedEntries()
		  End Select
		End Sub
	#tag EndEvent
	#tag Event
		Sub Open()
		  Me.Append(OmniBarItem.CreateTitle("Title", "Item Set Entries"))
		  Me.Append(OmniBarItem.CreateSeparator("TitleSeparator"))
		  Me.Append(OmniBarItem.CreateButton("AddEntryButton", "New Entry", IconToolbarAdd, "Add engrams to this item set."))
		  Me.Append(OmniBarItem.CreateButton("EditEntryButton", "Edit", IconToolbarEdit, "Edit the selected entries.", False))
		  
		  Me.Item("Title").Priority = 5
		  Me.Item("TitleSeparator").Priority = 5
		End Sub
	#tag EndEvent
#tag EndEvents
#tag ViewBehavior
	#tag ViewProperty
		Name="Index"
		Visible=true
		Group="ID"
		InitialValue="-2147483648"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
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
