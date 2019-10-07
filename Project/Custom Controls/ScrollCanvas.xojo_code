#tag Class
Protected Class ScrollCanvas
Inherits TextInputCanvas
Implements AnimationKit.ValueAnimator
	#tag Event
		Function MouseDown(x as Integer, y as Integer) As Boolean
		  Return RaiseEvent MouseDown(X, Y)
		End Function
	#tag EndEvent

	#tag Event
		Sub MouseDrag(x as Integer, y as Integer)
		  RaiseEvent MouseDrag(X, Y)
		End Sub
	#tag EndEvent

	#tag Event
		Sub MouseEnter()
		  RaiseEvent MouseEnter
		End Sub
	#tag EndEvent

	#tag Event
		Sub MouseExit()
		  RaiseEvent MouseExit
		End Sub
	#tag EndEvent

	#tag Event
		Sub MouseMove(X As Integer, Y As Integer)
		  RaiseEvent MouseMove(X, Y)
		End Sub
	#tag EndEvent

	#tag Event
		Sub MouseUp(x as Integer, y as Integer)
		  RaiseEvent MouseUp(X, Y)
		End Sub
	#tag EndEvent

	#tag Event
		Function MouseWheel(X As Integer, Y As Integer, deltaX as Integer, deltaY as Integer) As Boolean
		  Dim WheelData As New BeaconUI.ScrollEvent(Self.ScrollSpeed, DeltaX, DeltaY)
		  If RaiseEvent MouseWheel(X, Y, WheelData) Then
		    Return True
		  End If
		  If WheelData.Phase = BeaconUI.ScrollEvent.PhaseMayBegin Then
		    // The user has rested fingers on the trackpad, so light up the scrollers
		    Self.RunAnimation(Self.HorizontalOpacityKey, 1.0)
		    Self.RunAnimation(Self.VerticalOpacityKey, 1.0)
		  ElseIf WheelData.Phase = BeaconUI.ScrollEvent.PhaseNone Then
		    // The scroll has stopped completely, but this should really fade the scrollers after a couple seconds
		    //Self.RunAnimation(Self.HorizontalOpacityKey, 0.0)
		    //Self.RunAnimation(Self.VerticalOpacityKey, 0.0)
		  End If
		  Self.ScrollX = Self.mScrollX + WheelData.ScrollX
		  Self.ScrollY = Self.mScrollY + WheelData.ScrollY
		  If WheelData.Phase = BeaconUI.ScrollEvent.PhaseNone Then
		    If Self.mScrollX < 0 Then
		      Self.RunAnimation(Self.HorizontalPositionKey, 0)
		    ElseIf Self.mScrollX > Self.OverflowWidth Then
		      Self.RunAnimation(Self.HorizontalPositionKey, Self.OverflowWidth)
		    End If
		    If Self.mScrollY < 0 Then
		      Self.RunAnimation(Self.VerticalPositionKey, 0)
		    ElseIf Self.mScrollY > Self.OverflowHeight  Then
		      Self.RunAnimation(Self.VerticalPositionKey, Self.OverflowHeight)
		    End If
		  End If
		  Return True
		End Function
	#tag EndEvent

	#tag Event
		Sub Opening()
		  RaiseEvent Opening()
		  Self.RefreshGutters()
		End Sub
	#tag EndEvent

	#tag Event
		Sub Paint(g as Graphics, areas() as object)
		  Self.mInsidePaintEvent = True
		  RaiseEvent Paint(G, Areas)
		  Self.mInsidePaintEvent = False
		  
		  Const ScrollerBaseSize = 11
		  Const ScrollerExpandedSize = 15
		  Const MinThumbSize = 20
		  
		  If Self.mHorizontalScrollOpacity > 0 Then
		    Dim TrackHeight As Integer = ScrollerBaseSize + ((ScrollerExpandedSize - ScrollerBaseSize) * Self.mHorizontalScrollScale)
		    Dim TrackRect As New Xojo.Rect(Self.ViewportLeft, Self.ViewportBottom - TrackHeight, Self.ViewportWidth, TrackHeight)
		    Dim ContentWidth As Integer = Self.ContentWidth
		    If Self.ScrollX < 0 Then
		      ContentWidth = ContentWidth + Abs(Self.ScrollX)
		    End If
		    Dim ViewableRatio As Double = Self.ViewportWidth / ContentWidth
		    Dim ThumbWidth As Integer = Max(Round(TrackRect.Width * ViewableRatio), MinThumbSize)
		    Dim ThumbLeft As Integer = (TrackRect.Width - ThumbWidth) * Max(Min(Self.ScrollX / Self.OverflowWidth, 1), 0)
		    Dim ThumbRect As New Xojo.Rect(TrackRect.Left + ThumbLeft, TrackRect.Top, ThumbWidth, TrackRect.Height)
		    RaiseEvent PaintScrollbar(G, False, TrackRect, ThumbRect, Self.mHorizontalScrollOpacity)
		  End If
		  
		  If Self.mVerticalScrollOpacity > 0 Then
		    Dim TrackWidth As Integer = ScrollerBaseSize + ((ScrollerExpandedSize - ScrollerBaseSize) * Self.mVerticalScrollScale)
		    Dim TrackRect As New Xojo.Rect(Self.ViewportRight - TrackWidth, Self.ViewportTop, TrackWidth, Self.ViewportHeight)
		    Dim ViewableRatio As Double = Self.ViewportHeight / Self.ContentHeight
		    Dim ThumbHeight As Integer = Max(Round(TrackRect.Height * ViewableRatio), MinThumbSize)
		    Dim ThumbTop As Integer = (TrackRect.Height - ThumbHeight) * Max(Min(Self.ScrollY / Self.OverflowHeight, 1), 0)
		    Dim ThumbRect As New Xojo.Rect(TrackRect.Left, TrackRect.Top + ThumbTop, TrackRect.Width, ThumbHeight)
		    RaiseEvent PaintScrollbar(G, True, TrackRect, ThumbRect, Self.mVerticalScrollOpacity)
		  End If
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Sub AnimationStep(Identifier As String, Value As Double)
		  // Part of the AnimationKit.ValueAnimator interface.
		  
		  Select Case Identifier
		  Case Self.VerticalPositionKey
		    Self.mScrollY = Round(Value)
		  Case Self.VerticalOpacityKey
		    Self.mVerticalScrollOpacity = Value
		  Case Self.VerticalScaleKey
		    Self.mVerticalScrollScale = Value
		  Case Self.HorizontalPositionKey
		    Self.mScrollX = Round(Value)
		  Case Self.HorizontalOpacityKey
		    Self.mHorizontalScrollOpacity = Value
		  Case Self.HorizontalScaleKey
		    Self.mHorizontalScrollScale = Value
		  Else
		    Return
		  End Select
		  
		  Self.Invalidate
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function CalculateResistance(DistanceFromEdge As Integer, ViewportDimension As Integer) As Integer
		  Return (1.0 - (1.0 / ((DistanceFromEdge * 0.05 / ViewportDimension) + 1.0))) * ViewportDimension
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  #if TargetMacOS
		    Self.mHorizontalScrollOpacity = 0
		    Self.mHorizontalScrollScale = 0
		    Self.mVerticalScrollOpacity = 0
		    Self.mVerticalScrollScale = 0
		  #else
		    Self.mHorizontalScrollOpacity = 1
		    Self.mHorizontalScrollScale = 1
		    Self.mVerticalScrollOpacity = 1
		    Self.mVerticalScrollScale = 1
		  #endif
		  Super.Constructor
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Invalidate(EraseBackground As Boolean = True)
		  #Pragma Unused EraseBackground
		  Super.Invalidate(False)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Invalidate(X As Integer, Y As Integer, Width As Integer, Height As Integer, EraseBackground As Boolean = True)
		  #Pragma Unused EraseBackground
		  Super.Invalidate(X, Y, Width, Height, False)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function Log10(Value As Double) As Double
		  Return Log(Value) / Log(10)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Refresh(EraseBackground As Boolean = True)
		  #Pragma Unused EraseBackground
		  Super.Refresh(False)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RefreshGutters()
		  Dim LeftGutter, TopGutter, RightGutter, BottomGutter As Integer
		  RaiseEvent SetupGutters(LeftGutter, TopGutter, RightGutter, BottomGutter)
		  Dim NeedsInvalidation As Boolean
		  If Self.mLeftGutter <> LeftGutter Then
		    Self.mLeftGutter = LeftGutter
		    NeedsInvalidation = True
		  End If
		  If Self.mTopGutter <> TopGutter Then
		    Self.mTopGutter = TopGutter
		    NeedsInvalidation = True
		  End If
		  If Self.mRightGutter <> RightGutter Then
		    Self.mRightGutter = RightGutter
		    NeedsInvalidation = True
		  End If
		  If Self.mBottomGutter <> BottomGutter Then
		    Self.mBottomGutter = BottomGutter
		    NeedsInvalidation = True
		  End If
		  If NeedsInvalidation Then
		    Self.Invalidate
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RefreshRect(X As Integer, Y As Integer, Width As Integer, Height As Integer, EraseBackground As Boolean = True)
		  #Pragma Unused EraseBackground
		  Super.RefreshRect(X, Y, Width, Height, False)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RunAnimation(Identifier As String, NewValue As Double, Duration As Double = 0.15)
		  If Self.mAnimations = Nil Then
		    Self.mAnimations = New Dictionary
		  End If
		  If Self.mAnimations.HasKey(Identifier) Then
		    Dim Task As AnimationKit.ValueTask = Self.mAnimations.Value(Identifier)
		    Task.Cancel
		    Self.mAnimations.Remove(Identifier)
		  End If
		  
		  // Don't animate scrollbars that aren't needed
		  If (Identifier.BeginsWith("Vertical") And Self.OverflowHeight = 0) Or (Identifier.BeginsWith("Horizontal") And Self.OverflowWidth = 0) Then
		    Return
		  End If
		  
		  Dim StartValue As Double
		  
		  Select Case Identifier
		  Case Self.VerticalPositionKey
		    StartValue = Self.mScrollY
		  Case Self.HorizontalPositionKey
		    StartValue = Self.mScrollX
		    #if TargetMacOS
		  Case Self.VerticalOpacityKey
		    StartValue = Self.mVerticalScrollOpacity
		  Case Self.VerticalScaleKey
		    StartValue = Self.mVerticalScrollScale
		  Case Self.HorizontalOpacityKey
		    StartValue = Self.mHorizontalScrollOpacity
		  Case Self.HorizontalScaleKey
		    StartValue = Self.mHorizontalScrollScale
		    #endif
		  Else
		    Return
		  End Select
		  
		  If StartValue = NewValue Then
		    Return
		  End If
		  
		  Dim Task As New AnimationKit.ValueTask(Self, Identifier, StartValue, NewValue)
		  Task.DurationInSeconds = Duration
		  Task.Curve = AnimationKit.Curve.CreateEaseOut
		  Self.mAnimations.Value(Identifier) = Task
		  Task.Run
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ScrollX() As Integer
		  Dim Overflow As Integer = Self.OverflowWidth
		  If Overflow <= 0 Then
		    Return 0
		  End If
		  
		  If Self.mScrollX < 0 Then
		    Return Self.CalculateResistance(Abs(Self.mScrollX), Self.ViewportWidth) * -1
		  ElseIf Self.mScrollX > Overflow Then
		    Return Self.CalculateResistance(Self.mScrollX - Overflow, Self.ViewportWidth) + Overflow
		  Else
		    Return Self.mScrollX
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ScrollX(Animated As Boolean = False, Assigns Value As Integer)
		  If Self.mScrollX <> Value Then
		    If Animated Then
		      Self.RunAnimation(Self.HorizontalPositionKey, Value)
		    Else
		      Self.mScrollX = Value
		      If Not Self.mInsidePaintEvent Then
		        Self.Invalidate
		      End If
		    End If
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ScrollY() As Integer
		  Dim Overflow As Integer = Self.OverflowHeight
		  If Overflow <= 0 Then
		    Return 0
		  End If
		  
		  If Self.mScrollY < 0 Then
		    Return Self.CalculateResistance(Abs(Self.mScrollY), Self.ViewportHeight) * -1
		  ElseIf Self.mScrollY > Overflow Then
		    Return Self.CalculateResistance(Self.mScrollY - Overflow, Self.ViewportHeight) + Overflow
		  Else
		    Return Self.mScrollY
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ScrollY(Animated As Boolean = False, Assigns Value As Integer)
		  If Self.mScrollY <> Value Then
		    If Animated Then
		      Self.RunAnimation(Self.VerticalPositionKey, Value)
		    Else
		      Self.mScrollY = Value
		      If Not Self.mInsidePaintEvent Then
		        Self.Invalidate
		      End If
		    End If
		  End If
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event MouseDown(x as Integer, y as Integer) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event MouseDrag(x as Integer, y as Integer)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event MouseEnter()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event MouseExit()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event MouseMove(X As Integer, Y As Integer)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event MouseUp(x as Integer, y as Integer)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event MouseWheel(X As Integer, Y As Integer, WheelData As BeaconUI.ScrollEvent) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Opening()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Paint(G As Graphics, Areas() As Object)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event PaintScrollbar(G As Graphics, Vertical As Boolean, TrackRect As Xojo.Rect, ThumbRect As Xojo.Rect, Opacity As Double)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event SetupGutters(ByRef LeftGutter As Integer, ByRef TopGutter As Integer, ByRef RightGutter As Integer, ByRef BottomGutter As Integer)
	#tag EndHook


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mContentHeight
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Value = Max(Value, 0)
			  If Self.mContentHeight <> Value Then
			    Self.mContentHeight = Value
			    If Not Self.mInsidePaintEvent Then
			      Self.Invalidate
			    End If
			  End If
			End Set
		#tag EndSetter
		ContentHeight As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mContentWidth
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Value = Max(Value, 0)
			  If Self.mContentWidth <> Value Then
			    Self.mContentWidth = Value
			    If Not Self.mInsidePaintEvent Then
			      Self.Invalidate
			    End If
			  End If
			End Set
		#tag EndSetter
		ContentWidth As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mAnimations As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mBottomGutter As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mContentHeight As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mContentWidth As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mHorizontalScrollOpacity As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mHorizontalScrollScale As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mInsidePaintEvent As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLeftGutter As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mRightGutter As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mScrollX As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mScrollY As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTopGutter As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mVerticalScrollOpacity As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mVerticalScrollScale As Double
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Max(Self.ContentHeight - Self.ViewportHeight, 0)
			End Get
		#tag EndGetter
		OverflowHeight As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Max(Self.ContentWidth - Self.ViewportWidth, 0)
			End Get
		#tag EndGetter
		OverflowWidth As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		ScrollSpeed As Integer
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.Height - Self.mBottomGutter
			End Get
		#tag EndGetter
		ViewportBottom As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.Height - (Self.mTopGutter + Self.mBottomGutter)
			End Get
		#tag EndGetter
		ViewportHeight As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mLeftGutter
			End Get
		#tag EndGetter
		ViewportLeft As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.Width - Self.mRightGutter
			End Get
		#tag EndGetter
		ViewportRight As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mTopGutter
			End Get
		#tag EndGetter
		ViewportTop As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.Width - (Self.mLeftGutter + Self.mRightGutter)
			End Get
		#tag EndGetter
		ViewportWidth As Integer
	#tag EndComputedProperty


	#tag Constant, Name = HorizontalOpacityKey, Type = String, Dynamic = False, Default = \"HorizontalOpacity", Scope = Private
	#tag EndConstant

	#tag Constant, Name = HorizontalPositionKey, Type = String, Dynamic = False, Default = \"HorizontalPosition", Scope = Private
	#tag EndConstant

	#tag Constant, Name = HorizontalScaleKey, Type = String, Dynamic = False, Default = \"HorizontalScale", Scope = Private
	#tag EndConstant

	#tag Constant, Name = VerticalOpacityKey, Type = String, Dynamic = False, Default = \"VerticalOpacity", Scope = Private
	#tag EndConstant

	#tag Constant, Name = VerticalPositionKey, Type = String, Dynamic = False, Default = \"VerticalPosition", Scope = Private
	#tag EndConstant

	#tag Constant, Name = VerticalScaleKey, Type = String, Dynamic = False, Default = \"VerticalScale", Scope = Private
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="Integer"
			EditorType="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Integer"
			EditorType="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Integer"
			EditorType="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Width"
			Visible=true
			Group="Position"
			InitialValue="100"
			Type="Integer"
			EditorType="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Height"
			Visible=true
			Group="Position"
			InitialValue="100"
			Type="Integer"
			EditorType="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockLeft"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Boolean"
			EditorType="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockTop"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Boolean"
			EditorType="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockRight"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Boolean"
			EditorType="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockBottom"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Boolean"
			EditorType="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabPanelIndex"
			Visible=false
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabIndex"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabStop"
			Visible=true
			Group="Position"
			InitialValue="True"
			Type="Boolean"
			EditorType="Boolean"
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
			Name="Visible"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="HelpTag"
			Visible=true
			Group="Appearance"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AutoDeactivate"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Enabled"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ScrollSpeed"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ContentWidth"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ContentHeight"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ViewportWidth"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ViewportHeight"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ViewportTop"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ViewportLeft"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ViewportRight"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ViewportBottom"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="OverflowWidth"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="OverflowHeight"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
