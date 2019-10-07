#tag Class
Protected Class ControlGroupIterator
Implements Iterator
	#tag Method, Flags = &h0
		Sub Constructor(Group As ControlGroup)
		  Self.mGroup = Group
		  Self.mIndex = -1
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function MoveNext() As Boolean
		  // Part of the Iterator interface.
		  
		  Self.mIndex = Self.mIndex + 1
		  Return Self.mIndex <= Self.mGroup.LastRowIndex
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Value() As Variant
		  // Part of the Iterator interface.
		  
		  Return Self.mGroup.Member(Self.mIndex)
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mGroup As ControlGroup
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mIndex As Integer
	#tag EndProperty


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
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
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
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
