#tag Module
Protected Module BeaconEncryption
	#tag Method, Flags = &h21
		Private Function CRC32(Data As MemoryBlock) As UInt32
		  If Data = Nil Or Data.Size = 0 Then
		    Return 0
		  End If
		  
		  Try
		    Dim crcg, c, t, x,b As UInt32
		    Dim ch As UInt8
		    crcg = &hffffffff
		    c = Data.Size - 1
		    
		    For x=0 To c
		      ch = Data.UInt8Value(x)
		      
		      t = (crcg And &hFF) Xor ch
		      
		      For b=0 To 7
		        If( (t And &h1) = &h1) Then
		          t = BeaconEncryption.ShiftRight(t, 1) Xor &hEDB88320
		        Else
		          t = BeaconEncryption.ShiftRight(t, 1)
		        End If
		      Next
		      crcg = BeaconEncryption.ShiftRight(crcg, 8) Xor t
		    Next
		    
		    crcg = crcg Xor &hFFFFFFFF
		    Return crcg
		  Catch Err As RuntimeException
		    Return 0
		  End Try
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GetLength(Data As MemoryBlock) As UInt64
		  Dim Header As BeaconEncryption.SymmetricHeader = BeaconEncryption.SymmetricHeader.FromMemoryBlock(Data)
		  If Header <> Nil Then
		    Return Header.Size + Header.EncryptedLength
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function IsEncrypted(Data As MemoryBlock) As Boolean
		  Dim Header As BeaconEncryption.SymmetricHeader = BeaconEncryption.SymmetricHeader.FromMemoryBlock(Data)
		  Return Header <> Nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function PEMDecodePrivateKey(Key As String) As String
		  Key = Key.Trim
		  Key = Key.ReplaceAll(Encodings.UTF8.Chr(13) + Encodings.UTF8.Chr(10), Encodings.UTF8.Chr(10))
		  Key = Key.ReplaceAll(Encodings.UTF8.Chr(13), Encodings.UTF8.Chr(10))
		  
		  Dim Lines() As String = Key.Split(Encodings.UTF8.Chr(10))
		  If (Lines(0).IndexOf("BEGIN PRIVATE KEY") = -1 Or Lines(Lines.LastRowIndex).IndexOf("END PRIVATE KEY") = -1) And (Lines(0).IndexOf("BEGIN RSA PRIVATE KEY") = -1 Or Lines(Lines.LastRowIndex).IndexOf("END RSA PRIVATE KEY") = -1) Then
		    Dim Err As New CryptoException
		    Err.Reason = "Text does not appear to be a PEM-encoded private key"
		    Raise Err
		  End If
		  
		  Lines.RemoveRowAt(0)
		  Lines.RemoveRowAt(Lines.LastRowIndex)
		  
		  Key = Lines.Join(Encodings.UTF8.Chr(10))
		  
		  Dim Decoded As String = DecodeBase64(Key)
		  #Pragma BreakOnExceptions Off
		  Try
		    Return Crypto.BERDecodePrivateKey(Decoded)
		  Catch Err As CryptoException
		    Return EncodeHex(Decoded)
		  End Try
		  #Pragma BreakOnExceptions Default
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function PEMDecodePublicKey(Key As String) As String
		  Key = Key.Trim
		  Key = Key.ReplaceAll(Encodings.UTF8.Chr(13) + Encodings.UTF8.Chr(10), Encodings.UTF8.Chr(10))
		  Key = Key.ReplaceAll(Encodings.UTF8.Chr(13), Encodings.UTF8.Chr(10))
		  
		  Dim Lines() As String = Key.Split(Encodings.UTF8.Chr(10))
		  If Lines(0).IndexOf("BEGIN PUBLIC KEY") = -1 Or Lines(Lines.LastRowIndex).IndexOf("END PUBLIC KEY") = -1 Then
		    Dim Err As New CryptoException
		    Err.Reason = "Text does not appear to be a PEM-encoded public key"
		    Raise Err
		  End If
		  
		  Lines.RemoveRowAt(0)
		  Lines.RemoveRowAt(Lines.LastRowIndex)
		  
		  Key = Lines.Join(Encodings.UTF8.Chr(10))
		  
		  Dim Decoded As String = DecodeBase64(Key)
		  #Pragma BreakOnExceptions Off
		  Try
		    Return Crypto.BERDecodePublicKey(Decoded)
		  Catch Err As CryptoException
		    Return EncodeHex(Decoded)
		  End Try
		  #Pragma BreakOnExceptions Default
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function PEMEncodePrivateKey(Key As String) As String
		  Dim Base64 As String = EncodeBase64(Crypto.DEREncodePrivateKey(Key), 0)
		  Dim Lines() As String = Array("-----BEGIN PRIVATE KEY-----")
		  While Base64.Length > 64
		    Lines.AddRow(Base64.Left(64))
		    Base64 = Base64.Middle(64)
		  Wend
		  If Base64.Length > 0 Then
		    Lines.AddRow(Base64)
		  End If
		  Lines.AddRow("-----END PRIVATE KEY-----")
		  Return Lines.Join(Encodings.UTF8.Chr(10))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function PEMEncodePublicKey(Key As String) As String
		  Dim Base64 As String = EncodeBase64(DecodeHex(Key), 0)
		  Dim Lines() As String = Array("-----BEGIN PUBLIC KEY-----")
		  While Base64.Length > 64
		    Lines.AddRow(Base64.Left(64))
		    Base64 = Base64.Middle(64)
		  Wend
		  If Base64.Length > 0 Then
		    Lines.AddRow(Base64)
		  End If
		  Lines.AddRow("-----END PUBLIC KEY-----")
		  Return Lines.Join(Encodings.UTF8.Chr(10))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ShiftLeft(Value As UInt64, NumBits As UInt64) As UInt64
		  // It is insane that I need to implement this method manually.
		  
		  Return Value * (2 ^ NumBits)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ShiftRight(Value As UInt64, NumBits As UInt64) As UInt64
		  // It is insane that I need to implement this method manually.
		  
		  Return Value / (2 ^ NumBits)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function SymmetricDecrypt(Key As MemoryBlock, Data As MemoryBlock) As MemoryBlock
		  If Data = "" Then
		    Return ""
		  End If
		  
		  Dim Header As BeaconEncryption.SymmetricHeader = BeaconEncryption.SymmetricHeader.FromMemoryBlock(Data)
		  If Header = Nil Then
		    Dim Err As New CryptoException
		    Err.Reason = "Data is not properly encrypted"
		    Raise Err
		  End If
		  
		  Data = Data.Middle(Header.Size, Data.Size - Header.Size)
		  
		  Select Case Header.Version
		  Case 1
		    Dim Crypt As New M_Crypto.Blowfish_MTC(Key)
		    Crypt.SetInitialVector(Header.Vector)
		    Data = Crypt.DecryptCBC(Data)
		  Case 2
		    Dim Crypt As New M_Crypto.AES_MTC(Key, M_Crypto.AES_MTC.EncryptionBits.Bits256)
		    Crypt.SetInitialVector(Header.Vector)
		    Data = Crypt.DecryptCBC(Data)
		  End Select
		  If Data.Size > Header.Length Then
		    Data = Data.Left(Header.Length)
		  End If
		  
		  Dim ComputedChecksum As UInt32 = BeaconEncryption.CRC32(Data)
		  If ComputedChecksum <> Header.Checksum Then
		    Dim Err As New CryptoException
		    Err.Reason = "CRC32 checksum failed on decrypted data."
		    Raise Err
		  End If
		  
		  Return Data
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function SymmetricEncrypt(Key As MemoryBlock, Data As MemoryBlock, Version As Integer = 2) As MemoryBlock
		  If Data = "" Then
		    Return ""
		  End If
		  
		  Dim Header As New BeaconEncryption.SymmetricHeader(Data, Version)
		  
		  Select Case Version
		  Case 2
		    Dim Crypt As New M_Crypto.AES_MTC(Key, M_Crypto.AES_MTC.EncryptionBits.Bits256)
		    Crypt.SetInitialVector(Header.Vector)
		    Return Header.Encoded + Crypt.EncryptCBC(Data)
		  Case 1
		    Dim Crypt As New M_Crypto.Blowfish_MTC(Key)
		    Crypt.SetInitialVector(Header.Vector)
		    Return Header.Encoded + Crypt.EncryptCBC(Data)
		  Else
		    Dim Err As New CryptoException
		    Err.Message = "Unknown symmetric version " + Version.ToString
		    Raise Err
		  End Select
		End Function
	#tag EndMethod


	#tag Constant, Name = SymmetricLittleEndian, Type = Boolean, Dynamic = False, Default = \"False", Scope = Private
	#tag EndConstant

	#tag Constant, Name = SymmetricMagicByte, Type = Double, Dynamic = False, Default = \"&h8A", Scope = Private
	#tag EndConstant

	#tag Constant, Name = SymmetricVersion, Type = Double, Dynamic = False, Default = \"2", Scope = Private
	#tag EndConstant


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
End Module
#tag EndModule
