#tag Interface
Protected Interface DeploymentEngine
	#tag Method, Flags = &h0
		Function BackupGameIni() As String
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function BackupGameUserSettingsIni() As String
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Begin(Label As String, Document As Beacon.Document, Identity As Beacon.Identity, StopMessage As String)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Cancel()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Errored() As Boolean
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Finished() As Boolean
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Name() As String
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ServerIsStarting() As Boolean
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Status() As String
		  
		End Function
	#tag EndMethod


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
	#tag EndViewBehavior
End Interface
#tag EndInterface
