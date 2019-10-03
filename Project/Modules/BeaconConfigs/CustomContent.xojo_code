#tag Class
Protected Class CustomContent
Inherits Beacon.ConfigGroup
	#tag Event
		Sub ReadDictionary(Dict As Dictionary, Identity As Beacon.Identity, Document As Beacon.Document)
		  Self.mGameIniContent = Self.ReadContent(Dict.Lookup("Game.ini", ""), Identity, Document)
		  Self.mGameUserSettingsIniContent = Self.ReadContent(Dict.Lookup("GameUserSettings.ini", ""), Identity, Document)
		End Sub
	#tag EndEvent

	#tag Event
		Sub WriteDictionary(Dict As Dictionary, Document As Beacon.Document)
		  Dict.Value("Game.ini") = Self.WriteContent(Self.mGameIniContent, Document)
		  Dict.Value("GameUserSettings.ini") = Self.WriteContent(Self.mGameUserSettingsIniContent, Document)
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Shared Function ConfigName() As String
		  Return "CustomContent"
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Decrypt(Input As String, Identity As Beacon.Identity, Document As Beacon.Document) As String
		  Try
		    #Pragma BreakOnExceptions False
		    Dim Decrypted As String = Document.Decrypt(Input).DefineEncoding(Encodings.UTF8)
		    #Pragma BreakOnExceptions Default
		    If Self.mEncryptedValues = Nil Then
		      Self.mEncryptedValues = New Dictionary
		    End If
		    Self.mEncryptedValues.Value(EncodeHex(Crypto.SHA512(Decrypted))) = Input
		    Return Decrypted
		  Catch Err As RuntimeException
		  End Try
		  
		  Try
		    #Pragma BreakOnExceptions False
		    Dim SecureDict As Dictionary = Beacon.ParseJSON(Input)
		    #Pragma BreakOnExceptions Default
		    If Not SecureDict.HasAllKeys("Key", "Vector", "Content", "Hash") Then
		      Return ""
		    End If
		    
		    Dim Key As MemoryBlock = Identity.Decrypt(DecodeHex(SecureDict.Value("Key")))
		    If Key = Nil Then
		      Return ""
		    End If
		    
		    Dim Vector As MemoryBlock = DecodeHex(SecureDict.Value("Vector"))
		    Dim Encrypted As MemoryBlock = DecodeHex(SecureDict.Value("Content"))
		    Dim ExpectedHash As String = SecureDict.Value("Hash")
		    
		    #if Not TargetiOS
		      Dim AES As New M_Crypto.AES_MTC(AES_MTC.EncryptionBits.Bits256)
		      AES.SetKey(Key)
		      AES.SetInitialVector(Vector)
		      
		      Dim Decrypted As String
		      Try
		        Decrypted = AES.DecryptCBC(Encrypted)
		      Catch Err As RuntimeException
		        Return ""
		      End Try
		      
		      Dim ComputedHash As String = EncodeHex(Crypto.SHA512(Decrypted))
		      If ComputedHash <> ExpectedHash Then
		        Return ""
		      End If
		      
		      If Decrypted = "" Or Not Encodings.UTF8.IsValidData(Decrypted) Then
		        Return ""
		      End If
		      Decrypted = Decrypted.DefineEncoding(Encodings.UTF8)
		      
		      // Do not store to encrypted values when decrypting legacy content so the
		      // new encryption will be used on save.
		      
		      Return Decrypted
		    #else
		      #Pragma Error "Not implemented"
		    #endif
		  Catch Err As RuntimeException
		  End Try
		  
		  Return ""
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DefaultImported() As Boolean
		  Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Encrypt(Input As String, Document As Beacon.Document) As String
		  Try
		    Dim Hash As String = EncodeHex(Crypto.SHA512(Input))
		    If Self.mEncryptedValues <> Nil And Self.mEncryptedValues.HasKey(Hash) Then
		      Return Self.mEncryptedValues.Value(Hash)
		    End If
		    
		    Dim Encrypted As String = Document.Encrypt(Input.ConvertEncoding(Encodings.UTF8))
		    If Self.mEncryptedValues = Nil Then
		      Self.mEncryptedValues = New Dictionary
		    End If
		    Self.mEncryptedValues.Value(Hash) = Encrypted
		    Return Encrypted
		  Catch Err As RuntimeException
		    Return ""
		  End Try
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function FilterIniText(Input As String) As String
		  Dim EOL As String = Encodings.ASCII.Chr(10)
		  Input = Input.ReplaceLineEndings(EOL)
		  
		  Dim InsideBeaconSection As Boolean
		  Dim Lines() As String = Input.Split(EOL)
		  Dim FilteredLines() As String
		  For I As Integer = 0 To Lines.LastRowIndex
		    Dim Line As String = Lines(I).Trim
		    If Line = "[Beacon]" Then
		      InsideBeaconSection = True
		    ElseIf Line.BeginsWith("[") And Line.EndsWith("]") Then
		      InsideBeaconSection = False
		    End If
		    
		    If Not InsideBeaconSection Then
		      FilteredLines.AddRow(Line)
		    End If
		  Next
		  
		  Input = FilteredLines.Join(EOL)
		  Return Input.Trim
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GameIniContent() As String
		  Return Self.mGameIniContent
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub GameIniContent(SupportedConfigs As Dictionary = Nil, Assigns Value As String)
		  If SupportedConfigs <> Nil Then
		    Dim ConfigValues() As Beacon.ConfigValue = Self.IniValues(Beacon.ShooterGameHeader, Value, SupportedConfigs, Nil)
		    Dim ConfigDict As New Dictionary
		    Beacon.ConfigValue.FillConfigDict(ConfigDict, ConfigValues)
		    
		    Dim Errored As Boolean
		    Dim Rewritten As String = Beacon.Rewriter.Rewrite("", ConfigDict, "", Beacon.Rewriter.EncodingFormat.Unicode, Errored)
		    If Not Errored Then
		      Value = Rewritten
		    End If
		  End If
		  
		  If StrComp(Self.mGameIniContent, Value, 0) <> 0 Then
		    Self.mGameIniContent = Value
		    Self.Modified = True
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GameIniValues(SourceDocument As Beacon.Document, Identity As Beacon.Identity, Mask As UInt64) As Beacon.ConfigValue()
		  #Pragma Unused SourceDocument
		  #Pragma Unused Identity
		  #Pragma Unused Mask
		  
		  Dim Err As UnsupportedOperationException
		  Err.Message = "Do not call this one!"
		  Raise Err
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GameIniValues(SourceDocument As Beacon.Document, Profile As Beacon.ServerProfile) As Beacon.ConfigValue()
		  Return Self.GameIniValues(SourceDocument, New Dictionary, Profile)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GameIniValues(SourceDocument As Beacon.Document, ExistingConfigs As Dictionary, Profile As Beacon.ServerProfile) As Beacon.ConfigValue()
		  #Pragma Unused SourceDocument
		  
		  Return Self.IniValues(Beacon.ShooterGameHeader, Self.mGameIniContent, ExistingConfigs, Profile)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GameUserSettingsIniContent() As String
		  Return Self.mGameUserSettingsIniContent
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub GameUserSettingsIniContent(SupportedConfigs As Dictionary = Nil, Assigns Value As String)
		  If SupportedConfigs <> Nil Then
		    Dim ConfigValues() As Beacon.ConfigValue = Self.IniValues(Beacon.ServerSettingsHeader, Value, SupportedConfigs, Nil)
		    
		    Dim ProtectedKeys As New Dictionary
		    ProtectedKeys.Value("ServerSettings.ServerAdminPassword") = True
		    ProtectedKeys.Value("ServerSettings.ServerPassword") = True
		    ProtectedKeys.Value("AuctionHouse.MarketID") = True
		    
		    // Make sure passwords get encrypted on save
		    For I As Integer = ConfigValues.LastRowIndex DownTo 0
		      Dim ConfigValue As Beacon.ConfigValue = ConfigValues(I)
		      If ConfigValue.Value = "" Then
		        Continue
		      End If
		      
		      If ProtectedKeys.HasKey(ConfigValue.Header + "." + ConfigValue.Key) Then
		        ConfigValues(I) = New Beacon.ConfigValue(ConfigValue.Header, ConfigValue.Key, Self.EncryptedTag + ConfigValue.Value + Self.EncryptedTag)
		      End If
		    Next
		    
		    Dim ConfigDict As New Dictionary
		    Beacon.ConfigValue.FillConfigDict(ConfigDict, ConfigValues)
		    
		    Dim Errored As Boolean
		    Dim Rewritten As String = Beacon.Rewriter.Rewrite("", ConfigDict, "", Beacon.Rewriter.EncodingFormat.Unicode, Errored)
		    If Not Errored Then
		      Value = Rewritten
		    End If
		  End If
		  
		  If StrComp(Self.mGameUserSettingsIniContent, Value, 0) <> 0 Then
		    Self.mGameUserSettingsIniContent = Value
		    Self.Modified = True
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GameUserSettingsIniValues(SourceDocument As Beacon.Document, Identity As Beacon.Identity, Mask As UInt64) As Beacon.ConfigValue()
		  #Pragma Unused SourceDocument
		  #Pragma Unused Identity
		  #Pragma Unused Mask
		  
		  Dim Err As UnsupportedOperationException
		  Err.Message = "Do not call this one!"
		  Raise Err
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GameUserSettingsIniValues(SourceDocument As Beacon.Document, Profile As Beacon.ServerProfile) As Beacon.ConfigValue()
		  Return Self.GameUserSettingsIniValues(SourceDocument, New Dictionary, Profile)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GameUserSettingsIniValues(SourceDocument As Beacon.Document, ExistingConfigs As Dictionary, Profile As Beacon.ServerProfile) As Beacon.ConfigValue()
		  #Pragma Unused SourceDocument
		  
		  Return Self.IniValues(Beacon.ServerSettingsHeader, Self.mGameUserSettingsIniContent, ExistingConfigs, Profile)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function IniValues(InitialHeader As String, Source As String, ExistingConfigs As Dictionary, Profile As Beacon.ServerProfile) As Beacon.ConfigValue()
		  Source = Source.ReplaceAll(Self.EncryptedTag, "")
		  Source = Source.ReplaceLineEndings(Encodings.ASCII.Chr(10))
		  
		  Dim Lines() As String = Source.Split(Encodings.ASCII.Chr(10))
		  Dim Parser As New CustomContentParser(InitialHeader, ExistingConfigs, Profile)
		  For Each Line As String In Lines
		    Dim ShouldAlwaysBeNil() As Beacon.ConfigValue = Parser.AddLine(Line)
		    If ShouldAlwaysBeNil <> Nil Then
		      Break
		    End If
		  Next
		  Return Parser.RemainingValues
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ReadContent(Input As String, Identity As Beacon.Identity, Document As Beacon.Document) As String
		  Input = Input.GuessEncoding
		  
		  Dim Pos As Integer
		  Self.mEncryptedValues = New Dictionary
		  
		  Do
		    Pos = Input.IndexOf(Pos, Self.EncryptedTag)
		    If Pos = -1 Then
		      Return Input
		    End If
		    
		    Dim StartPos As Integer = Pos + Self.EncryptedTag.Length
		    Dim EndPos As Integer = Input.IndexOf(StartPos, Self.EncryptedTag)
		    If EndPos = -1 Then
		      EndPos = Input.Length
		    End If
		    
		    Dim Prefix As String = Input.Left(StartPos)
		    Dim Suffix As String = Input.Right(Input.Length - EndPos)
		    Dim EncryptedContent As String = Input.Middle(StartPos, EndPos - StartPos)
		    Dim DecryptedContent As String = Self.Decrypt(EncryptedContent, Identity, Document)
		    
		    If DecryptedContent = "" Then
		      Prefix = Prefix.Left(Prefix.Length - Self.EncryptedTag.Length)
		      Suffix = Suffix.Right(Suffix.Length - Self.EncryptedTag.Length)
		      Input = Prefix + Suffix
		      Pos = Prefix.Length
		    Else
		      Input = Prefix + DecryptedContent + Suffix
		      Pos = Prefix.Length + DecryptedContent.Length + Self.EncryptedTag.Length
		    End If
		  Loop
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function RequiresOmni() As Boolean
		  Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function WriteContent(Input As String, Document As Beacon.Document) As String
		  Dim Pos As Integer
		  
		  Do
		    Pos = Input.IndexOf(Pos, Self.EncryptedTag)
		    If Pos = -1 Then
		      Return Input
		    End If
		    
		    Dim StartPos As Integer = Pos + Self.EncryptedTag.Length
		    Dim EndPos As Integer = Input.IndexOf(StartPos, Self.EncryptedTag)
		    If EndPos = -1 Then
		      EndPos = Input.Length
		    End If
		    
		    Dim Prefix As String = Input.Left(StartPos)
		    Dim Suffix As String = Input.Right(Input.Length - EndPos)
		    Dim DecryptedContent As String = Input.Middle(StartPos, EndPos - StartPos)
		    Dim EncryptedContent As String = Self.Encrypt(DecryptedContent, Document)
		    
		    Input = Prefix + EncryptedContent + Suffix
		    Pos = Prefix.Length + EncryptedContent.Length + Self.EncryptedTag.Length
		  Loop
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mEncryptedValues As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mGameIniContent As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mGameUserSettingsIniContent As String
	#tag EndProperty


	#tag Constant, Name = EncryptedTag, Type = Text, Dynamic = False, Default = \"$$BeaconEncrypted$$", Scope = Public
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="IsImplicit"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
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
End Class
#tag EndClass
