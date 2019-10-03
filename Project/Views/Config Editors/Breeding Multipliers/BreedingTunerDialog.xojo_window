#tag Window
Begin BeaconDialog BreedingTunerDialog
   BackColor       =   &cFFFFFF00
   Backdrop        =   0
   CloseButton     =   False
   Composite       =   False
   Frame           =   8
   FullScreen      =   False
   FullScreenButton=   False
   HasBackColor    =   False
   Height          =   400
   ImplicitInstance=   False
   LiveResize      =   "True"
   MacProcID       =   0
   MaxHeight       =   32000
   MaximizeButton  =   False
   MaxWidth        =   600
   MenuBar         =   0
   MenuBarVisible  =   True
   MinHeight       =   400
   MinimizeButton  =   False
   MinWidth        =   600
   Placement       =   1
   Resizable       =   "True"
   Resizeable      =   False
   SystemUIVisible =   "True"
   Title           =   "Auto Compute Imprinting Multiplier"
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
      Text            =   "Auto Compute Imprinting Multiplier"
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
   Begin Label ExplanationLabel
      AutoDeactivate  =   True
      Bold            =   False
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   36
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   True
      Scope           =   2
      Selectable      =   False
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Choose the creatures that are important for hitting 100% imprint, and Beacon will compute the best imprint period multiplier."
      TextAlign       =   0
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   52
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   560
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
      TabIndex        =   7
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   360
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   80
   End
   Begin UITweaks.ResizedPushButton ActionButton
      AutoDeactivate  =   True
      Bold            =   False
      ButtonStyle     =   0
      Cancel          =   False
      Caption         =   "OK"
      Default         =   True
      Enabled         =   False
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
      TabIndex        =   8
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   360
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   80
   End
   Begin BeaconListbox CreaturesList
      AutoDeactivate  =   True
      AutoHideScrollbars=   True
      Bold            =   False
      Border          =   True
      ColumnCount     =   2
      ColumnsResizable=   False
      ColumnWidths    =   "22,*"
      DataField       =   ""
      DataSource      =   ""
      DefaultRowHeight=   22
      Enabled         =   True
      EnableDrag      =   False
      EnableDragReorder=   False
      GridLinesHorizontal=   0
      GridLinesVertical=   0
      HasHeading      =   False
      HeadingIndex    =   -1
      Height          =   216
      HelpTag         =   ""
      Hierarchical    =   False
      Index           =   -2147483648
      InitialParent   =   ""
      InitialValue    =   ""
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
      TabIndex        =   6
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   132
      Transparent     =   False
      Underline       =   False
      UseFocusRing    =   True
      Visible         =   True
      Width           =   560
      _ScrollOffset   =   0
      _ScrollWidth    =   -1
   End
   Begin UITweaks.ResizedPushButton MajorCreaturesButton
      AutoDeactivate  =   True
      Bold            =   False
      ButtonStyle     =   0
      Cancel          =   True
      Caption         =   "Major Creatures"
      Default         =   False
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   236
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   True
      Scope           =   2
      TabIndex        =   5
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   100
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   129
   End
   Begin UITweaks.ResizedPushButton AllCreaturesButton
      AutoDeactivate  =   True
      Bold            =   False
      ButtonStyle     =   0
      Cancel          =   True
      Caption         =   "All Creatures"
      Default         =   False
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   95
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   True
      Scope           =   2
      TabIndex        =   4
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   100
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   129
   End
   Begin UITweaks.ResizedPushButton ClearCreaturesButton
      AutoDeactivate  =   True
      Bold            =   False
      ButtonStyle     =   0
      Cancel          =   True
      Caption         =   "Clear Creatures"
      Default         =   False
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   377
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   True
      Scope           =   2
      TabIndex        =   9
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   100
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   129
   End
End
#tag EndWindow

#tag WindowCode
	#tag Event
		Sub Opening()
		  Self.CreaturesList.ColumnTypeAt(Self.ColumnChecked) = Listbox.CellTypes.CheckBox
		  
		  Dim Creatures() As Beacon.Creature = LocalData.SharedInstance.SearchForCreatures("", New Beacon.StringList)
		  For Each Creature As Beacon.Creature In Creatures
		    If Creature.IncubationTime = 0 Or Creature.MatureTime = 0 Then
		      Continue
		    End If
		    
		    Self.CreaturesList.AddRow("", Creature.Label)
		    Self.CreaturesList.RowTagAt(Self.CreaturesList.LastAddedRowIndex) = Creature
		  Next
		  
		  Self.CheckCreatures(Preferences.BreedingTunerCreatures)
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Sub CheckCreatures(List As String)
		  Self.mAutoCheckingCreatures = True
		  If List = "*" Then
		    For I As Integer = 0 To Self.CreaturesList.RowCount - 1
		      Self.CreaturesList.CellCheckBoxValueAt(I, Self.ColumnChecked) = True
		    Next
		  Else
		    Dim Creatures() As String = List.Split(",")
		    For I As Integer = 0 To Creatures.LastRowIndex
		      Creatures(I) = Creatures(I).Trim
		    Next
		    
		    For I As Integer = 0 To Self.CreaturesList.RowCount - 1
		      Dim ClassString As String = Beacon.Creature(Self.CreaturesList.RowTagAt(I)).ClassString
		      Self.CreaturesList.CellCheckBoxValueAt(I, Self.ColumnChecked) = Creatures.IndexOf(ClassString) > -1
		    Next
		  End If
		  Self.mAutoCheckingCreatures = False
		  
		  Self.mLastCheckedList = List
		  Self.CheckEnabled()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub CheckEnabled()
		  Dim Enabled As Boolean = Self.mLastCheckedList <> ""
		  If Self.ActionButton.Enabled <> Enabled Then
		    Self.ActionButton.Enabled = Enabled
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Constructor(MatureSpeedMultiplier As Double)
		  // Calling the overridden superclass constructor.
		  Self.mMatureSpeedMultiplier = MatureSpeedMultiplier
		  Super.Constructor
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function Present(Parent As Window, MatureSpeedMultiplier As Double) As Double
		  If Parent = Nil Then
		    Return 0
		  End If
		  
		  Dim Win As New BreedingTunerDialog(MatureSpeedMultiplier)
		  Win.ShowModalWithin(Parent.TrueWindow)
		  Dim Multiplier As Double = Win.mChosenMultiplier
		  Win.Close
		  
		  Return Multiplier
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mAutoCheckingCreatures As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mChosenMultiplier As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLastCheckedList As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mMatureSpeedMultiplier As Double
	#tag EndProperty


	#tag Constant, Name = ColumnChecked, Type = Double, Dynamic = False, Default = \"0", Scope = Private
	#tag EndConstant

	#tag Constant, Name = ColumnName, Type = Double, Dynamic = False, Default = \"1", Scope = Private
	#tag EndConstant


#tag EndWindowCode

#tag Events CancelButton
	#tag Event
		Sub Pressed()
		  Self.mChosenMultiplier = 0
		  Self.Hide
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events ActionButton
	#tag Event
		Sub Pressed()
		  Const Threshold = 0.95
		  
		  Dim Creatures() As Beacon.Creature
		  For I As Integer = 0 To Self.CreaturesList.RowCount - 1
		    If Self.CreaturesList.CellCheckBoxValueAt(I, Self.ColumnChecked) Then
		      Creatures.AddRow(Self.CreaturesList.RowTagAt(I))
		    End If
		  Next
		  
		  // Get fastest maturing creature
		  Dim FastestMature As UInt64
		  For Each Creature As Beacon.Creature In Creatures
		    Dim MatureSeconds As UInt64 = Creature.MatureTime / Self.mMatureSpeedMultiplier
		    If FastestMature = 0 Or MatureSeconds < FastestMature Then
		      FastestMature = MatureSeconds
		    End If
		  Next
		  
		  // Reduce the target by a set amount and compute the imprint multiplier
		  Dim TargetCuddleSeconds As UInt64 = FastestMature * Threshold
		  Dim OfficialCuddlePeriod As Integer = LocalData.SharedInstance.GetIntegerVariable("Cuddle Period")
		  Dim ImprintMultiplier As Double = TargetCuddleSeconds / OfficialCuddlePeriod
		  
		  Preferences.BreedingTunerCreatures = Self.mLastCheckedList
		  Self.mChosenMultiplier = ImprintMultiplier
		  Self.Hide
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events CreaturesList
	#tag Event
		Sub CellAction(row As Integer, column As Integer)
		  #Pragma Unused row
		  
		  If Self.mAutoCheckingCreatures Or Column <> Self.ColumnChecked Then
		    Return
		  End If
		  
		  Dim Classes() As String
		  For I As Integer = 0 To Self.CreaturesList.RowCount - 1
		    If Self.CreaturesList.CellCheckBoxValueAt(I, Column) Then
		      Classes.AddRow(Beacon.Creature(Self.CreaturesList.RowTagAt(I)).ClassString)
		    End If
		  Next
		  Self.mLastCheckedList = Classes.Join(",")
		  Self.CheckEnabled()
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events MajorCreaturesButton
	#tag Event
		Sub Pressed()
		  Self.CheckCreatures(LocalData.SharedInstance.GetStringVariable("Major Imprint Creatures"))
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events AllCreaturesButton
	#tag Event
		Sub Pressed()
		  Self.CheckCreatures("*")
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events ClearCreaturesButton
	#tag Event
		Sub Pressed()
		  Self.CheckCreatures("")
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
