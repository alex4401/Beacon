#tag Class
Protected Class BeaconCodeTheme
	#tag Method, Flags = &h0
		Sub Constructor(BackgroundColor As Color, PlainTextColor As Color, KeywordColor As Color, MarkupColor As Color, TrueColor As Color, FalseColor As Color, NumberColor As Color, StringColor As Color, CommentColor As Color, PragmaColor As Color)
		  Self.mBackgroundColor = BackgroundColor
		  Self.mPlainTextColor = PlainTextColor
		  Self.mKeywordColor = KeywordColor
		  Self.mMarkupColor = MarkupColor
		  Self.mTrueColor = TrueColor
		  Self.mFalseColor = FalseColor
		  Self.mNumberColor = NumberColor
		  Self.mStringColor = StringColor
		  Self.mCommentColor = CommentColor
		  Self.mPragmaColor = PragmaColor
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Matches(Other As BeaconCodeTheme) As Boolean
		  If Other = Nil Then
		    Return False
		  End If
		  
		  If Self.mPlainTextColor <> Other.mPlainTextColor Then
		    Return False
		  ElseIf Self.mKeywordColor <> Other.mKeywordColor Then
		    Return False
		  ElseIf Self.mMarkupColor <> Other.mMarkupColor Then
		    Return False
		  ElseIf Self.mFalseColor <> Other.mFalseColor Then
		    Return False
		  ElseIf Self.mTrueColor <> Other.mTrueColor Then
		    Return False
		  ElseIf Self.mStringColor <> Other.mStringColor Then
		    Return False
		  ElseIf Self.mNumberColor <> Other.mNumberColor Then
		    Return False
		  End If
		  
		  Return True
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mBackgroundColor
			End Get
		#tag EndGetter
		BackgroundColor As Color
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mCommentColor
			End Get
		#tag EndGetter
		CommentColor As Color
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mFalseColor
			End Get
		#tag EndGetter
		FalseColor As Color
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mKeywordColor
			End Get
		#tag EndGetter
		KeywordColor As Color
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mMarkupColor
			End Get
		#tag EndGetter
		MarkupColor As Color
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mBackgroundColor As Color
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCommentColor As Color
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mFalseColor As Color
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mKeywordColor As Color
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mMarkupColor As Color
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mNumberColor As Color
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPlainTextColor As Color
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPragmaColor As Color
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mStringColor As Color
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTrueColor As Color
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mNumberColor
			End Get
		#tag EndGetter
		NumberColor As Color
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mPlainTextColor
			End Get
		#tag EndGetter
		PlainTextColor As Color
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mPragmaColor
			End Get
		#tag EndGetter
		PragmaColor As Color
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mStringColor
			End Get
		#tag EndGetter
		StringColor As Color
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mTrueColor
			End Get
		#tag EndGetter
		TrueColor As Color
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
			Name="BackgroundColor"
			Group="Behavior"
			InitialValue="&c000000"
			Type="Color"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FalseColor"
			Group="Behavior"
			InitialValue="&c000000"
			Type="Color"
		#tag EndViewProperty
		#tag ViewProperty
			Name="KeywordColor"
			Group="Behavior"
			InitialValue="&c000000"
			Type="Color"
		#tag EndViewProperty
		#tag ViewProperty
			Name="MarkupColor"
			Group="Behavior"
			InitialValue="&c000000"
			Type="Color"
		#tag EndViewProperty
		#tag ViewProperty
			Name="NumberColor"
			Group="Behavior"
			InitialValue="&c000000"
			Type="Color"
		#tag EndViewProperty
		#tag ViewProperty
			Name="PlainTextColor"
			Group="Behavior"
			InitialValue="&c000000"
			Type="Color"
		#tag EndViewProperty
		#tag ViewProperty
			Name="StringColor"
			Group="Behavior"
			InitialValue="&c000000"
			Type="Color"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TrueColor"
			Group="Behavior"
			InitialValue="&c000000"
			Type="Color"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
