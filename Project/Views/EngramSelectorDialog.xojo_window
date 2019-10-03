#tag Window
Begin BeaconDialog EngramSelectorDialog
   BackColor       =   &cFFFFFF00
   Backdrop        =   0
   CloseButton     =   False
   Composite       =   False
   Frame           =   8
   FullScreen      =   False
   FullScreenButton=   False
   HasBackColor    =   False
   Height          =   471
   ImplicitInstance=   False
   LiveResize      =   "True"
   MacProcID       =   0
   MaxHeight       =   32000
   MaximizeButton  =   False
   MaxWidth        =   32000
   MenuBar         =   0
   MenuBarVisible  =   True
   MinHeight       =   471
   MinimizeButton  =   False
   MinWidth        =   600
   Placement       =   1
   Resizable       =   "True"
   Resizeable      =   True
   SystemUIVisible =   "True"
   Title           =   "Select Object"
   Visible         =   True
   Width           =   600
   Begin Label MessageLabel
      AutoDeactivate  =   True
      Bold            =   True
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      Multiline       =   False
      Scope           =   2
      Selectable      =   False
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Select an Object"
      TextAlign       =   0
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   20
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   560
   End
   Begin UITweaks.ResizedTextField FilterField
      AcceptTabs      =   False
      Alignment       =   0
      AutoDeactivate  =   True
      AutomaticallyCheckSpelling=   False
      BackColor       =   &cFFFFFF00
      Bold            =   False
      Border          =   True
      CueText         =   "Search Objects"
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Format          =   ""
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      Italic          =   False
      Left            =   20
      LimitText       =   0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      Mask            =   ""
      Password        =   False
      ReadOnly        =   False
      Scope           =   2
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   52
      Transparent     =   False
      Underline       =   False
      UseFocusRing    =   True
      Visible         =   True
      Width           =   560
   End
   Begin BeaconListbox List
      AutoDeactivate  =   True
      AutoHideScrollbars=   True
      Bold            =   False
      Border          =   True
      ColumnCount     =   2
      ColumnsResizable=   False
      ColumnWidths    =   "*,200"
      DataField       =   ""
      DataSource      =   ""
      DefaultRowHeight=   26
      Enabled         =   True
      EnableDrag      =   False
      EnableDragReorder=   False
      GridLinesHorizontal=   0
      GridLinesVertical=   0
      HasHeading      =   True
      HeadingIndex    =   -1
      Height          =   254
      HelpTag         =   ""
      Hierarchical    =   False
      Index           =   -2147483648
      InitialParent   =   ""
      InitialValue    =   "Name	Mod"
      Italic          =   False
      Left            =   20
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      RequiresSelection=   False
      Scope           =   2
      ScrollbarHorizontal=   False
      ScrollBarVertical=   True
      SelectionChangeBlocked=   False
      SelectionType   =   0
      ShowDropIndicator=   False
      TabIndex        =   2
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   165
      Transparent     =   False
      Underline       =   False
      UseFocusRing    =   True
      Visible         =   True
      Width           =   560
      _ScrollOffset   =   0
      _ScrollWidth    =   -1
   End
   Begin UITweaks.ResizedPushButton ActionButton
      AutoDeactivate  =   True
      Bold            =   False
      ButtonStyle     =   0
      Cancel          =   False
      Caption         =   "Select"
      Default         =   True
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   500
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   False
      Scope           =   2
      TabIndex        =   3
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   431
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   80
   End
   Begin UITweaks.ResizedPushButton CancelButton
      AutoDeactivate  =   True
      Bold            =   False
      ButtonStyle     =   0
      Cancel          =   True
      Caption         =   "Cancel"
      Default         =   False
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   408
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   False
      Scope           =   2
      TabIndex        =   4
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   431
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   80
   End
   Begin BeaconListbox SelectedList
      AutoDeactivate  =   True
      AutoHideScrollbars=   True
      Bold            =   False
      Border          =   True
      ColumnCount     =   1
      ColumnsResizable=   False
      ColumnWidths    =   ""
      DataField       =   ""
      DataSource      =   ""
      DefaultRowHeight=   26
      Enabled         =   True
      EnableDrag      =   False
      EnableDragReorder=   False
      GridLinesHorizontal=   0
      GridLinesVertical=   0
      HasHeading      =   True
      HeadingIndex    =   -1
      Height          =   254
      HelpTag         =   ""
      Hierarchical    =   False
      Index           =   -2147483648
      InitialParent   =   ""
      InitialValue    =   "Selected Objects"
      Italic          =   False
      Left            =   714
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   True
      RequiresSelection=   False
      Scope           =   2
      ScrollbarHorizontal=   False
      ScrollBarVertical=   True
      SelectionChangeBlocked=   False
      SelectionType   =   1
      ShowDropIndicator=   False
      TabIndex        =   5
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   165
      Transparent     =   False
      Underline       =   False
      UseFocusRing    =   True
      Visible         =   True
      Width           =   200
      _ScrollOffset   =   0
      _ScrollWidth    =   -1
   End
   Begin UITweaks.ResizedPushButton AddToSelectionsButton
      AutoDeactivate  =   True
      Bold            =   False
      ButtonStyle     =   0
      Cancel          =   False
      Caption         =   ">>"
      Default         =   False
      Enabled         =   False
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   662
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   True
      Scope           =   2
      TabIndex        =   6
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   266
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   40
   End
   Begin UITweaks.ResizedPushButton RemoveFromSelectionsButton
      AutoDeactivate  =   True
      Bold            =   False
      ButtonStyle     =   0
      Cancel          =   False
      Caption         =   "<<"
      Default         =   False
      Enabled         =   False
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   662
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   True
      Scope           =   2
      TabIndex        =   7
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   298
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   40
   End
   Begin TagPicker Picker
      AcceptFocus     =   False
      AcceptTabs      =   False
      AutoDeactivate  =   True
      Backdrop        =   0
      Border          =   15
      DoubleBuffer    =   False
      Enabled         =   True
      Height          =   67
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      Scope           =   2
      ScrollSpeed     =   20
      Spec            =   ""
      TabIndex        =   8
      TabPanelIndex   =   0
      TabStop         =   True
      Top             =   86
      Transparent     =   True
      UseFocusRing    =   True
      Visible         =   True
      Width           =   560
   End
End
#tag EndWindow

#tag WindowCode
	#tag Event
		Sub Opening()
		  Self.Picker.Tags = LocalData.SharedInstance.AllTags(Self.mCategory)
		  Self.Picker.Spec = Preferences.SelectedTag(Self.mCategory, Self.mSubgroup)
		  Self.UpdateFilter()
		  Self.SwapButtons()
		  Self.ActionButton.Enabled = False
		  Self.Resize()
		  Self.mSettingUp = False
		End Sub
	#tag EndEvent

	#tag Event
		Sub Resized()
		  Self.Resize()
		End Sub
	#tag EndEvent

	#tag Event
		Sub Resizing()
		  Self.Resize()
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Sub Constructor(Category As String, Subgroup As String, Exclude() As Beacon.Blueprint, Mods As Beacon.StringList, AllowMultipleSelection As Boolean)
		  Self.mSettingUp = True
		  For Each Blueprint As Beacon.Blueprint In Exclude
		    Self.mExcluded.AddRow(Blueprint.Path)
		  Next
		  Self.mMods = Mods
		  Self.mAllowMultipleSelection = AllowMultipleSelection
		  Self.mCategory = Category
		  Self.mSubgroup = Subgroup
		  Super.Constructor
		  If AllowMultipleSelection Then
		    Self.Width = Self.Width + 150
		    Self.List.ColumnWidths = "*,150"
		    Self.List.RowSelectionType = Listbox.RowSelectionTypes.Multiple
		    Self.List.Width = Self.List.Width - (24 + Self.SelectedList.Width + Self.AddToSelectionsButton.Width)
		    Self.AddToSelectionsButton.Left = Self.List.Left + Self.List.Width + 12
		    Self.RemoveFromSelectionsButton.Left = Self.AddToSelectionsButton.Left
		    Self.SelectedList.Left = Self.AddToSelectionsButton.Left + Self.AddToSelectionsButton.Width + 12
		    Self.MessageLabel.Value = "Select Objects"
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub MakeSelection()
		  If Not Self.mAllowMultipleSelection Then
		    Self.SelectedList.RemoveAllRows()
		  End If
		  
		  If Self.List.SelectedRowCount > 1 Then
		    For I As Integer = Self.List.RowCount - 1 DownTo 0
		      If Not Self.List.Selected(I) Then
		        Continue
		      End If
		      
		      Self.SelectedList.AddRow(Self.List.CellValueAt(I, 0))
		      Self.SelectedList.RowTagAt(Self.SelectedList.LastAddedRowIndex) = Self.List.RowTagAt(I)
		      If Self.mAllowMultipleSelection Then
		        Self.mExcluded.AddRow(Beacon.Blueprint(Self.List.RowTagAt(I)).Path)
		        Self.List.RemoveRowAt(I)
		      End If
		    Next
		  ElseIf Self.List.SelectedRowCount = 1 Then
		    Self.SelectedList.AddRow(Self.List.CellValueAt(Self.List.SelectedRowIndex, 0))
		    Self.SelectedList.RowTagAt(Self.SelectedList.LastAddedRowIndex) = Self.List.RowTagAt(Self.List.SelectedRowIndex)
		    If Self.mAllowMultipleSelection Then
		      Self.mExcluded.AddRow(Beacon.Blueprint(Self.List.RowTagAt(Self.List.SelectedRowIndex)).Path)
		      Self.List.RemoveRowAt(Self.List.SelectedRowIndex)
		    End If
		  End If
		  
		  Self.ActionButton.Enabled = Self.SelectedList.RowCount > 0
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function Present(Parent As Window, Subgroup As String, Exclude() As Beacon.Creature, Mods As Beacon.StringList = Nil, AllowMultipleSelection As Boolean) As Beacon.Creature()
		  Dim ExcludeBlueprints() As Beacon.Blueprint
		  For Each Creature As Beacon.Creature In Exclude
		    ExcludeBlueprints.AddRow(Creature)
		  Next
		  
		  Dim Blueprints() As Beacon.Blueprint = Present(Parent, Beacon.CategoryCreatures, Subgroup, ExcludeBlueprints, Mods, AllowMultipleSelection)
		  Dim Creatures() As Beacon.Creature
		  For Each Blueprint As Beacon.Blueprint In Blueprints
		    If Blueprint IsA Beacon.Creature Then
		      Creatures.AddRow(Beacon.Creature(Blueprint))
		    End If
		  Next
		  Return Creatures
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function Present(Parent As Window, Subgroup As String, Exclude() As Beacon.Engram, Mods As Beacon.StringList = Nil, AllowMultipleSelection As Boolean) As Beacon.Engram()
		  Dim ExcludeBlueprints() As Beacon.Blueprint
		  For Each Engram As Beacon.Engram In Exclude
		    ExcludeBlueprints.AddRow(Engram)
		  Next
		  
		  Dim Blueprints() As Beacon.Blueprint = Present(Parent, Beacon.CategoryEngrams, Subgroup, ExcludeBlueprints, Mods, AllowMultipleSelection)
		  Dim Engrams() As Beacon.Engram
		  For Each Blueprint As Beacon.Blueprint In Blueprints
		    If Blueprint IsA Beacon.Engram Then
		      Engrams.AddRow(Beacon.Engram(Blueprint))
		    End If
		  Next
		  Return Engrams
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function Present(Parent As Window, Category As String, Subgroup As String, Exclude() As Beacon.Blueprint, Mods As Beacon.StringList = Nil, AllowMultipleSelection As Boolean) As Beacon.Blueprint()
		  Dim Blueprints() As Beacon.Blueprint
		  If Parent = Nil Then
		    Return Blueprints
		  End If
		  
		  If Mods = Nil Then
		    Mods = New Beacon.StringList
		  End If
		  
		  Dim Win As New EngramSelectorDialog(Category, Subgroup, Exclude, Mods, AllowMultipleSelection)
		  Win.ShowModalWithin(Parent.TrueWindow)
		  If Win.mCancelled Then
		    Win.Close
		    Return Blueprints
		  End If
		  
		  For I As Integer = 0 To Win.SelectedList.RowCount - 1
		    Blueprints.AddRow(Win.SelectedList.RowTagAt(I))
		  Next
		  
		  Win.Close
		  Return Blueprints
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Resize()
		  Dim ButtonsHeight As Integer = (Self.RemoveFromSelectionsButton.Top + Self.RemoveFromSelectionsButton.Height) - Self.AddToSelectionsButton.Top
		  Dim ButtonsTop As Integer = Self.SelectedList.Top + ((Self.SelectedList.Height - ButtonsHeight) / 2)
		  Self.AddToSelectionsButton.Top = ButtonsTop
		  Self.RemoveFromSelectionsButton.Top = Self.AddToSelectionsButton.Top + Self.AddToSelectionsButton.Height + 12
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UnmakeSelection()
		  Dim SelectPaths() As String
		  For I As Integer = Self.SelectedList.RowCount - 1 DownTo 0
		    If Not Self.SelectedList.Selected(I) Then
		      Continue
		    End If
		    
		    Dim Blueprint As Beacon.Blueprint = Self.SelectedList.RowTagAt(I)
		    Dim Idx As Integer = Self.mExcluded.IndexOf(Blueprint.Path)
		    If Idx > -1 Then
		      Self.mExcluded.RemoveRowAt(Idx)
		    End If
		    SelectPaths.AddRow(Blueprint.Path)
		    Self.SelectedList.RemoveRowAt(I)
		  Next
		  Self.ActionButton.Enabled = Self.SelectedList.RowCount > 0
		  
		  Self.List.SelectionChangeBlocked = True
		  Self.UpdateFilter()
		  For I As Integer = 0 To Self.List.RowCount - 1
		    Dim Blueprint As Beacon.Blueprint = Self.List.RowTagAt(I)
		    Self.List.Selected(I) = SelectPaths.IndexOf(Blueprint.Path) > -1
		  Next
		  Self.List.EnsureSelectionIsVisible
		  Self.List.SelectionChangeBlocked = False
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UpdateFilter()
		  Dim SearchText As String = Self.FilterField.Value
		  Dim Tags As String = Self.Picker.Spec
		  
		  Dim Blueprints() As Beacon.Blueprint = Beacon.Data.SearchForBlueprints(Self.mCategory, SearchText, Self.mMods, Tags)
		  Dim ScrollPosition As Integer = Self.List.ScrollPosition
		  Self.List.RemoveAllRows
		  For Each Blueprint As Beacon.Blueprint In Blueprints
		    If Self.mExcluded.IndexOf(Blueprint.Path) > -1 Then
		      Continue
		    End If
		    
		    Self.List.AddRow(Blueprint.Label, Blueprint.ModName)
		    Self.List.RowTagAt(Self.List.LastAddedRowIndex) = Blueprint
		  Next
		  Self.List.ScrollPosition = ScrollPosition
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mAllowMultipleSelection As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCancelled As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCategory As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mExcluded() As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mMods As Beacon.StringList
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSettingUp As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSubgroup As String
	#tag EndProperty


#tag EndWindowCode

#tag Events FilterField
	#tag Event
		Sub TextChanged()
		  Self.UpdateFilter()
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events List
	#tag Event
		Sub SelectionChanged()
		  If Not Self.mAllowMultipleSelection Then
		    Self.MakeSelection()
		  End If
		  
		  Self.AddToSelectionsButton.Enabled = Me.SelectedRowCount > 0
		End Sub
	#tag EndEvent
	#tag Event
		Sub DoubleClicked()
		  Self.MakeSelection()
		  
		  If Not Self.mAllowMultipleSelection Then
		    Self.mCancelled = False
		    Self.Hide
		  End If
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events ActionButton
	#tag Event
		Sub Pressed()
		  Self.mCancelled = False
		  Self.Hide()
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events CancelButton
	#tag Event
		Sub Pressed()
		  Self.mCancelled = True
		  Self.Hide()
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events SelectedList
	#tag Event
		Sub SelectionChanged()
		  Self.RemoveFromSelectionsButton.Enabled = Me.SelectedRowCount > 0
		End Sub
	#tag EndEvent
	#tag Event
		Function CanDelete() As Boolean
		  Return Me.SelectedRowCount > 0
		End Function
	#tag EndEvent
	#tag Event
		Sub DoubleClicked()
		  Self.UnmakeSelection
		End Sub
	#tag EndEvent
	#tag Event
		Sub PerformClear(Warn As Boolean)
		  #Pragma Unused Warn
		  
		  Self.UnmakeSelection
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events AddToSelectionsButton
	#tag Event
		Sub Pressed()
		  Self.MakeSelection()
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events RemoveFromSelectionsButton
	#tag Event
		Sub Pressed()
		  Self.UnmakeSelection()
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events Picker
	#tag Event
		Sub TagsChanged()
		  If Self.mSettingUp Then
		    Return
		  End If
		  
		  Preferences.SelectedTag(Self.mCategory, Self.mSubgroup) = Me.Spec
		  Self.UpdateFilter()
		End Sub
	#tag EndEvent
	#tag Event
		Sub ShouldAdjustHeight(Delta As Integer)
		  If Me = Nil Then
		    Return
		  End If
		  
		  Me.Height = Me.Height + Delta
		  
		  Self.List.Height = Self.List.Height - Delta
		  Self.List.Top = Self.List.Top + Delta
		  Self.SelectedList.Top = Self.List.Top
		  Self.SelectedList.Height = Self.List.Height
		  
		  Dim ToggleButtonsHeight As Integer = AddToSelectionsButton.Height + RemoveFromSelectionsButton.Height + 12
		  Self.AddToSelectionsButton.Top = Self.SelectedList.Top + ((Self.SelectedList.Height - ToggleButtonsHeight) / 2)
		  Self.RemoveFromSelectionsButton.Top = Self.AddToSelectionsButton.Top + Self.AddToSelectionsButton.Height + 12
		End Sub
	#tag EndEvent
#tag EndEvents
#tag ViewBehavior
	#tag ViewProperty
		Name="Resizeable"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBarVisible"
		Visible=true
		Group="Deprecated"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimumWidth"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimumHeight"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximumWidth"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximumHeight"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Type"
		Visible=true
		Group="Frame"
		InitialValue="0"
		Type="Types"
		EditorType="Enum"
		#tag EnumValues
			"0 - Document"
			"1 - Movable Modal"
			"2 - Modal Dialog"
			"3 - Floating Window"
			"4 - Plain Box"
			"5 - Shadowed Box"
			"6 - Rounded Window"
			"7 - Global Floating Window"
			"8 - Sheet Window"
			"9 - Metal Window"
			"11 - Modeless Dialog"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasCloseButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasMaximizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasMinimizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasFullScreenButton"
		Visible=true
		Group="Frame"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="DefaultLocation"
		Visible=true
		Group="Behavior"
		InitialValue="0"
		Type="Locations"
		EditorType="Enum"
		#tag EnumValues
			"0 - Default"
			"1 - Parent Window"
			"2 - Main Screen"
			"3 - Parent Window Screen"
			"4 - Stagger"
		#tag EndEnumValues
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
		Name="BackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="&hFFFFFF"
		Type="Color"
		EditorType="Color"
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
		Name="Interfaces"
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
		Name="Width"
		Visible=true
		Group="Size"
		InitialValue="600"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Height"
		Visible=true
		Group="Size"
		InitialValue="400"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Title"
		Visible=true
		Group="Frame"
		InitialValue="Untitled"
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Composite"
		Visible=false
		Group="OS X (Carbon)"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MacProcID"
		Visible=false
		Group="OS X (Carbon)"
		InitialValue="0"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="ImplicitInstance"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Visible"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="FullScreen"
		Visible=false
		Group="Behavior"
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
		Name="MenuBar"
		Visible=true
		Group="Menus"
		InitialValue=""
		Type="MenuBar"
		EditorType=""
	#tag EndViewProperty
#tag EndViewBehavior
