#tag Class
Protected Class BeaconCodeLine
	#tag Method, Flags = &h0
		Sub Constructor()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(Content As String)
		  Self.Constructor()
		  Self.mContent = Content
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Invalidate()
		  Self.mCachedPic = Nil
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function IsValueNumeric(Value As String) As Boolean
		  Static NumberMatcher As Regex
		  If NumberMatcher = Nil Then
		    NumberMatcher = New Regex
		    NumberMatcher.SearchPattern = "^\d+(\.\d+)?$"
		  End If
		  
		  Return NumberMatcher.Search(Value) <> Nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Convert() As String
		  Return Self.mContent
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Operator_Convert(Source As String)
		  Self.Constructor(Source)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Render(G As Graphics, Rect As REALbasic.Rect, Theme As BeaconCodeTheme, OffsetX As Integer, OffsetY As Integer)
		  Static KeywordMatcher As Regex
		  If KeywordMatcher = Nil Then
		    KeywordMatcher = New Regex
		    KeywordMatcher.SearchPattern = "^([a-zA-Z0-9_]+)(\[(\d+)\])?=(.+)$"
		  End If
		  
		  If Self.mCachedPic = Nil Or Self.mCachedPic.Width <> Rect.Width * G.ScaleX Or Self.mCachedPic.Height <> Rect.Height * G.ScaleY Then
		    Dim StartTime As Double = Microseconds
		    Dim Pic As New Picture(Rect.Width * G.ScaleX, Rect.Height * G.ScaleY)
		    Pic.HorizontalResolution = 72 * G.ScaleX
		    Pic.VerticalResolution = 72 * G.ScaleY
		    Pic.Graphics.ScaleX = G.ScaleX
		    Pic.Graphics.ScaleY = G.ScaleY
		    Pic.Graphics.TextFont = G.TextFont
		    Pic.Graphics.TextSize = G.TextSize
		    Pic.Graphics.TextUnit = G.TextUnit
		    
		    Dim KeywordMatches As RegexMatch = KeywordMatcher.Search(Self.mContent)
		    
		    If Self.mContent.BeginsWith("[") And Self.mContent.EndsWith("]") Then
		      Pic.Graphics.ForeColor = Theme.MarkupColor
		      Pic.Graphics.DrawString(Self.mContent, OffsetX, OffsetY)
		    ElseIf Self.mContent.BeginsWith("//") Then
		      Pic.Graphics.ForeColor = Theme.CommentColor
		      Pic.Graphics.DrawString(Self.mContent, OffsetX, OffsetY)
		    ElseIf Self.mContent.BeginsWith("#") Then
		      Pic.Graphics.ForeColor = Theme.PragmaColor
		      Pic.Graphics.DrawString(Self.mContent, OffsetX, OffsetY)
		    ElseIf KeywordMatches <> Nil Then
		      Dim Keyword As String = KeywordMatches.SubExpressionString(1)
		      Dim KeywordParameter As String = If(KeywordMatches.SubExpressionCount > 2, KeywordMatches.SubExpressionString(3), "")
		      Dim ValuePart As String = Keywordmatches.SubExpressionString(4)
		      
		      Dim Offset As Double
		      Pic.Graphics.ForeColor = Theme.KeywordColor
		      Pic.Graphics.DrawString(Keyword, OffsetX, OffsetY)
		      Offset = Pic.Graphics.StringWidth(Keyword)
		      If KeywordParameter <> "" Then
		        Pic.Graphics.ForeColor = Theme.MarkupColor
		        Pic.Graphics.DrawString("[", OffsetX + Offset, OffsetY)
		        Offset = Offset + Pic.Graphics.StringWidth("[")
		        Pic.Graphics.ForeColor = Theme.PlainTextColor
		        Pic.Graphics.DrawString(KeywordParameter, OffsetX + Offset, OffsetY)
		        Offset = Offset + Pic.Graphics.StringWidth(KeywordParameter)
		        Pic.Graphics.ForeColor = Theme.MarkupColor
		        Pic.Graphics.DrawString("]", OffsetX + Offset, OffsetY)
		        Offset = Offset + Pic.Graphics.StringWidth("]")
		      End If
		      Pic.Graphics.ForeColor = Theme.MarkupColor
		      Pic.Graphics.DrawString("=", OffsetX + Offset, OffsetY)
		      Offset = Offset + Pic.Graphics.StringWidth("=")
		      If Len(ValuePart) > 1 And ValuePart.BeginsWith("(") Then
		        Dim Pos As UInteger = 1
		        Dim DoubleOffsetX As Double = OffsetX + Offset
		        Dim DoubleOffsetY As Double = OffsetY
		        Self.RenderArray(ValuePart, Pos, Pic.Graphics, DoubleOffsetX, DoubleOffsetY, Theme)
		      Else
		        If ValuePart = "True" Then
		          Pic.Graphics.ForeColor = Theme.TrueColor
		        ElseIf ValuePart = "False" Then
		          Pic.Graphics.ForeColor = Theme.FalseColor
		        ElseIf Len(ValuePart) > 1 And ValuePart.BeginsWith("""") Then
		          Pic.Graphics.ForeColor = Theme.StringColor
		        ElseIf Self.IsValueNumeric(ValuePart) Then
		          Pic.Graphics.ForeColor = Theme.NumberColor
		        Else
		          Pic.Graphics.ForeColor = Theme.StringColor
		        End If
		        Pic.Graphics.DrawString(ValuePart, OffsetX + Offset, OffsetY)
		      End If
		    Else
		      Pic.Graphics.ForeColor = Theme.PlainTextColor
		      Pic.Graphics.DrawString(Self.mContent, OffsetX, OffsetY)
		    End If
		    System.DebugLog(Str((Microseconds - StartTime) * 0.001, "0") + "ms to render line")
		    
		    Self.mCachedPic = Pic
		  End If
		  
		  G.DrawPicture(Self.mCachedPic, Rect.Left, Rect.Top, Rect.Width, Rect.Height, 0, 0, Self.mCachedPic.Width, Self.mCachedPic.Height)
		  Self.mRect = New REALbasic.Rect(Rect.Left, Rect.Top, Rect.Width, Rect.Height)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RenderArray(ValuePart As String, ByRef StartPos As UInteger, G As Graphics, ByRef OffsetX As Double, ByRef OffsetY As Double, Theme As BeaconCodeTheme)
		  If Mid(ValuePart, StartPos, 1) <> "(" Then
		    Return
		  End If
		  
		  G.ForeColor = Theme.MarkupColor
		  G.DrawString("(", OffsetX, OffsetY)
		  OffsetX = OffsetX + G.StringWidth("(")
		  StartPos = StartPos + 1
		  
		  Dim ValueMatcher As New Regex
		  ValueMatcher.SearchPattern = "^(([a-zA-Z0-9_]+)(\[(\d+)\])?=)?((""[^""]+"")|([^\,\)]+))"
		  
		  Dim NextChar As String
		  Do
		    NextChar = Mid(ValuePart, StartPos, 1)
		    If NextChar = "(" Then
		      Self.RenderArray(ValuePart, StartPos, G, OffsetX, OffsetY, Theme)
		      Continue
		    ElseIf NextChar = "," Or NextChar = ")" Or NextChar = "" Then
		      G.ForeColor = Theme.MarkupColor
		      G.DrawString(NextChar, OffsetX, OffsetY)
		      OffsetX = OffsetX + G.StringWidth(NextChar)
		      StartPos = StartPos + 1
		      Continue
		    End If
		    
		    Dim ValueMatch As RegexMatch = ValueMatcher.Search(Mid(ValuePart, StartPos))
		    If ValueMatch = Nil Then
		      Break
		      Return
		    End If
		    
		    Dim MatchedPart As String = ValueMatch.SubExpressionString(0)
		    Dim KeywordPart As String = ValueMatch.SubExpressionString(2)
		    Dim ParameterPart As String = ValueMatch.SubExpressionString(4)
		    Dim Value As String = ValueMatch.SubExpressionString(5)
		    
		    If KeywordPart <> "" Then
		      G.ForeColor = Theme.KeywordColor
		      G.DrawString(KeywordPart, OffsetX, OffsetY)
		      OffsetX = OffsetX + G.StringWidth(KeywordPart)
		      If ParameterPart <> "" Then
		        G.ForeColor = Theme.MarkupColor
		        G.DrawString("[", OffsetX, OffsetY)
		        OffsetX = OffsetX + G.StringWidth("[")
		        G.ForeColor = Theme.PlainTextColor
		        G.DrawString(ParameterPart, OffsetX, OffsetY)
		        OffsetX = OffsetX + G.StringWidth(ParameterPart)
		        G.ForeColor = Theme.MarkupColor
		        G.DrawString("]", OffsetX, OffsetY)
		        OffsetX = OffsetX + G.StringWidth("]")
		      End If
		      G.ForeColor = Theme.MarkupColor
		      G.DrawString("=", OffsetX, OffsetY)
		      OffsetX = OffsetX + G.StringWidth("=")
		      StartPos = StartPos + Len(ValueMatch.SubExpressionString(1))
		    End If
		    
		    If Value.BeginsWith("(") Then
		      Self.RenderArray(Value, StartPos, G, OffsetX, OffsetY, Theme)
		    Else
		      If Value = "True" Then
		        G.ForeColor = Theme.TrueColor
		      ElseIf Value = "False" Then
		        G.ForeColor = Theme.FalseColor
		      ElseIf Self.IsValueNumeric(Value) Then
		        G.ForeColor = Theme.NumberColor
		      Else
		        G.ForeColor = Theme.StringColor
		      End If
		      G.DrawString(Value, OffsetX, OffsetY)
		      OffsetX = OffsetX + G.StringWidth(Value)
		      StartPos = StartPos + Len(Value)
		    End If
		  Loop Until NextChar = ")" Or NextChar = ""
		  
		  #if false
		    G.ForeColor = Theme.MarkupColor
		    G.DrawString(NextChar, OffsetX, OffsetY)
		    OffsetX = OffsetX + G.StringWidth(NextChar)
		    StartPos = StartPos + 1
		  #endif
		  
		  #if false
		    While Mid(ValuePart, StartPos, 1) = "("
		      Self.RenderArray(ValuePart, StartPos, G, OffsetX, OffsetY, Theme)
		    Wend
		    
		    
		    Do
		      ValueMatch 
		      If ValueMatch = Nil Then
		        Exit
		      End If
		      
		      
		      
		      Dim NextChar As String = Mid(ValuePart, StartPos, 1)
		      If NextChar = "," Or NextChar = ")" Then
		        G.ForeColor = Theme.MarkupColor
		        G.DrawString(NextChar, OffsetX, OffsetY)
		        OffsetX = OffsetX + G.StringWidth(NextChar)
		        StartPos = StartPos + Len(NextChar)
		      End If
		    Loop Until ValueMatch = Nil
		  #endif
		End Sub
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mContent
			End Get
		#tag EndGetter
		Content As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Len(Self.mContent)
			End Get
		#tag EndGetter
		Length As UInteger
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mCachedPic As Picture
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mContent As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mRect As REALbasic.Rect
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return New REALbasic.Rect(Self.mRect.Left, Self.mRect.Top, Self.mRect.Width, Self.mRect.Height)
			End Get
		#tag EndGetter
		Rect As REALbasic.Rect
	#tag EndComputedProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Content"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Length"
			Group="Behavior"
			Type="UInteger"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
