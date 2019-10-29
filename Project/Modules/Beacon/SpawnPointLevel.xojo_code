#tag Class
Protected Class SpawnPointLevel
	#tag Method, Flags = &h0
		Sub Constructor(Source As Beacon.SpawnPointLevel)
		  Self.Difficulty = Source.Difficulty
		  Self.MaxLevel = Source.MaxLevel
		  Self.MinLevel = Source.MinLevel
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(MinLevel As Double, MaxLevel As Double, Difficulty As Double)
		  Self.MinLevel = MinLevel
		  Self.MaxLevel = MaxLevel
		  Self.Difficulty = Difficulty
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function FromSaveData(Dict As Dictionary) As Beacon.SpawnPointLevel
		  If Dict = Nil Or Dict.HasAllKeys("Min", "Max", "Diff") = False Then
		    Return Nil
		  End If
		  
		  Return New Beacon.SpawnPointLevel(Dict.Value("Min"), Dict.Value("Max"), Dict.Value("Diff"))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Compare(Other As Beacon.SpawnPointLevel) As Integer
		  If Other = Nil Then
		    Return 1
		  End If
		  
		  If Self.MinLevel < Other.MinLevel Then
		    Return -1
		  ElseIf Self.MinLevel > Other.MinLevel Then
		    Return 1
		  End If
		  
		  If Self.MaxLevel < Other.MaxLevel Then
		    Return -1
		  ElseIf Self.MaxLevel > Other.MaxLevel Then
		    Return 1
		  End If
		  
		  If Self.Difficulty < Other.Difficulty Then
		    Return -1
		  ElseIf Self.Difficulty > Other.Difficulty Then
		    Return 1
		  End If
		  
		  Return 0
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SaveData() As Dictionary
		  Var Dict As New Dictionary
		  Dict.Value("Min") = Self.MinLevel
		  Dict.Value("Max") = Self.MaxLevel
		  Dict.Value("Diff") = Self.Difficulty
		  Return Dict
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		Difficulty As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		MaxLevel As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		MinLevel As Double
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
			Name="MinLevel"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="MaxLevel"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Difficulty"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass