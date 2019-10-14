#tag Class
Protected Class AnalyzerPlugin
	#tag Method, Flags = &h0
		Function Compile() As Boolean
		  If Self.mCompiled Or Self.Engine.Precompile(XojoScript.OptimizationLevels.High) Then
		    Self.mCompiled = True
		    Return True
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Compiled() As Boolean
		  Return Self.mCompiled
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(Source As String)
		  Self.Engine = New XojoScript
		  AddHandler Engine.CompilerError, WeakAddressOf Engine_CompilerError
		  AddHandler Engine.CompilerWarning, WeakAddressOf Engine_CompilerWarning
		  AddHandler Engine.Input, WeakAddressOf Engine_Input
		  AddHandler Engine.Print, WeakAddressOf Engine_Print
		  AddHandler Engine.RuntimeError, WeakAddressOf Engine_RuntimeError
		  Self.Engine.Source = Source
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Engine_CompilerError(Sender As XojoScript, Location As XojoScriptLocation, Error As XojoScript.Errors, ErrorInfo As Dictionary) As Boolean
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Engine_CompilerWarning(Sender As XojoScript, Location As XojoScriptLocation, Warning As XojoScript.Warnings, WarningInfo As Dictionary)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Engine_Input(Sender As XojoScript, Prompt As String) As String
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Engine_Print(Sender As XojoScript, Message As String)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Engine_RuntimeError(Sender As XojoScript, Error As RuntimeException)
		  
		End Sub
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  If Self.Engine.Context <> Nil And Self.Engine.Context IsA Beacon.AnalyzerContext Then
			    Return Beacon.AnalyzerContext(Self.Engine.Context)
			  End If
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If Self.Compiled Then
			    Self.mCompiled = False
			  End If
			  
			  Self.Engine.Context = Value
			End Set
		#tag EndSetter
		Context As Beacon.AnalyzerContext
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private Engine As XojoScript
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCompiled As Boolean
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
			Name="Engine"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
