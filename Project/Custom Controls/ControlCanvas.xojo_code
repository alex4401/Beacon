#tag Class
Protected Class ControlCanvas
Inherits Canvas
Implements BeaconUI.ProfileAnimator,NotificationKit.Receiver
	#tag Event
		Sub Close()
		  RaiseEvent Close
		  
		  NotificationKit.Ignore(Self, BeaconUI.PrimaryColorNotification)
		End Sub
	#tag EndEvent

	#tag Event
		Function MouseWheel(X As Integer, Y As Integer, deltaX as Integer, deltaY as Integer) As Boolean
		  Dim WheelData As New BeaconUI.ScrollEvent(Self.ScrollSpeed, DeltaX, DeltaY)
		  Return MouseWheel(X, Y, WheelData.ScrollX, WheelData.ScrollY, WheelData)
		End Function
	#tag EndEvent

	#tag Event
		Sub Open()
		  NotificationKit.Watch(Self, BeaconUI.PrimaryColorNotification)
		  Self.mColorProfile = BeaconUI.ColorProfile
		  
		  RaiseEvent Open
		  
		  #if XojoVersion >= 2018.01
		    Self.DoubleBuffer = False
		    Self.Transparent = TargetMacOS
		  #else
		    Self.DoubleBuffer = TargetWin32
		    Self.Transparent = Not Self.DoubleBuffer
		    Self.EraseBackground = Not Self.DoubleBuffer
		  #endif
		End Sub
	#tag EndEvent

	#tag Event
		Sub Paint(g As Graphics, areas() As REALbasic.Rect)
		  If Not Self.Transparent Then
		    Dim TempColor As Color = G.ForeColor
		    If Self.Window.HasBackColor Then
		      G.ForeColor = Self.Window.BackColor
		    Else
		      G.ForeColor = FillColor
		    End If
		    G.FillRect(0, 0, G.Width, G.Height)
		    G.ForeColor = TempColor
		  End If
		  
		  RaiseEvent Paint(g, areas)
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub AnimationStep(Identifier As Text, Profile As BeaconUI.ColorProfile)
		  // Part of the BeaconUI.ProfileAnimator interface.
		  
		  Select Case Identifier
		  Case "ColorProfile"
		    Self.mColorProfile = Profile
		    Self.Invalidate
		  End Select
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ColorProfile() As BeaconUI.ColorProfile
		  Return Self.mColorProfile
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Invalidate(eraseBackground As Boolean = True)
		  #if XojoVersion >= 2018.01
		    Super.Invalidate(EraseBackground)
		  #else
		    #Pragma Unused eraseBackground
		    Super.Invalidate(Self.EraseBackground)
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Invalidate(x As Integer, y As Integer, width As Integer, height As Integer, eraseBackground As Boolean = True)
		  #if XojoVersion >= 2018.01
		    Super.Invalidate(X, Y, Width, Height, EraseBackground)
		  #else
		    #Pragma Unused eraseBackground
		    Super.Invalidate(X, Y, Width, Height, Self.EraseBackground)
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub NotificationKit_NotificationReceived(Notification As NotificationKit.Notification)
		  // Part of the NotificationKit.Receiver interface.
		  
		  Select Case Notification.Name
		  Case BeaconUI.PrimaryColorNotification
		    If Self.mProfileAnimator <> Nil Then
		      Self.mProfileAnimator.Cancel
		      Self.mProfileAnimator = Nil
		    End If
		    
		    Dim NewProfile As BeaconUI.ColorProfile = Notification.UserData
		    If Self.mColorProfile <> NewProfile Then
		      Self.mProfileAnimator = New BeaconUI.ProfileTask(Self, "ColorProfile", Self.mColorProfile, NewProfile)
		      Self.mProfileAnimator.Run
		    End If
		  End Select
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Refresh(eraseBackground As Boolean = True)
		  #if XojoVersion >= 2018.01
		    Super.Refresh(EraseBackground)
		  #else
		    #Pragma Unused eraseBackground
		    Super.Refresh(Self.EraseBackground)
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RefreshRect(x As Integer, y As Integer, width As Integer, height As Integer, eraseBackground As Boolean = True)
		  #if XojoVersion >= 2018.01
		    Super.RefreshRect(X, Y, Width, Height, EraseBackground)
		  #else
		    #Pragma Unused eraseBackground
		    Super.RefreshRect(X, Y, Width, Height, Self.EraseBackground)
		  #endif
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event Close()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event MouseWheel(MouseX As Integer, MouseY As Integer, PixelsX As Integer, PixelsY As Integer, WheelData As BeaconUI.ScrollEvent) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Open()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Paint(g As Graphics, areas() As REALbasic.Rect)
	#tag EndHook


	#tag Property, Flags = &h21
		Private mColorProfile As BeaconUI.ColorProfile
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mProfileAnimator As BeaconUI.ProfileTask
	#tag EndProperty

	#tag Property, Flags = &h0
		ScrollSpeed As Integer = 20
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="AcceptFocus"
			Visible=true
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AcceptTabs"
			Visible=true
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AutoDeactivate"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Backdrop"
			Visible=true
			Group="Appearance"
			Type="Picture"
			EditorType="Picture"
		#tag EndViewProperty
		#tag ViewProperty
			Name="DoubleBuffer"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Enabled"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="EraseBackground"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Height"
			Visible=true
			Group="Position"
			InitialValue="100"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="HelpTag"
			Visible=true
			Group="Appearance"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			Type="Integer"
			EditorType="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="InitialParent"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockBottom"
			Visible=true
			Group="Position"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockLeft"
			Visible=true
			Group="Position"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockRight"
			Visible=true
			Group="Position"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockTop"
			Visible=true
			Group="Position"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
			EditorType="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
			EditorType="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabIndex"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabPanelIndex"
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabStop"
			Visible=true
			Group="Position"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Transparent"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="UseFocusRing"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Visible"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Width"
			Visible=true
			Group="Position"
			InitialValue="100"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
