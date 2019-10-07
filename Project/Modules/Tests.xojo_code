#tag Module
Protected Module Tests
	#tag Method, Flags = &h1
		Protected Sub Assert(Value As Boolean, Message As String)
		  If Value = False Then
		    System.DebugLog(Message)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub RunTests()
		  #if DebugBuild
		    TestQualities()
		    TestMemoryBlockExtensions()
		    TestStrings()
		    TestEncryption()
		    TestUUID()
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub TestEncryption()
		  Dim Identity As New Beacon.Identity
		  Dim PublicKey As String = Identity.PublicKey
		  Dim PrivateKey As String = Identity.PrivateKey
		  Assert(Crypto.RSAVerifyKey(PublicKey), "Unable to validate public key")
		  Assert(Crypto.RSAVerifyKey(PrivateKey), "Unable to validate private key")
		  
		  Dim PEMPublic As String = BeaconEncryption.PEMEncodePublicKey(PublicKey)
		  Assert(PEMPublic.BeginsWith("-----BEGIN PUBLIC KEY-----"), "Public key was not PEM encoded")
		  Assert(BeaconEncryption.PEMDecodePublicKey(PEMPublic) = PublicKey, "PEM public key was not decoded")
		  
		  Dim PEMPrivate As String = BeaconEncryption.PEMEncodePrivateKey(PrivateKey)
		  Assert(PEMPrivate.BeginsWith("-----BEGIN PRIVATE KEY-----"), "Private key was not PEM encoded")
		  Assert(BeaconEncryption.PEMDecodePrivateKey(PEMPrivate) = PrivateKey, "PEM private key was not decoded")
		  
		  Dim TestValue As MemoryBlock = Crypto.GenerateRandomBytes(24)
		  Dim Encrypted, Decrypted As MemoryBlock
		  
		  Try
		    Encrypted = Identity.Encrypt(TestValue)
		  Catch Err As RuntimeException
		    System.DebugLog("Unable to encrypt test value")
		  End Try
		  
		  Try
		    Decrypted = Identity.Decrypt(Encrypted)
		  Catch Err As RuntimeException
		    System.DebugLog("Unable to decrypt encrypted test value")
		  End Try
		  
		  Assert(TestValue = Decrypted, "Decrypted value does not match original")
		  
		  Dim Key As MemoryBlock = Crypto.GenerateRandomBytes(24)
		  
		  Try
		    Encrypted = BeaconEncryption.SymmetricEncrypt(Key, TestValue, 2)
		  Catch Err As RuntimeException
		    System.DebugLog("Unable to symmetric encrypt test value")
		  End Try
		  
		  Try
		    Decrypted = BeaconEncryption.SymmetricDecrypt(Key, Encrypted)
		  Catch Err As RuntimeException
		    System.DebugLog("Unable to symmetric decrypt encrypted test value")
		  End Try
		  
		  Assert(TestValue = Decrypted, "Symmetric decrypted value does not match original")
		  
		  Try
		    Encrypted = BeaconEncryption.SymmetricEncrypt(Key, TestValue, 1)
		  Catch Err As RuntimeException
		    System.DebugLog("Unable to symmetric(legacy) encrypt test value")
		  End Try
		  
		  Try
		    Decrypted = BeaconEncryption.SymmetricDecrypt(Key, Encrypted)
		  Catch Err As RuntimeException
		    System.DebugLog("Unable to symmetric(legacy) decrypt encrypted test value")
		  End Try
		  
		  Assert(TestValue = Decrypted, "Symmetric(legacy) decrypted value does not match original")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub TestMemoryBlockExtensions()
		  Dim Original As MemoryBlock = "Frog blast the vent core!"
		  Original.LittleEndian = True
		  Dim Clone As MemoryBlock = Original.Clone
		  Assert(EncodeHex(Original) = EncodeHex(Clone) And Original.LittleEndian = Clone.LittleEndian, "Cloning MemoryBlocks does not work")
		  
		  Dim LeftRead As MemoryBlock = Original.Left(4)
		  Dim RightRead As MemoryBlock = Original.Right(5)
		  Dim MidRead As MemoryBlock = Original.Middle(5, 5)
		  Assert(LeftRead = "Frog", "Incorrect MemoryBlock.Left read result.")
		  Assert(RightRead = "core!", "Incorrect MemoryBlock.Right read result.")
		  Assert(MidRead = "blast", "Incorrect MemoryBlock.Middle read result.")
		  
		  Clone.Left(4) = "Lion"
		  Assert(Clone = "Lion blast the vent core!", "Incorrect MemoryBlock.Left assignment when lengths are equal.")
		  Clone = Original.Clone
		  Clone.Left(4) = "Cat"
		  Assert(Clone = "Cat blast the vent core!", "Incorrect MemoryBlock.Left assignment when new length is shorter.")
		  Clone = Original.Clone
		  Clone.Left(4) = "Bobcat"
		  Assert(Clone = "Bobcat blast the vent core!", "Incorrect MemoryBlock.Left assignment when new length is longer.")
		  
		  Clone = Original.Clone
		  Clone.Right(5) = "tube!"
		  Assert(Clone = "Frog blast the vent tube!", "Incorrect MemoryBlock.Right assignment when lengths are equal.")
		  Clone = Original.Clone
		  Clone.Right(5) = "bar!"
		  Assert(Clone = "Frog blast the vent bar!", "Incorrect MemoryBlock.Right assignment when new length is shorter.")
		  Clone = Original.Clone
		  Clone.Right(5) = "grill!"
		  Assert(Clone = "Frog blast the vent grill!", "Incorrect MemoryBlock.Right assignment when new length is longer.")
		  
		  Clone = Original.Clone
		  Clone.Middle(5, 5) = "taste"
		  Assert(Clone = "Frog taste the vent core!", "Incorrect MemoryBlock.Middle assignment when lengths are equal.")
		  Clone = Original.Clone
		  Clone.Middle(5, 5) = "grab"
		  Assert(Clone = "Frog grab the vent core!", "Incorrect MemoryBlock.Middle assignment when new length is shorter.")
		  Clone = Original.Clone
		  Clone.Middle(5, 5) = "annihilate"
		  Assert(Clone = "Frog annihilate the vent core!", "Incorrect MemoryBlock.Middle assignment when new length is longer.")
		  
		  MidRead = Original.Middle(5, 200)
		  Assert(MidRead = "blast the vent core!", "Incorrect MemoryBlock.Middle read when length is greater than size.")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub TestQualities()
		  #if DebugBuild
		    Dim Quality As Beacon.Quality = Beacon.Qualities.Tier4
		    Dim StandardDifficulty As New BeaconConfigs.Difficulty(5)
		    Dim HighDifficulty As New BeaconConfigs.Difficulty(15)
		    Dim ExtremeDifficulty As New BeaconConfigs.Difficulty(100)
		    Dim Source As Beacon.LootSource = LocalData.SharedInstance.GetLootSource("SupplyCrate_Cave_QualityTier3_ScorchedEarth_C")
		    
		    Dim QualityStandardMin As Double = Quality.Value(Source.Multipliers.Min, StandardDifficulty)
		    Dim QualityStandardMax As Double = Quality.Value(Source.Multipliers.Max, StandardDifficulty)
		    Dim QualityHighMin As Double = Quality.Value(Source.Multipliers.Min, HighDifficulty)
		    Dim QualityHighMax As Double = Quality.Value(Source.Multipliers.Max, HighDifficulty)
		    Dim QualityExtremeMin As Double = Quality.Value(Source.Multipliers.Min, ExtremeDifficulty)
		    Dim QualityExtremeMax As Double = Quality.Value(Source.Multipliers.Max, ExtremeDifficulty)
		    
		    // Compare backwards because we expect lower values for higher difficulties
		    Assert(QualityExtremeMin < QualityHighMin And QualityHighMin < QualityStandardMin And QualityExtremeMax < QualityHighMax And QualityHighMax < QualityStandardMax, "Qualities are equal regardless of difficulty")
		    
		    Dim StandardQualityMin As Beacon.Quality = Beacon.Qualities.ForValue(QualityStandardMin, Source.Multipliers.Min, StandardDifficulty)
		    Dim StandardQualityMax As Beacon.Quality = Beacon.Qualities.ForValue(QualityStandardMax, Source.Multipliers.Max, StandardDifficulty)
		    Dim HighQualityMin As Beacon.Quality = Beacon.Qualities.ForValue(QualityHighMin, Source.Multipliers.Min, HighDifficulty)
		    Dim HighQualityMax As Beacon.Quality = Beacon.Qualities.ForValue(QualityHighMax, Source.Multipliers.Max, HighDifficulty)
		    Dim ExtremeQualityMin As Beacon.Quality = Beacon.Qualities.ForValue(QualityExtremeMin, Source.Multipliers.Min, ExtremeDifficulty)
		    Dim ExtremeQualityMax As Beacon.Quality = Beacon.Qualities.ForValue(QualityExtremeMax, Source.Multipliers.Max, ExtremeDifficulty)
		    
		    Const Formatter = "-0.0000"
		    Assert(StandardQualityMin = Quality, "Expected quality min " + Language.LabelForQuality(Quality) + "(" + Str(Quality.BaseValue, Formatter) + ") but got " + Language.LabelForQuality(StandardQualityMin) + "(" + Str(StandardQualityMin.BaseValue, Formatter) + ") for difficulty 5")
		    Assert(StandardQualityMax = Quality, "Expected quality max " + Language.LabelForQuality(Quality) + "(" + Str(Quality.BaseValue, Formatter) + ") but got " + Language.LabelForQuality(StandardQualityMax) + "(" + Str(StandardQualityMax.BaseValue, Formatter) + ") for difficulty 5")
		    Assert(HighQualityMin = Quality, "Expected quality min " + Language.LabelForQuality(Quality) + "(" + Str(Quality.BaseValue, Formatter) + ") but got " + Language.LabelForQuality(HighQualityMin) + "(" + Str(HighQualityMax.BaseValue, Formatter) + ") for difficulty 15")
		    Assert(HighQualityMax = Quality, "Expected quality max " + Language.LabelForQuality(Quality) + "(" + Str(Quality.BaseValue, Formatter) + ") but got " + Language.LabelForQuality(HighQualityMax) + "(" + Str(HighQualityMax.BaseValue, Formatter) + ") for difficulty 15")
		    Assert(ExtremeQualityMin = Quality, "Expected quality min " + Language.LabelForQuality(Quality) + "(" + Str(Quality.BaseValue, Formatter) + ") but got " + Language.LabelForQuality(ExtremeQualityMin) + "(" + Str(ExtremeQualityMax.BaseValue, Formatter) + ") for difficulty 100")
		    Assert(ExtremeQualityMin = Quality, "Expected quality max " + Language.LabelForQuality(Quality) + "(" + Str(Quality.BaseValue, Formatter) + ") but got " + Language.LabelForQuality(ExtremeQualityMax) + "(" + Str(ExtremeQualityMax.BaseValue, Formatter) + ") for difficulty 100")
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub TestStrings()
		  Dim StringValue As String = "Human"
		  Assert(StringValue.IndexOf("u") = 1, "String.IndexOf returns incorrect result. Expected 1, got " + StringValue.IndexOf("u").ToString + ".")
		  Assert(StringValue.Middle(2) = "man", "String.Middle returns incorrect result. Expected 'man', got '" + StringValue.Middle(2) + "'.")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub TestUUID()
		  Dim UUID As New v4UUID
		  
		  Try
		    UUID = v4UUID.CreateNull
		    Assert(UUID = "00000000-0000-0000-0000-000000000000", "Null UUID is not correct")
		    Assert(UUID = Nil, "Null UUID does not compare against Nil correctly")
		  Catch Err As UnsupportedFormatException
		    System.DebugLog("Validator will not accept null UUID")
		  End Try
		  
		  Try
		    UUID = "ffc93232-2484-4947-8c9a-a691cf938d75"
		    Assert(UUID.IsNull = False, "UUID is listed as null when it should not be")
		    Assert(UUID <> Nil, "Valid UUID is successfully matching against Nil")
		  Catch Err As UnsupportedFormatException
		    System.DebugLog("Validator will not accept valid UUID")
		  End Try
		  
		  Try
		    Dim V As Variant = "ffc93232-2484-4947-8c9a-a691cf938d75"
		    UUID = V.StringValue
		  Catch Err As RuntimeException
		    System.DebugLog("Unable to convert string in variant to UUID")
		  End Try
		  
		  Try
		    Dim V As Variant = New v4UUID
		    UUID = v4UUID(V.ObjectValue)
		  Catch Err As RuntimeException
		    System.DebugLog("Unable to convert UUID in variant to UUID")
		  End Try
		  
		  Try
		    UUID = Nil
		  Catch Err As RuntimeException
		    System.DebugLog("Unable to assign UUID to Nil")
		  End Try
		  
		  Try
		    UUID = v4UUID.FromHash(Crypto.Algorithm.MD5, "Frog Blast The Vent Core")
		    Assert(UUID = "7e05d5d6-bf10-445d-9512-d3a650670061", "Incorrect UUID generated from MD5 hash")
		  Catch Err As UnsupportedFormatException
		    System.DebugLog("MD5UUID generated bad format")
		  End Try
		End Sub
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
End Module
#tag EndModule
