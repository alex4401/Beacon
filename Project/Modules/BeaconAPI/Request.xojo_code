#tag Class
Protected Class Request
	#tag Method, Flags = &h0
		Sub Authenticate(Token As String)
		  Self.mAuthHeader = "Session " + Token
		  Self.mAuthUser = ""
		  Self.mAuthPassword = ""
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Authenticate(Username As String, Password As String)
		  Self.mAuthHeader = "Basic " + EncodeBase64(Username + ":" + Password, 0)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Authenticated() As Boolean
		  Return Self.mAuthHeader <> ""
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function AuthHeader() As String
		  Return Self.mAuthHeader
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function AuthPassword() As String
		  Return Self.mAuthPassword
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function AuthUser() As String
		  Return Self.mAuthUser
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(Path As String, Method As String, Callback As BeaconAPI.Request.ReplyCallback)
		  Self.Constructor(Path, Method, New Dictionary, Callback)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(Path As String, Method As String, Payload As Dictionary, Callback As BeaconAPI.Request.ReplyCallback)
		  Self.Constructor(Path, Method, SimpleHTTP.BuildFormData(Payload), "application/x-www-form-urlencoded", Callback)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(Path As String, Method As String, Payload As MemoryBlock, ContentType As String, Callback As BeaconAPI.Request.ReplyCallback)
		  If Path.IndexOf("://") = -1 Then
		    Path = BeaconAPI.URL(Path)
		  End If
		  If Path.Length >= 8 And Path.Left(8) <> "https://" Then
		    Dim Err As New UnsupportedOperationException
		    Err.Reason = "Only https links are supported"
		    Raise Err
		  End If
		  
		  If Method = "GET" Or ContentType = "application/x-www-form-urlencoded" Then
		    Dim QueryIndex As Integer = Path.IndexOf("?")
		    If QueryIndex <> -1 Then
		      Dim Query As String = Path.Middle(QueryIndex + 1)
		      If Payload <> Nil Then
		        Payload = Payload + "&" + Query
		      Else
		        Payload = Query
		      End If
		      Path = Path.Left(QueryIndex)
		    End If
		    ContentType = "application/x-www-form-urlencoded"
		  End If
		  
		  Self.mRequestID = New v4UUID
		  Self.mURL = Path
		  Self.mMethod = Method.Uppercase
		  Self.mCallback = Callback
		  Self.mContentType = ContentType
		  Self.mPayload = Payload
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ContentType() As String
		  Return Self.mContentType
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InvokeCallback(Response As BeaconAPI.Response)
		  Self.mCallback.Invoke(Self, Response)
		  Self.mCallback = Nil
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Method() As String
		  Return Self.mMethod
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Payload() As MemoryBlock
		  Return Self.mPayload
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Query() As String
		  If Self.mPayload <> Nil Then
		    Return Self.mPayload
		  End If
		End Function
	#tag EndMethod

	#tag DelegateDeclaration, Flags = &h0
		Delegate Sub ReplyCallback(Request As BeaconAPI . Request, Response As BeaconAPI . Response)
	#tag EndDelegateDeclaration

	#tag Method, Flags = &h0
		Function RequestID() As String
		  Return Self.mRequestID
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Sign(Identity As Beacon.Identity)
		  Dim Content As String = Self.mMethod + Encodings.UTF8.Chr(10) + Self.mURL
		  If Self.mMethod = "GET" Then
		    If Self.mPayload <> Nil And Self.mPayload.Size > 0 Then
		      Content = Content + "?"
		    End If
		  Else
		    Content = Content + Encodings.UTF8.Chr(10)
		  End If
		  
		  Dim Payload As MemoryBlock = Content
		  If Self.mPayload <> Nil Then
		    Payload = Payload + Self.mPayload
		  End If
		  
		  Self.Authenticate(Identity.Identifier, Identity.Sign(Payload))
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function URL() As String
		  Return Self.mURL
		End Function
	#tag EndMethod


	#tag Property, Flags = &h1
		Protected mAuthHeader As String
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mAuthPassword As String
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mAuthUser As String
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mCallback As ReplyCallback
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mContentType As String
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mMethod As String
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mPayload As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mRequestID As String
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mURL As String
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
