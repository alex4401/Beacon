#tag Window
Begin ContainerControl SettingsListContainer
   AllowAutoDeactivate=   True
   AllowFocus      =   False
   AllowFocusRing  =   False
   AllowTabs       =   True
   Backdrop        =   0
   BackgroundColor =   &cFFFFFF00
   DoubleBuffer    =   True
   Enabled         =   True
   EraseBackground =   True
   HasBackgroundColor=   False
   Height          =   376
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
   Tooltip         =   ""
   Top             =   0
   Transparent     =   True
   Visible         =   True
   Width           =   594
   Begin ScrollBar Scroller
      AllowAutoDeactivate=   True
      AllowFocus      =   True
      AllowLiveScrolling=   True
      Enabled         =   True
      Height          =   376
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   579
      LineStep        =   88
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   True
      MaximumValue    =   100
      MinimumValue    =   0
      PageStep        =   20
      Scope           =   2
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   0
      Transparent     =   False
      Value           =   0
      Visible         =   True
      Width           =   15
   End
End
#tag EndWindow

#tag WindowCode
	#tag Event
		Function MouseWheel(X As Integer, Y As Integer, DeltaX as Integer, DeltaY as Integer) As Boolean
		  #Pragma Unused X
		  #Pragma Unused Y
		  
		  Var WheelData As New BeaconUI.ScrollEvent(Self.Scroller.LineStep, DeltaX, DeltaY)
		  Var ScrollPosition As Integer = Min(Max(Self.Scroller.Value + WheelData.ScrollY, 0), Self.Scroller.MaximumValue)
		  If Self.Scroller.Value <> ScrollPosition Then
		    Self.Scroller.Value = ScrollPosition
		  End If
		  Return True
		End Function
	#tag EndEvent

	#tag Event
		Sub Resized()
		  Self.SetVisibilities()
		End Sub
	#tag EndEvent

	#tag Event
		Sub Resizing()
		  Self.SetVisibilities()
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Function CreateElement(Key As Beacon.ConfigKey) As SettingsListElement
		  Select Case Key.ValueType
		  Case Beacon.ConfigKey.ValueTypes.TypeBoolean
		    Return New SettingsListBooleanElement(Key)
		  Case Beacon.ConfigKey.ValueTypes.TypeNumeric
		    Return New SettingsListNumberElement(Key)
		  Case Beacon.ConfigKey.ValueTypes.TypeText
		    Return New SettingsListStringElement(Key)
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Document() As Beacon.Document
		  Return RaiseEvent GetDocument()
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Filter() As String
		  Return Self.mFilter
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Filter(Assigns Value As String)
		  // Case in-sensitive is fine
		  If Self.Filter = Value Then
		    Return
		  End If
		  
		  Self.mFilter = Value
		  
		  Var AllKeys() As Beacon.ConfigKey = LocalData.SharedInstance.SearchForConfigKey("", "", "")
		  Var GroupNames() As String
		  Var Groups As New Dictionary
		  Var BuildNumber As Integer = App.BuildNumber
		  Var Filtered As Boolean = Value.IsEmpty = False
		  Var DesiredBound As Integer = -1
		  Var Mods As Beacon.StringList = Self.Document.Mods
		  Var MeasurePic As New Picture(20, 20)
		  MeasurePic.Graphics.FontName = "System"
		  MeasurePic.Graphics.FontSize = 0
		  Var KeyNameWidth As Integer
		  
		  For Each Key As Beacon.ConfigKey In AllKeys
		    If (Key.NativeEditorVersion Is Nil) = False And Key.NativeEditorVersion.IntegerValue <= BuildNumber Then
		      // We have a native editor for this key
		      Continue
		    End If
		    If Key.ValueType = Beacon.ConfigKey.ValueTypes.TypeArray Or Key.ValueType = Beacon.ConfigKey.ValueTypes.TypeStructure Then
		      // Can't support these types
		      Continue
		    End If
		    If Key.MaxAllowed Is Nil Or Key.MaxAllowed.IntegerValue <> 1 Then
		      // Only support single value keys
		      Continue
		    End If
		    If Mods.IndexOf(Key.ModID) = -1 Then
		      // Is this not obvious?
		      Continue
		    End If
		    
		    // See if this key matches the search
		    If Filtered And Key.Label.IndexOf(Value) = -1 And Key.Description.IndexOf(Value) = -1 Then
		      Continue
		    End If
		    
		    Var GroupName As String = Self.EverythingElseGroupName
		    If (Key.UIGroup Is Nil) = False Then
		      GroupName = Key.UIGroup.StringValue
		    End If
		    
		    Var Members() As Beacon.ConfigKey
		    If Groups.HasKey(GroupName) Then
		      Members = Groups.Value(GroupName)
		    Else
		      GroupNames.Add(GroupName)
		    End If
		    Members.Add(Key)
		    Groups.Value(GroupName) = Members
		    
		    KeyNameWidth = Max(KeyNameWidth, MeasurePic.Graphics.TextWidth(Key.Label))
		    
		    DesiredBound = DesiredBound + 1
		  Next Key
		  
		  // The "everything else" group should not be sorted normally. It'll always be at the end.
		  Var EverythingIdx As Integer = GroupNames.IndexOf(Self.EverythingElseGroupName)
		  If EverythingIdx > -1 Then
		    GroupNames.RemoveAt(EverythingIdx)
		  End If
		  GroupNames.Sort
		  If EverythingIdx > -1 Then
		    GroupNames.Add(Self.EverythingElseGroupName)
		  End If
		  
		  Self.mVisibleGroups = GroupNames
		  Self.mVisibleKeys = Groups
		  Self.mKeyNameWidth = KeyNameWidth
		  
		  // Remove elements until the bounds match
		  For Idx As Integer = Self.mElements.LastIndex DownTo Max(DesiredBound, 0)
		    If (Self.mElements(Idx) Is Nil) = False Then
		      Self.mElements(Idx).Close
		      Self.mElements(Idx) = Nil
		    End If
		  Next Idx
		  For Idx As Integer = Self.mGroupHeaders.LastIndex DownTo Max(GroupNames.LastIndex, 0)
		    If (Self.mGroupHeaders(Idx) Is Nil) = False Then
		      Self.mGroupHeaders(Idx).Close
		      Self.mGroupHeaders(Idx) = Nil
		    End If
		  Next Idx
		  
		  Self.mElements.ResizeTo(DesiredBound)
		  Self.mGroupHeaders.ResizeTo(GroupNames.LastIndex)
		  
		  Self.mContentHeight = (Self.mGroupHeaders.Count * Self.HeaderHeight) + (Self.mElements.Count * Self.ElementHeight)
		  Self.SetVisibilities(True)
		  
		  #if false
		    Var ElementWidth As Integer = Self.Width - Self.Scroller.Width
		    Var NextTop As Integer = Self.Scroller.Value * -1
		    Var ElementIdx As Integer
		    For GroupIdx As Integer = 0 To GroupNames.LastIndex
		      Var GroupName As String = GroupNames(GroupIdx)
		      Var CurrentHeader As SettingsListHeader = Self.mGroupHeaders(GroupIdx)
		      If CurrentHeader Is Nil Then
		        CurrentHeader = New SettingsListHeader
		        CurrentHeader.EmbedWithin(Self, 0, NextTop, ElementWidth, Self.HeaderHeight)
		        Self.mGroupHeaders(GroupIdx) = CurrentHeader
		      End If
		      CurrentHeader.Name = GroupName
		      If CurrentHeader.Top <> NextTop Then
		        CurrentHeader.Top = NextTop
		      End If
		      CurrentHeader.Visible = (CurrentHeader.Top + CurrentHeader.Height) > 0 And (CurrentHeader.Top < Self.Height)
		      NextTop = NextTop + Self.HeaderHeight
		      
		      Var Members() As Beacon.ConfigKey = Groups.Value(GroupName)
		      For Each Member As Beacon.ConfigKey In Members
		        Var CurrentElement As SettingsListElement = Self.mElements(ElementIdx)
		        Var CreateNewElement As Boolean
		        If (CurrentElement Is Nil) = False Then
		          Select Case Member.ValueType
		          Case Beacon.ConfigKey.ValueTypes.TypeBoolean
		            CreateNewElement = (CurrentElement IsA SettingsListBooleanElement) = False
		          Case Beacon.ConfigKey.ValueTypes.TypeNumeric
		            CreateNewElement = (CurrentElement IsA SettingsListNumberElement) = False
		          Case Beacon.ConfigKey.ValueTypes.TypeText
		            CreateNewElement = (CurrentElement IsA SettingsListStringElement) = False
		          End Select
		          If CreateNewElement Then
		            CurrentElement.Close
		            Self.mElements(ElementIdx) = Nil
		          End If
		        Else
		          CreateNewElement = True
		        End If
		        
		        If CreateNewElement Then
		          Select Case Member.ValueType
		          Case Beacon.ConfigKey.ValueTypes.TypeBoolean
		            CurrentElement = New SettingsListBooleanElement(Member)
		          Case Beacon.ConfigKey.ValueTypes.TypeNumeric
		            CurrentElement = New SettingsListNumberElement(Member)
		          Case Beacon.ConfigKey.ValueTypes.TypeText
		            CurrentElement = New SettingsListStringElement(Member)
		          End Select
		          CurrentElement.EmbedWithin(Self, 0, NextTop, ElementWidth, Self.ElementHeight)
		          Self.mElements(ElementIdx) = CurrentElement
		        End If
		        
		        CurrentElement.Key = Member
		        If CurrentElement.Top <> NextTop Then
		          CurrentElement.Top = NextTop
		        End If
		        CurrentElement.Visible = (CurrentElement.Top + CurrentElement.Height) > 0 And (CurrentElement.Top < Self.Height)
		        NextTop = NextTop + Self.ElementHeight
		        
		        ElementIdx = ElementIdx + 1
		      Next Member
		    Next GroupIdx
		    
		    Self.Scroller.MaximumValue = Max(NextTop - Self.Height, 0)
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ForceReload()
		  Var Filter As String = Self.Filter
		  Self.mFilter = Crypto.GenerateRandomBytes(8)
		  Self.Filter = Filter
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function IsCorrectElementClass(Element As SettingsListElement, Key As Beacon.ConfigKey) As Boolean
		  Select Case Key.ValueType
		  Case Beacon.ConfigKey.ValueTypes.TypeBoolean
		    Return Element IsA SettingsListBooleanElement
		  Case Beacon.ConfigKey.ValueTypes.TypeNumeric
		    Return Element IsA SettingsListNumberElement
		  Case Beacon.ConfigKey.ValueTypes.TypeText
		    Return Element IsA SettingsListStringElement
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SetVisibilities(Force As Boolean = False)
		  If Force = False And Self.Scroller.Value = Self.mLastScrollPosition And Self.Height = Self.mLastViewHeight Then
		    Return
		  End If
		  
		  Var OverflowHeight As Integer = Max(Self.mContentHeight - Self.Height, 0)
		  Var ScrollPosition As Integer = Min(Max(Self.Scroller.Value, 0), OverflowHeight)
		  Self.mLastViewHeight = Self.Height
		  Self.mLastScrollPosition = ScrollPosition
		  Var NoScrollEvents As Boolean = Self.mNoScrollEvents
		  Self.mNoScrollEvents = True
		  If Self.Scroller.MaximumValue <> OverflowHeight Then
		    Self.Scroller.MaximumValue = OverflowHeight
		  End If
		  If Self.Scroller.Value <> ScrollPosition Then
		    Self.Scroller.Value = ScrollPosition
		  End If
		  If Self.Scroller.PageStep <> Self.Height Then
		    Self.Scroller.PageStep = Self.Height
		  End If
		  Self.mNoScrollEvents = NoScrollEvents
		  
		  If Self.mVisibleKeys Is Nil Or Self.mVisibleKeys.KeyCount = 0 Then
		    Return
		  End If
		  
		  Var NextTop As Integer = ScrollPosition * -1
		  Var ElementIdx As Integer
		  Var ElementWidth As Integer = Self.Width - Self.Scroller.Width
		  For GroupIdx As Integer = 0 To Self.mVisibleGroups.LastIndex
		    Var GroupName As String = Self.mVisibleGroups(GroupIdx)
		    Var Members() As Beacon.ConfigKey = Self.mVisibleKeys.Value(GroupName)
		    
		    Var Header As SettingsListHeader = Self.mGroupHeaders(GroupIdx)
		    Var HeaderTop As Integer = NextTop
		    NextTop = NextTop + Self.HeaderHeight
		    Var HeaderBottom As Integer = NextTop
		    
		    If HeaderBottom > 0 And HeaderTop < Self.Height Then
		      // Needs to be visible
		      If Header Is Nil Then
		        Header = New SettingsListHeader
		        Header.Name = GroupName
		        Header.EmbedWithin(Self, 0, HeaderTop, ElementWidth, Self.HeaderHeight)
		        Header.Visible = True
		        Self.mGroupHeaders(GroupIdx) = Header
		      Else
		        If Header.Name <> GroupName Then
		          Header.Name = GroupName
		        End If
		        If Header.Visible = False Then
		          Header.Visible = True
		        End If
		        If Header.Top <> HeaderTop Then
		          Header.Top = HeaderTop
		        End If
		      End If
		    ElseIf (Header Is Nil) = False And Header.Visible = True Then
		      Header.Visible = False
		    End If
		    
		    For Each Member As Beacon.ConfigKey In Members
		      Var Element As SettingsListElement = Self.mElements(ElementIdx)
		      Var ElementTop As Integer = NextTop
		      NextTop = NextTop + Self.ElementHeight
		      Var ElementBottom As Integer = NextTop
		      
		      If ElementBottom > 0 And ElementTop < Self.Height Then
		        If (Element Is Nil) = False And Self.IsCorrectElementClass(Element, Member) = False Then
		          Element.Close
		          Element = Nil
		          Self.mElements(ElementIdx) = Nil
		        End If
		        If Element Is Nil Then
		          Element = Self.CreateElement(Member)
		          Element.EmbedWithin(Self, 0, ElementTop, ElementWidth, Self.ElementHeight)
		          Element.Visible = True
		          Self.mElements(ElementIdx) = Element
		        Else
		          If Element.Visible = False Then
		            Element.Visible = True
		          End If
		          If Element.Top <> ElementTop Then
		            Element.Top = ElementTop
		          End If
		        End If
		        If Element.KeyNameWidth <> Self.mKeyNameWidth Then
		          Element.KeyNameWidth = Self.mKeyNameWidth
		        End If
		      ElseIf (Element Is Nil) = False And Element.Visible = True Then
		        Element.Visible = False
		      End If
		      
		      ElementIdx = ElementIdx + 1
		    Next Member
		  Next GroupIdx
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event GetDocument() As Beacon.Document
	#tag EndHook

	#tag Hook, Flags = &h0
		Event ValueChanged(Key As Beacon.ConfigKey, NewValue As Variant)
	#tag EndHook


	#tag Property, Flags = &h21
		Private mContentHeight As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mElements() As SettingsListElement
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mFilter As String = "a51899b2-14cf-4014-b8f7-b94ada6c5923"
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mGroupHeaders() As SettingsListHeader
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mKeyNameWidth As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLastScrollPosition As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLastViewHeight As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mNoScrollEvents As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mVisibleGroups() As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mVisibleKeys As Dictionary
	#tag EndProperty


	#tag Constant, Name = ElementHeight, Type = Double, Dynamic = False, Default = \"62", Scope = Private
	#tag EndConstant

	#tag Constant, Name = EverythingElseGroupName, Type = String, Dynamic = False, Default = \"Everything Else", Scope = Private
	#tag EndConstant

	#tag Constant, Name = HeaderHeight, Type = Double, Dynamic = False, Default = \"30", Scope = Private
	#tag EndConstant


#tag EndWindowCode

#tag Events Scroller
	#tag Event
		Sub ValueChanged()
		  If Self.mNoScrollEvents Then
		    Return
		  End If
		  
		  Self.SetVisibilities()
		End Sub
	#tag EndEvent
	#tag Event
		Sub Open()
		  Me.LineStep = Self.ElementHeight
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
		Name="Width"
		Visible=true
		Group="Size"
		InitialValue="300"
		Type="Integer"
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
		InitialValue="0"
		Type="Integer"
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
		Name="LockLeft"
		Visible=true
		Group="Position"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="LockTop"
		Visible=true
		Group="Position"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="LockRight"
		Visible=true
		Group="Position"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="LockBottom"
		Visible=true
		Group="Position"
		InitialValue="False"
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
		Name="AllowAutoDeactivate"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
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
		Name="Tooltip"
		Visible=true
		Group="Appearance"
		InitialValue=""
		Type="String"
		EditorType="MultiLineEditor"
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
		Name="Visible"
		Visible=true
		Group="Appearance"
		InitialValue="True"
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
		Name="Backdrop"
		Visible=true
		Group="Background"
		InitialValue=""
		Type="Picture"
		EditorType=""
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
		Name="EraseBackground"
		Visible=false
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
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
		Name="DoubleBuffer"
		Visible=true
		Group="Windows Behavior"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
#tag EndViewBehavior
