#tag Class
Protected Class BeaconCodeEditor
Inherits TextInputCanvas
	#tag Event
		Function FontNameAtLocation(location as integer) As string
		  #Pragma Unused Location
		  Return "Source Code Pro"
		End Function
	#tag EndEvent

	#tag Event
		Function FontSizeAtLocation(location as integer) As integer
		  #Pragma Unused Location
		  Return 12
		End Function
	#tag EndEvent

	#tag Event
		Sub InsertText(text as string, range as TextRange)
		  Self.InsertText(Text, Range.Location, Range.Length)
		End Sub
	#tag EndEvent

	#tag Event
		Sub Paint(g as Graphics, areas() as object)
		  Dim Start As Double = Microseconds
		  Dim CurrentTheme As BeaconCodeTheme
		  If SystemColors.IsDarkMode Then
		    CurrentTheme = New BeaconCodeTheme(&c17171700, &cFFFFFF00, &cFC5FA200, &c6C798500, &c98E7D400, &c98E7D400, &c9586F400, &c9586F400, &c6C798500, &cFC8E3E00)
		  Else
		    CurrentTheme = New BeaconCodeTheme(&cFFFFFF00, &c00000000, &c9A239200, &c3F4F6100, &c3900A000, &c3900A000, &c1C00CE00, &c1C00CE00, &c52657900, &c63381F00)
		  End If
		  If Self.mLastTheme = Nil Or G.ScaleX <> Self.mLastScaleX Or G.ScaleY <> Self.mLastScaleY Or Self.mLastTheme.Matches(CurrentTheme) = False Then
		    For I As Integer = 0 To Self.mContentLines.Ubound
		      Self.mContentLines(I).Invalidate()
		    Next
		  End If
		  
		  Self.mLastTheme = CurrentTheme
		  Self.mLastScaleX = G.ScaleX
		  Self.mLastScaleY = G.ScaleY
		  
		  G.ForeColor = CurrentTheme.BackgroundColor
		  G.FillRect(0, 0, G.Width, G.Height)
		  G.ForeColor = CurrentTheme.PlainTextColor.AtOpacity(0.05)
		  G.FillRect(0, 0, 40, G.Height)
		  G.ForeColor = CurrentTheme.PlainTextColor.AtOpacity(0.3)
		  G.FillRect(40, 0, 1, G.Height)
		  
		  G.TextFont = "Source Code Pro"
		  G.TextSize = 12
		  G.TextUnit = FontUnits.Point
		  
		  Self.mLineHeight = Ceil(G.TextHeight * 1.2)
		  Self.mBaselineHeight = Ceil((((G.TextHeight * 1.2) - G.CapHeight) / 2) + G.CapHeight)
		  
		  Dim LineTop As Integer = Self.mScrollY * -1
		  Dim Area As Graphics = G.Clip(41, 0, G.Width - 41, G.Height)
		  Dim Gutter As Graphics = G.Clip(0, 0, 39, G.Height)
		  Dim Ascent As Integer = Ceil(G.CapHeight)
		  Area.ForeColor = CurrentTheme.PlainTextColor
		  Gutter.ForeColor = Area.ForeColor.AtOpacity(0.5)
		  Gutter.TextSize = 10
		  For I As Integer = 0 To Self.mContentLines.Ubound
		    Dim LineBottom As Integer = LineTop + Self.mLineHeight
		    If LineBottom < 0 Or LineTop > G.Height Then
		      Continue
		    End If
		    
		    Dim Line As BeaconCodeLine = Self.mContentLines(I)
		    Line.Render(Area, New REALbasic.Rect(0, LineTop, Area.Width, Self.mLineHeight), CurrentTheme, 5, Self.mBaselineHeight)
		    
		    Dim LineNum As String = Str(I + 1, "0")
		    Gutter.DrawString(LineNum, Gutter.Width - (Gutter.StringWidth(LineNum) + 2), LineTop + Self.mBaselineHeight)
		    
		    LineTop = LineTop + Self.mLineHeight
		  Next
		  //System.DebugLog(Str((Microseconds - Start) * 0.001, "0") + "ms to paint")
		End Sub
	#tag EndEvent

	#tag Event
		Function SelectedRange() As TextRange
		  Return New TextRange(Self.mSelStart, Self.mSelLength)
		End Function
	#tag EndEvent

	#tag Event
		Function TextForRange(range as TextRange) As string
		  Return Mid(Self.mContent, Range.Location + 1, Range.Length)
		End Function
	#tag EndEvent

	#tag Event
		Function TextLength() As integer
		  Return Len(Self.mContent)
		End Function
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Sub InsertText(NewText As String, StartPosition As UInteger, Length As UInteger)
		  Dim LeftChunk As String = Left(Self.mContent, StartPosition)
		  Dim RightChunk As String = Mid(Self.mContent, StartPosition + Length + 1)
		  Self.mContent = LeftChunk + NewText + RightChunk
		End Sub
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mContent
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If StrComp(Self.mContent, Value, 0) <> 0 Then
			    Self.mContent = Value
			    
			    Dim EOL As String = Encodings.ASCII.Chr(10)
			    Dim NewLines() As String = Split(ReplaceLineEndings(Value, EOL), EOL)
			    Dim Dict As New Dictionary
			    For I As Integer = 0 To Self.mContentLines.Ubound
			      Dict.Value(Self.mContentLines(I).Content) = I
			    Next
			    
			    Dim NewContentLines() As BeaconCodeLine
			    For I As Integer = 0 To NewLines.Ubound
			      Dim OldIdx As Integer = Dict.Lookup(NewLines(I), -1)
			      If OldIdx = -1 Then
			        NewContentLines.Append(New BeaconCodeLine(NewLines(I)))
			      Else
			        NewContentLines.Append(Self.mContentLines(OldIdx))
			      End If
			    Next
			    Self.mContentLines = NewContentLines
			    
			    Self.Invalidate()
			  End If
			End Set
		#tag EndSetter
		Content As String
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mBaselineHeight As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mContent As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mContentLines() As BeaconCodeLine
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLastScaleX As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLastScaleY As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLastTheme As BeaconCodeTheme
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLineHeight As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mScrollX As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mScrollY As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSelLength As UInteger
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSelStart As UInteger
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  If Self.mSelLength = 0 Then
			    Return ""
			  End If
			  
			  Return Mid(Self.mContent, Self.mSelStart + 1, Self.mSelLength)
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Self.InsertText(Value, Self.mSelStart, Self.mSelLength)
			  Self.mSelLength = Len(Value)
			End Set
		#tag EndSetter
		SelContent As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mSelStart + Self.mSelLength
			End Get
		#tag EndGetter
		SelEnd As UInteger
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mSelLength
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If Self.mSelLength <> Value Then
			    Self.mSelLength = Value
			    Self.Invalidate
			  End If
			End Set
		#tag EndSetter
		SelLength As UInteger
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mSelStart
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If Self.mSelStart <> Value Then
			    Self.mSelStart = Value
			    Self.Invalidate
			  End If
			End Set
		#tag EndSetter
		SelStart As UInteger
	#tag EndComputedProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
			EditorType="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			Type="Integer"
			EditorType="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
			EditorType="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			Type="Integer"
			EditorType="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
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
			Type="Boolean"
			EditorType="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockTop"
			Visible=true
			Group="Position"
			Type="Boolean"
			EditorType="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockRight"
			Visible=true
			Group="Position"
			Type="Boolean"
			EditorType="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockBottom"
			Visible=true
			Group="Position"
			Type="Boolean"
			EditorType="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabPanelIndex"
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
			Group="Position"
			Type="String"
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
			Name="Content"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SelStart"
			Group="Behavior"
			Type="UInteger"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SelLength"
			Group="Behavior"
			Type="UInteger"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SelContent"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SelEnd"
			Group="Behavior"
			Type="UInteger"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
