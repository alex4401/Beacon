#tag Class
Protected Class ControlSocket
Inherits TCPSocket
	#tag Event
		Sub Connected()
		  Self.mConnectedAddress = Self.RemoteAddress
		  App.Log("Received connection from " + Self.mConnectedAddress)
		End Sub
	#tag EndEvent

	#tag Event
		Sub DataReceived()
		  Dim Buffer As MemoryBlock = Self.Lookahead
		  If Buffer = Nil Or Buffer.Size = 0 Then
		    Return
		  End If
		  
		  While Buffer <> Nil
		    Dim PayloadLen As UInt64 = BeaconEncryption.GetLength(Buffer)
		    If PayloadLen = 0 Then
		      Return
		    End If
		    
		    Dim Payload As MemoryBlock = Self.Read(PayloadLen, Nil)
		    Buffer = Buffer.MidB(PayloadLen)
		    
		    Dim Decrypted As MemoryBlock
		    Try
		      Decrypted = BeaconEncryption.SymmetricDecrypt(Self.EncryptionKey, Payload)
		    Catch Err As RuntimeException
		      Continue
		    End Try
		    
		    Dim Dict As Dictionary
		    Try
		      Dict = Xojo.ParseJSON(Decrypted)
		    Catch Err As RuntimeException
		      Continue
		    End Try
		    
		    If Dict.HasKey("Nonce") = False Or Dict.Value("Nonce").IntegerValue <> Self.mNextNonce Then
		      App.Log("Warning: malicious command sequence from " + Self.mConnectedAddress + ", connection will be terminated for safety.")
		      Self.Disconnect()
		      Return
		    End If
		    Dim ReplyNonce As Integer = Self.mNextNonce
		    Self.mNextNonce = Self.mNextNonce + 1
		    
		    Dim Response As Dictionary
		    Try
		      Response = RaiseEvent MessageReceived(Dict)
		    Catch Err As RuntimeException
		      If Not App.HandleException(Err) Then
		        Quit
		      End If
		    End Try
		    If Response = Nil Then
		      Response = New Dictionary
		    End If
		    Response.Value("Nonce") = ReplyNonce
		    
		    Self.Write(BeaconEncryption.SymmetricEncrypt(Self.EncryptionKey, Xojo.GenerateJSON(Response, False)))
		  Wend
		End Sub
	#tag EndEvent

	#tag Event
		Sub Error(err As RuntimeException)
		  #Pragma Unused Err
		  
		  App.Log("Lost connection with " + Self.mConnectedAddress)
		  Self.Reset()
		  Break
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Sub Constructor()
		  Super.Constructor
		  Self.Reset()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(EncryptionKey As String)
		  Self.EncryptionKey = EncryptionKey
		  Self.Constructor
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Reset()
		  Self.mNextNonce = 1
		  Self.mConnectedAddress = ""
		  Self.Purge
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event MessageReceived(Message As Dictionary) As Dictionary
	#tag EndHook


	#tag Property, Flags = &h21
		Private EncryptionKey As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mConnectedAddress As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mNextNonce As Integer
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
			InitialValue=""
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
			Name="Address"
			Visible=true
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Port"
			Visible=true
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="EncryptionKey"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass