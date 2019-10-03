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
		Sub Render(G As Graphics, Rect As Xojo.Rect, Theme As BeaconCodeTheme, OffsetX As Integer, OffsetY As Integer)
		  Static KeywordMatcher As Regex
		  If KeywordMatcher = Nil Then
		    KeywordMatcher = New Regex
		    KeywordMatcher.SearchPattern = "^([a-zA-Z0-9_\.]+)(\[(\d+)\])?=(.*)$"
		  End If
		  
		  If Self.mCachedPic = Nil Or Self.mCachedOffset = Nil Or Self.mCachedPic.Width <> Rect.Width * G.ScaleX Or Self.mCachedPic.Height <> Rect.Height * G.ScaleY Or Self.mCachedOffset.X <> OffsetX Or Self.mCachedOffset.Y <> OffsetY Then
		    Dim OffsetCache As New Xojo.Point(OffsetX, OffsetY)
		    
		    Dim Pic As New Picture(Rect.Width * G.ScaleX, Rect.Height * G.ScaleY)
		    Pic.HorizontalResolution = 72 * G.ScaleX
		    Pic.VerticalResolution = 72 * G.ScaleY
		    Pic.Graphics.ScaleX = G.ScaleX
		    Pic.Graphics.ScaleY = G.ScaleY
		    Pic.Graphics.FontName = G.FontName
		    Pic.Graphics.FontSize = G.FontSize
		    Pic.Graphics.FontUnit = G.FontUnit
		    
		    Dim KeywordMatches As RegexMatch = KeywordMatcher.Search(Self.mContent)
		    
		    If Self.mContent.BeginsWith("[") And Self.mContent.EndsWith("]") Then
		      Pic.Graphics.DrawingColor = Theme.MarkupColor
		      Pic.Graphics.DrawText(Self.mContent, OffsetX, OffsetY)
		    ElseIf Self.mContent.BeginsWith("//") Then
		      Pic.Graphics.DrawingColor = Theme.CommentColor
		      Pic.Graphics.DrawText(Self.mContent, OffsetX, OffsetY)
		    ElseIf Self.mContent.BeginsWith("#") Then
		      Pic.Graphics.DrawingColor = Theme.PragmaColor
		      Pic.Graphics.DrawText(Self.mContent, OffsetX, OffsetY)
		    ElseIf KeywordMatches <> Nil Then
		      Dim Keyword As String = KeywordMatches.SubExpressionString(1)
		      Dim KeywordParameter As String = If(KeywordMatches.SubExpressionCount > 2, KeywordMatches.SubExpressionString(3), "")
		      Dim ValuePart As String = Keywordmatches.SubExpressionString(4)
		      
		      Dim Offset As Double
		      Pic.Graphics.DrawingColor = Theme.KeywordColor
		      Pic.Graphics.DrawText(Keyword, OffsetX, OffsetY)
		      Offset = Pic.Graphics.TextWidth(Keyword)
		      If KeywordParameter <> "" Then
		        Pic.Graphics.DrawingColor = Theme.MarkupColor
		        Pic.Graphics.DrawText("[", OffsetX + Offset, OffsetY)
		        Offset = Offset + Pic.Graphics.TextWidth("[")
		        Pic.Graphics.DrawingColor = Theme.PlainTextColor
		        Pic.Graphics.DrawText(KeywordParameter, OffsetX + Offset, OffsetY)
		        Offset = Offset + Pic.Graphics.TextWidth(KeywordParameter)
		        Pic.Graphics.DrawingColor = Theme.MarkupColor
		        Pic.Graphics.DrawText("]", OffsetX + Offset, OffsetY)
		        Offset = Offset + Pic.Graphics.TextWidth("]")
		      End If
		      Pic.Graphics.DrawingColor = Theme.MarkupColor
		      Pic.Graphics.DrawText("=", OffsetX + Offset, OffsetY)
		      Offset = Offset + Pic.Graphics.TextWidth("=")
		      If ValuePart.Length > 1 And ValuePart.BeginsWith("(") Then
		        Dim Pos As UInteger = 0
		        Dim DoubleOffsetX As Double = OffsetX + Offset
		        Dim DoubleOffsetY As Double = OffsetY
		        Self.RenderArray(ValuePart, Pos, Pic.Graphics, DoubleOffsetX, DoubleOffsetY, Theme)
		      Else
		        If ValuePart = "True" Then
		          Pic.Graphics.DrawingColor = Theme.TrueColor
		          ValuePart = "True" // To capitalize
		        ElseIf ValuePart = "False" Then
		          Pic.Graphics.DrawingColor = Theme.FalseColor
		          ValuePart = "False" // To capitalize
		        ElseIf ValuePart.Length > 1 And ValuePart.BeginsWith("""") Then
		          Pic.Graphics.DrawingColor = Theme.StringColor
		        ElseIf Self.IsValueNumeric(ValuePart) Then
		          Pic.Graphics.DrawingColor = Theme.NumberColor
		        Else
		          Pic.Graphics.DrawingColor = Theme.StringColor
		        End If
		        Pic.Graphics.DrawText(ValuePart, OffsetX + Offset, OffsetY)
		      End If
		    Else
		      Pic.Graphics.DrawingColor = Theme.PlainTextColor
		      Pic.Graphics.DrawText(Self.mContent, OffsetX, OffsetY)
		    End If
		    
		    Self.mCachedPic = Pic
		    Self.mCachedOffset = OffsetCache
		  End If
		  
		  G.DrawPicture(Self.mCachedPic, Rect.Left, Rect.Top, Rect.Width, Rect.Height, 0, 0, Self.mCachedPic.Width, Self.mCachedPic.Height)
		  Self.mRect = New Xojo.Rect(Rect.Left, Rect.Top, Rect.Width, Rect.Height)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RenderArray(ValuePart As String, ByRef StartPos As UInteger, G As Graphics, ByRef OffsetX As Double, ByRef OffsetY As Double, Theme As BeaconCodeTheme)
		  If ValuePart.Middle(StartPos, 1) <> "(" Then
		    Return
		  End If
		  
		  G.DrawingColor = Theme.MarkupColor
		  G.DrawText("(", OffsetX, OffsetY)
		  OffsetX = OffsetX + G.TextWidth("(")
		  StartPos = StartPos + 1
		  
		  Dim ValueMatcher As New Regex
		  ValueMatcher.SearchPattern = "^(([a-zA-Z0-9_]+)(\[(\d+)\])?=)?((""[^""]+"")|([^\,\)]+))"
		  
		  Dim NextChar As String
		  Do
		    NextChar = ValuePart.Middle(StartPos, 1)
		    If NextChar = "(" Then
		      Self.RenderArray(ValuePart, StartPos, G, OffsetX, OffsetY, Theme)
		      Continue
		    ElseIf NextChar = "," Or NextChar = ")" Or NextChar = "" Then
		      G.DrawingColor = Theme.MarkupColor
		      G.DrawText(NextChar, OffsetX, OffsetY)
		      OffsetX = OffsetX + G.TextWidth(NextChar)
		      StartPos = StartPos + 1
		      Continue
		    End If
		    
		    Dim ValueMatch As RegexMatch = ValueMatcher.Search(ValuePart.Middle(StartPos))
		    If ValueMatch = Nil Then
		      Break
		      Return
		    End If
		    
		    Dim KeywordPart As String = ValueMatch.SubExpressionString(2)
		    Dim ParameterPart As String = ValueMatch.SubExpressionString(4)
		    Dim Value As String = ValueMatch.SubExpressionString(5)
		    
		    If KeywordPart <> "" Then
		      G.DrawingColor = Theme.KeywordColor
		      G.DrawText(KeywordPart, OffsetX, OffsetY)
		      OffsetX = OffsetX + G.TextWidth(KeywordPart)
		      If ParameterPart <> "" Then
		        G.DrawingColor = Theme.MarkupColor
		        G.DrawText("[", OffsetX, OffsetY)
		        OffsetX = OffsetX + G.TextWidth("[")
		        G.DrawingColor = Theme.PlainTextColor
		        G.DrawText(ParameterPart, OffsetX, OffsetY)
		        OffsetX = OffsetX + G.TextWidth(ParameterPart)
		        G.DrawingColor = Theme.MarkupColor
		        G.DrawText("]", OffsetX, OffsetY)
		        OffsetX = OffsetX + G.TextWidth("]")
		      End If
		      G.DrawingColor = Theme.MarkupColor
		      G.DrawText("=", OffsetX, OffsetY)
		      OffsetX = OffsetX + G.TextWidth("=")
		      StartPos = StartPos + ValueMatch.SubExpressionString(1).Length
		    End If
		    
		    If Value.BeginsWith("(") Then
		      Self.RenderArray(Value, StartPos, G, OffsetX, OffsetY, Theme)
		    Else
		      If Value = "True" Then
		        G.DrawingColor = Theme.TrueColor
		        Value = "True" // To capitalize
		      ElseIf Value = "False" Then
		        G.DrawingColor = Theme.FalseColor
		        Value = "False" // To capitalize
		      ElseIf Self.IsValueNumeric(Value) Then
		        G.DrawingColor = Theme.NumberColor
		      Else
		        G.DrawingColor = Theme.StringColor
		      End If
		      G.DrawText(Value, OffsetX, OffsetY)
		      OffsetX = OffsetX + G.TextWidth(Value)
		      StartPos = StartPos + Value.Length
		    End If
		  Loop Until NextChar = ")" Or NextChar = ""
		  
		  #if false
		    G.DrawingColor = Theme.MarkupColor
		    G.DrawText(NextChar, OffsetX, OffsetY)
		    OffsetX = OffsetX + G.TextWidth(NextChar)
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
		        G.DrawingColor = Theme.MarkupColor
		        G.DrawText(NextChar, OffsetX, OffsetY)
		        OffsetX = OffsetX + G.TextWidth(NextChar)
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
			  Return Self.mContent.Length
			End Get
		#tag EndGetter
		Length As UInteger
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mCachedOffset As Xojo.Point
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCachedPic As Picture
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mContent As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mRect As Xojo.Rect
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return New Xojo.Rect(Self.mRect.Left, Self.mRect.Top, Self.mRect.Width, Self.mRect.Height)
			End Get
		#tag EndGetter
		Rect As Xojo.Rect
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		Visible As Boolean
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
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
			Name="Super"
			Visible=true
			Group="ID"
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
			Name="Content"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Length"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="UInteger"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Visible"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
