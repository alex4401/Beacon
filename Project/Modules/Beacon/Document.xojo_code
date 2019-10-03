#tag Class
Protected Class Document
	#tag Method, Flags = &h0
		Sub Add(Profile As Beacon.ServerProfile)
		  If Profile = Nil Then
		    Return
		  End If
		  
		  For I As Integer = 0 To Self.mServerProfiles.LastRowIndex
		    If Self.mServerProfiles(I) = Profile Then
		      Self.mServerProfiles(I) = Profile.Clone
		      Self.mModified = True
		      Return
		    End If
		  Next
		  
		  Self.mServerProfiles.AddRow(Profile.Clone)
		  If Profile.IsConsole Then
		    Dim SafeMods() As String = Beacon.Data.ConsoleSafeMods
		    If Self.mMods = Nil Or Self.mMods.LastRowIndex = -1 Then
		      Self.mMods = SafeMods
		    Else
		      For I As Integer = Self.mMods.LastRowIndex DownTo 0
		        If SafeMods.IndexOf(Self.mMods(I)) = -1 Then
		          Self.mMods.Remove(I)
		        End If
		      Next
		    End If
		  End If
		  Self.mModified = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddConfigGroup(Group As Beacon.ConfigGroup)
		  Self.mConfigGroups.Value(Group.ConfigName) = Group
		  Self.mModified = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddUser(UserID As String, PublicKey As String)
		  Self.mEncryptedPasswords.Value(UserID.Lowercase) = EncodeBase64(Crypto.RSAEncrypt(Self.mDocumentPassword, PublicKey), 0)
		  Self.mModified = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ConfigGroup(GroupName As String, Create As Boolean = False) As Beacon.ConfigGroup
		  If Self.mConfigGroups.HasKey(GroupName) Then
		    Return Self.mConfigGroups.Value(GroupName)
		  End If
		  
		  If Create Then
		    Dim Group As Beacon.ConfigGroup = BeaconConfigs.CreateInstance(GroupName)
		    If Group <> Nil Then
		      Group.IsImplicit = True
		      Self.AddConfigGroup(Group)
		    End If
		    Return Group
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  Self.mIdentifier = New v4UUID
		  Self.mMapCompatibility = Beacon.Maps.TheIsland.Mask
		  Self.mConfigGroups = New Dictionary
		  Self.AddConfigGroup(New BeaconConfigs.Difficulty)
		  Self.Difficulty.IsImplicit = True
		  Self.mModified = False
		  Self.mMods = New Beacon.StringList
		  Self.UseCompression = True
		  Self.mDocumentPassword = Crypto.GenerateRandomBytes(32)
		  Self.mEncryptedPasswords = New Dictionary
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Decrypt(Data As String) As String
		  Return BeaconEncryption.SymmetricDecrypt(Self.mDocumentPassword, DecodeBase64(Data))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Difficulty() As BeaconConfigs.Difficulty
		  Static GroupName As String = BeaconConfigs.Difficulty.ConfigName
		  Return BeaconConfigs.Difficulty(Self.ConfigGroup(GroupName, True))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DocumentID() As String
		  Return Self.mIdentifier
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Encrypt(Data As String) As String
		  Return EncodeBase64(BeaconEncryption.SymmetricEncrypt(Self.mDocumentPassword, Data), 0)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function FromLegacy(Parsed As Variant, Identity As Beacon.Identity) As Beacon.Document
		  Dim Doc As new Beacon.Document
		  Dim LootSources() As Variant
		  Dim Version As Integer
		  
		  If Parsed.Type = Variant.TypeObject And Parsed.ObjectValue IsA Dictionary Then
		    Dim Dict As Dictionary = Parsed
		    Try
		      If Dict.HasKey("LootSources") Then
		        LootSources = Dict.Value("LootSources")
		      Else
		        LootSources = Dict.Value("Beacons")
		      End If
		      
		      Doc.mIdentifier = Dict.Value("Identifier")
		      Doc.mUseCompression = True
		      Version = Dict.Lookup("Version", 0)
		      
		      If Dict.HasKey("Title") Then
		        Doc.Title = Dict.Value("Title")
		      End If
		      If Dict.HasKey("Description") Then
		        Doc.Description = Dict.Value("Description")
		      End If
		      If Dict.HasKey("Public") Then
		        Doc.IsPublic = Dict.Value("Public")
		      End If
		      If Dict.HasKey("Map") Then
		        Doc.mMapCompatibility = Dict.Value("Map")
		      ElseIf Dict.HasKey("MapPreference") Then
		        Doc.mMapCompatibility = Dict.Value("MapPreference")
		      Else
		        Doc.mMapCompatibility = 0
		      End If
		      Dim DifficultyConfig As New BeaconConfigs.Difficulty
		      If Dict.HasKey("DifficultyValue") Then
		        DifficultyConfig.MaxDinoLevel = Dict.Value("DifficultyValue") * 30
		      End If
		      Doc.AddConfigGroup(DifficultyConfig)
		      If Dict.HasKey("ConsoleModsOnly") Then
		        Dim ConsoleModsOnly As Boolean = Dict.Value("ConsoleModsOnly")
		        If ConsoleModsOnly Then
		          Doc.mMods = Beacon.Data.ConsoleSafeMods()
		        End If
		      End If
		      
		      If Dict.HasKey("Secure") Then
		        Dim SecureDict As Dictionary = ReadSecureData(Dict.Value("Secure"), Identity)
		        If SecureDict <> Nil Then
		          Dim ServerDicts() As Variant = SecureDict.Value("Servers")
		          For Each ServerDict As Dictionary In ServerDicts
		            Dim Profile As Beacon.ServerProfile = Beacon.ServerProfile.FromDictionary(ServerDict)
		            If Profile <> Nil Then
		              Doc.mServerProfiles.AddRow(Profile)
		            End If
		          Next
		          
		          If SecureDict.HasKey("OAuth") Then
		            Doc.mOAuthDicts = SecureDict.Value("OAuth")
		          End If
		        End If
		      ElseIf Dict.HasKey("FTPServers") Then
		        Dim ServerDicts() As Variant = Dict.Value("FTPServers")
		        For Each ServerDict As Dictionary In ServerDicts
		          Dim FTPInfo As Dictionary = ReadSecureData(ServerDict, Identity, True)
		          If FTPInfo <> Nil And FTPInfo.HasAllKeys("Description", "Host", "Port", "User", "Pass", "Path") Then
		            Dim Profile As New Beacon.FTPServerProfile
		            Profile.Name = FTPInfo.Value("Description")
		            Profile.Host = FTPInfo.Value("Host")
		            Profile.Port = FTPInfo.Value("Port")
		            Profile.Username = FTPInfo.Value("User")
		            Profile.Password = FTPInfo.Value("Pass")
		            
		            Dim Path As String = FTPInfo.Value("Path")
		            Dim Components() As String = Path.Split("/")
		            If Components.LastRowIndex > -1 Then
		              Dim LastComponent As String = Components(Components.LastRowIndex)
		              If LastComponent.Length > 4 And LastComponent.Right(4) = ".ini" Then
		                Components.RemoveRowAt(Components.LastRowIndex)
		              End If
		            End If
		            Components.AddRow("Game.ini")
		            Profile.GameIniPath = Components.Join("/")
		            
		            Components(Components.LastRowIndex) = "GameUserSettings.ini"
		            Profile.GameUserSettingsIniPath = Components.Join("/")
		            
		            Doc.mServerProfiles.AddRow(Profile)
		          End If
		        Next
		      End If
		    Catch Err As RuntimeException
		      Return Nil
		    End Try
		  ElseIf Parsed.IsArray And Parsed.ArrayElementType = Variant.TypeObject Then
		    LootSources = Parsed
		  Else
		    Return Nil
		  End If
		  
		  Dim Presets() As Beacon.Preset
		  If Version < 2 Then
		    // Will need this in a few lines
		    Presets = Beacon.Data.Presets
		  End If
		  If LootSources.LastRowIndex > -1 Then
		    Dim Drops As New BeaconConfigs.LootDrops
		    For Each LootSource As Dictionary In LootSources
		      Dim Source As Beacon.LootSource = Beacon.LootSource.ImportFromBeacon(LootSource)
		      If Source <> Nil Then
		        If Version < 2 Then
		          // Match item set names to presets
		          For Each Set As Beacon.ItemSet In Source
		            For Each Preset As Beacon.Preset In Presets
		              If Set.Label = Preset.Label Then
		                // Here's a hack to make assigning a preset possible: save current entries
		                Dim Entries() As Beacon.SetEntry
		                For Each Entry As Beacon.SetEntry In Set
		                  Entries.AddRow(New Beacon.SetEntry(Entry))
		                Next
		                
		                // Reconfigure
		                Call Set.ReconfigureWithPreset(Preset, Source, Beacon.Maps.TheIsland.Mask, Doc.Mods)
		                
		                // Now "deconfigure" it
		                Redim Set(Entries.LastRowIndex)
		                For I As Integer = 0 To Entries.LastRowIndex
		                  Set(I) = Entries(I)
		                Next
		                Continue For Set
		              End If
		            Next
		          Next
		        End If
		        Drops.Append(Source)
		      End If
		    Next
		    Doc.AddConfigGroup(Drops)
		  End If
		  
		  Doc.mModified = Version < Beacon.Document.DocumentVersion
		  
		  Return Doc
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function FromString(Contents As String, Identity As Beacon.Identity) As Beacon.Document
		  Dim Parsed As Variant
		  Try
		    Parsed = Beacon.ParseJSON(Contents)
		  Catch Err As RuntimeException
		    Return Nil
		  End Try
		  
		  Dim Doc As New Beacon.Document
		  Dim Version As Integer = 1
		  Dim Dict As Dictionary
		  If Parsed IsA Dictionary Then
		    Dict = Parsed
		    Version = Dict.Lookup("Version", 0)
		    If Dict.HasKey("Identifier") Then
		      Doc.mIdentifier = Dict.Value("Identifier")
		    Else
		      Doc.mIdentifier = New v4UUID
		    End If
		  End If
		  If Version < 3 Then
		    Return Beacon.Document.FromLegacy(Parsed, Identity)
		  End If
		  
		  If Version >= 4 And Dict.HasKey("EncryptionKeys") And Dict.Value("EncryptionKeys") IsA Dictionary Then
		    Dim Passwords As Dictionary = Dict.Value("EncryptionKeys")
		    If Passwords.HasKey(Identity.Identifier.Lowercase) Then
		      Try
		        Dim DocumentPassword As String = Crypto.RSADecrypt(DecodeBase64(Passwords.Value(Identity.Identifier.Lowercase)), Identity.PrivateKey)
		        Doc.mDocumentPassword = DocumentPassword
		        Doc.mEncryptedPasswords = Passwords
		      Catch Err As RuntimeException
		        // Leave the encryption fresh
		        Break
		      End Try
		    End If
		  End If
		  
		  // New config system
		  If Dict.HasKey("Configs") Then
		    Dim Groups As Dictionary = Dict.Value("Configs")
		    For Each Entry As DictionaryEntry In Groups
		      Dim GroupName As String = Entry.Key
		      Dim GroupData As Dictionary = Entry.Value
		      Dim Instance As Beacon.ConfigGroup = BeaconConfigs.CreateInstance(GroupName, GroupData, Identity, Doc)
		      If Instance <> Nil Then
		        Doc.mConfigGroups.Value(GroupName) = Instance
		      End If
		    Next
		  End If
		  
		  If Dict.HasKey("Mods") Then
		    Dim Mods As Beacon.StringList = Beacon.StringList.FromVariant(Dict.Value("Mods"))
		    If Mods <> Nil Then
		      Doc.mMods = Mods
		    End If
		  ElseIf Dict.HasKey("ConsoleModsOnly") Then
		    Dim ConsoleModsOnly As Boolean = Dict.Value("ConsoleModsOnly")
		    If ConsoleModsOnly Then
		      Doc.mMods = Beacon.Data.ConsoleSafeMods()
		    End If
		  End If
		  If Dict.HasKey("Map") Then
		    Doc.MapCompatibility = Dict.Value("Map")
		  ElseIf Dict.HasKey("MapPreference") Then
		    Doc.MapCompatibility = Dict.Value("MapPreference")
		  Else
		    Doc.MapCompatibility = 0
		  End If
		  If Dict.HasKey("UseCompression") Then
		    Doc.UseCompression = Dict.Value("UseCompression")
		  Else
		    Doc.UseCompression = True
		  End If
		  
		  Dim SecureDict As Dictionary
		  If Dict.HasKey("EncryptedData") Then
		    Try
		      Doc.mLastSecureData = Dict.Value("EncryptedData")
		      Dim Decrypted As String = Doc.Decrypt(Doc.mLastSecureData)
		      Doc.mLastSecureHash = Beacon.Hash(Decrypted)
		      SecureDict = Beacon.ParseJSON(Decrypted)
		    Catch Err As RuntimeException
		      // No secure data
		    End Try
		  ElseIf Dict.HasKey("Secure") Then
		    SecureDict = ReadSecureData(Dict.Value("Secure"), Identity)
		  End If
		  If SecureDict <> Nil Then
		    Dim ServerDicts() As Variant = SecureDict.Value("Servers")
		    For Each ServerDict As Dictionary In ServerDicts
		      Dim Profile As Beacon.ServerProfile = Beacon.ServerProfile.FromDictionary(ServerDict)
		      If Profile <> Nil Then
		        Doc.mServerProfiles.AddRow(Profile)
		      End If
		    Next
		    
		    If SecureDict.HasKey("OAuth") Then
		      Doc.mOAuthDicts = SecureDict.Value("OAuth")
		    End If
		  End If
		  
		  If Dict.HasKey("Trust") Then
		    Doc.mTrustKey = Dict.Value("Trust")
		  End If
		  
		  If Dict.HasKey("AllowUCS") Then
		    Doc.mAllowUCS = Dict.Value("AllowUCS")
		  End If
		  
		  If Dict.HasKey("Timestamp") Then
		    Doc.mLastSaved = NewDateFromSQLDateTime(Dict.Value("Timestamp"))
		  End If
		  
		  Doc.Modified = Version < Beacon.Document.DocumentVersion
		  
		  Return Doc
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetUsers() As String()
		  Dim Users() As String
		  For Each Entry As DictionaryEntry In Self.mEncryptedPasswords
		    Users.AddRow(Entry.Key)
		  Next
		  Return Users
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HasConfigGroup(GroupName As String) As Boolean
		  Return Self.mConfigGroups.HasKey(GroupName)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ImplementedConfigs() As Beacon.ConfigGroup()
		  Dim Groups() As Beacon.ConfigGroup
		  For Each Entry As DictionaryEntry In Self.mConfigGroups
		    Groups.AddRow(Entry.Value)
		  Next
		  Return Groups
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsValid(Identity As Beacon.Identity) As Boolean
		  If Self.mMapCompatibility = 0 Then
		    Return False
		  End If
		  If Self.DifficultyValue = -1 Then
		    Return False
		  End If
		  
		  Dim Configs() As Beacon.ConfigGroup = Self.ImplementedConfigs()
		  For Each Config As Beacon.ConfigGroup In Configs
		    Dim Issues() As Beacon.Issue = Config.Issues(Self, Identity)
		    If Issues <> Nil And Issues.LastRowIndex > -1 Then
		      Return False
		    End If
		  Next
		  
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit))
		Function LastSaved() As DateTime
		  If Self.mLastSaved <> Nil Then
		    Return New DateTime(Self.mLastSaved.SecondsFrom1970, Self.mLastSaved.Timezone)
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Maps() As Beacon.Map()
		  Dim Possibles() As Beacon.Map = Beacon.Maps.All
		  Dim Matches() As Beacon.Map
		  For Each Map As Beacon.Map In Possibles
		    If Map.Matches(Self.mMapCompatibility) Then
		      Matches.AddRow(Map)
		    End If
		  Next
		  Return Matches
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Metadata(Create As Boolean = False) As BeaconConfigs.Metadata
		  Static GroupName As String = BeaconConfigs.Metadata.ConfigName
		  Dim Group As Beacon.ConfigGroup = Self.ConfigGroup(GroupName, Create)
		  If Group <> Nil Then
		    Return BeaconConfigs.Metadata(Group)
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Modified() As Boolean
		  If Self.mModified Then
		    Return True
		  End If
		  
		  If Self.mMods.Modified Then
		    Return True
		  End If
		  
		  For Each Entry As DictionaryEntry In Self.mConfigGroups
		    Dim Group As Beacon.ConfigGroup = Entry.Value
		    If Group.Modified Then
		      Return True
		    End If
		  Next
		  
		  For Each Profile As Beacon.ServerProfile In Self.mServerProfiles
		    If Profile.Modified Then
		      Return True
		    End If
		  Next
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Modified(Assigns Value As Boolean)
		  Self.mModified = Value
		  
		  If Value = False Then
		    For Each Entry As DictionaryEntry In Self.mConfigGroups
		      Dim Group As Beacon.ConfigGroup = Entry.Value
		      Group.Modified = False
		    Next
		    
		    For Each Profile As Beacon.ServerProfile In Self.mServerProfiles
		      Profile.Modified = False
		    Next
		    
		    Self.mMods.Modified = False
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Mods() As Beacon.StringList
		  Return Self.mMods
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub NewIdentifier()
		  Self.mIdentifier = New v4UUID
		  Self.mModified = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function OAuthData(Provider As String) As Dictionary
		  If Self.mOAuthDicts <> Nil And Self.mOAuthDicts.HasKey(Provider) Then
		    Return Dictionary(Self.mOAuthDicts.Value(Provider)).Clone
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub OAuthData(Provider As String, Assigns Dict As Dictionary)
		  If Self.mOAuthDicts = Nil Then
		    Self.mOAuthDicts = New Dictionary
		  End If
		  If Dict = Nil Then
		    If Self.mOAuthDicts.HasKey(Provider) Then
		      Self.mOAuthDicts.Remove(Provider)
		      Self.mModified = True
		    End If
		  Else
		    If Self.mOAuthDicts.HasKey(Provider) Then
		      // Need to compare
		      Dim OldJSON As String = Beacon.GenerateJSON(Self.mOAuthDicts.Value(Provider), False)
		      Dim NewJSON As String = Beacon.GenerateJSON(Dict, False)
		      If OldJSON = NewJSON Then
		        Return
		      End If
		    End If
		    
		    Self.mOAuthDicts.Value(Provider) = Dict.Clone
		    Self.mModified = True
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Compare(Other As Beacon.Document) As Integer
		  If Other = Nil Then
		    Return 1
		  End If
		  
		  Return Self.mIdentifier.Compare(Other.mIdentifier, ComparisonOptions.CaseSensitive)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit))
		Private Shared Function ReadSecureData(SecureDict As Dictionary, Identity As Beacon.Identity, SkipHashVerification As Boolean = False) As Dictionary
		  If Not SecureDict.HasAllKeys("Key", "Vector", "Content", "Hash") Then
		    Return Nil
		  End If
		  
		  Dim Key As MemoryBlock = Identity.Decrypt(DecodeHex(SecureDict.Value("Key")))
		  If Key = Nil Then
		    Return Nil
		  End If
		  
		  Dim ExpectedHash As String = SecureDict.Lookup("Hash", "")
		  Dim Vector As MemoryBlock = DecodeHex(SecureDict.Value("Vector"))
		  Dim Encrypted As MemoryBlock = DecodeHex(SecureDict.Value("Content"))
		  Dim AES As New M_Crypto.AES_MTC(AES_MTC.EncryptionBits.Bits256)
		  AES.SetKey(Key)
		  AES.SetInitialVector(Vector)
		  
		  Dim Decrypted As String
		  Try
		    Decrypted = AES.DecryptCBC(Encrypted)
		  Catch Err As RuntimeException
		    Return Nil
		  End Try
		  
		  If SkipHashVerification = False Then
		    Dim ComputedHash As String = Beacon.Hash(Decrypted)
		    If ComputedHash <> ExpectedHash Then
		      Return Nil
		    End If
		  End If
		  
		  If Decrypted = "" Or Not Encodings.UTF8.IsValidData(Decrypted) Then
		    Return Nil
		  End If
		  Decrypted = Decrypted.DefineEncoding(Encodings.UTF8)
		  
		  Dim DecryptedDict As Dictionary
		  Try
		    DecryptedDict = Beacon.ParseJSON(Decrypted)
		  Catch Err As RuntimeException
		    Return Nil
		  End Try
		  
		  Return DecryptedDict
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Remove(Profile As Beacon.ServerProfile)
		  For I As Integer = 0 To Self.mServerProfiles.LastRowIndex
		    If Self.mServerProfiles(I) = Profile Then
		      Self.mServerProfiles.RemoveRowAt(I)
		      Self.Modified = True
		      Return
		    End If
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveConfigGroup(Group As Beacon.ConfigGroup)
		  Self.RemoveConfigGroup(Group.ConfigName)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveConfigGroup(GroupName As String)
		  If Self.mConfigGroups.HasKey(GroupName) Then
		    Self.mConfigGroups.Remove(GroupName)
		    Self.mModified = True
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveUser(UserID As String)
		  UserID = UserID.Lowercase
		  If Self.mEncryptedPasswords.HasKey(UserID) Then
		    Self.mEncryptedPasswords.Remove(UserID)
		    Self.mModified = True
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ServerProfile(Index As Integer) As Beacon.ServerProfile
		  Return Self.mServerProfiles(Index)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ServerProfile(Index As Integer, Assigns Profile As Beacon.ServerProfile)
		  Self.mServerProfiles(Index) = Profile.Clone
		  Self.mModified = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ServerProfileCount() As Integer
		  Return Self.mServerProfiles.LastRowIndex + 1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SupportsMap(Map As Beacon.Map) As Boolean
		  Return Map.Matches(Self.mMapCompatibility)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SupportsMap(Map As Beacon.Map, Assigns Value As Boolean)
		  If Value Then
		    Self.mMapCompatibility = Self.mMapCompatibility Or Map.Mask
		  Else
		    Self.mMapCompatibility = Self.mMapCompatibility And Not Map.Mask
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToDictionary(Identity As Beacon.Identity) As Dictionary
		  If Not Self.mEncryptedPasswords.HasKey(Identity.Identifier) Then
		    Self.AddUser(Identity.Identifier, Identity.PublicKey)
		  End If
		  
		  Dim Document As New Dictionary
		  Document.Value("Version") = Self.DocumentVersion
		  Document.Value("Identifier") = Self.DocumentID
		  Document.Value("Trust") = Self.TrustKey
		  Document.Value("EncryptionKeys") = Self.mEncryptedPasswords
		  
		  Dim ModsList() As String = Self.Mods
		  Document.Value("Mods") = ModsList
		  Document.Value("UseCompression") = Self.UseCompression
		  Document.Value("Timestamp") = DateTime.Now.SQLDateTimeWithOffset
		  Document.Value("AllowUCS") = Self.AllowUCS
		  
		  Dim Groups As New Dictionary
		  For Each Entry As DictionaryEntry In Self.mConfigGroups
		    Dim Group As Beacon.ConfigGroup = Entry.Value
		    Dim GroupData As Dictionary = Group.ToDictionary(Self)
		    If GroupData = Nil Then
		      GroupData = New Dictionary
		    End If
		    
		    Dim Info As Introspection.TypeInfo = Introspection.GetType(Group)
		    Groups.Value(Info.Name) = GroupData
		  Next
		  Document.Value("Configs") = Groups
		  
		  If Self.mMapCompatibility > 0 Then
		    Document.Value("Map") = Self.mMapCompatibility
		  End If
		  
		  Dim EncryptedData As New Dictionary
		  Dim Profiles() As Dictionary
		  For Each Profile As Beacon.ServerProfile In Self.mServerProfiles
		    Profiles.AddRow(Profile.ToDictionary)
		  Next
		  EncryptedData.Value("Servers") = Profiles
		  If Self.mOAuthDicts <> Nil Then
		    EncryptedData.Value("OAuth") = Self.mOAuthDicts
		  End If
		  
		  Dim Content As String = Beacon.GenerateJSON(EncryptedData, False)
		  Dim Hash As String = Beacon.Hash(Content)
		  If Hash <> Self.mLastSecureHash Then
		    Self.mLastSecureData = Self.Encrypt(Content)
		    Self.mLastSecureHash = Hash
		  End If
		  Document.Value("EncryptedData") = Self.mLastSecureData
		  
		  Return Document
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function UsesOmniFeaturesWithoutOmni(Identity As Beacon.Identity) As Beacon.ConfigGroup()
		  Dim OmniVersion As Integer = Identity.OmniVersion
		  Dim Configs() As Beacon.ConfigGroup = Self.ImplementedConfigs()
		  Dim ExcludedConfigs() As Beacon.ConfigGroup
		  For Each Config As Beacon.ConfigGroup In Configs
		    If Config.Purchased(OmniVersion) = False Then
		      ExcludedConfigs.AddRow(Config)
		    End If
		  Next
		  Return ExcludedConfigs
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mAllowUCS
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If Self.mAllowUCS <> Value Then
			    Self.mAllowUCS = Value
			    Self.mModified = True
			  End If
			End Set
		#tag EndSetter
		AllowUCS As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Dim Metadata As BeaconConfigs.Metadata = Self.Metadata
			  If Metadata <> Nil Then
			    Return Metadata.Description
			  End If
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Self.Metadata(True).Description = Value
			End Set
		#tag EndSetter
		Description As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Dim Difficulty As BeaconConfigs.Difficulty = Self.Difficulty
			  If Difficulty <> Nil Then
			    Return Difficulty.DifficultyValue
			  Else
			    Return -1
			  End If
			End Get
		#tag EndGetter
		DifficultyValue As Double
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Dim Metadata As BeaconConfigs.Metadata = Self.Metadata
			  If Metadata <> Nil Then
			    Return Metadata.IsPublic
			  End If
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Self.Metadata(True).IsPublic = Value
			End Set
		#tag EndSetter
		IsPublic As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mAllowUCS As Boolean
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mMapCompatibility
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Dim Limit As UInt64 = Beacon.Maps.All.Mask
			  Value = Value And Limit
			  If Self.mMapCompatibility <> Value Then
			    If Self.mMods <> Nil And Self.mMods.Count > 0 Then
			      Dim Maps() As Beacon.Map = Beacon.Maps.ForMask(Value)
			      For Each Map As Beacon.Map In Maps
			        Self.mMods.Append(Map.ProvidedByModID)
			      Next
			    End If
			    
			    Self.mMapCompatibility = Value
			    Self.mModified = True
			  End If
			End Set
		#tag EndSetter
		MapCompatibility As UInt64
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mConfigGroups As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mDocumentPassword As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mEncryptedPasswords As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mIdentifier As String
	#tag EndProperty

	#tag Property, Flags = &h21, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit)) or  (TargetIOS and (Target64Bit))
		Private mLastSaved As DateTime
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLastSecureData As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLastSecureHash As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mMapCompatibility As UInt64
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mModified As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mMods As Beacon.StringList
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mOAuthDicts As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mServerProfiles() As Beacon.ServerProfile
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTrustKey As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mUseCompression As Boolean
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Dim Metadata As BeaconConfigs.Metadata = Self.Metadata
			  If Metadata <> Nil Then
			    Return Metadata.Title
			  End If
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Self.Metadata(True).Title = Value
			End Set
		#tag EndSetter
		Title As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  If Self.mTrustKey = "" Then
			    Self.mTrustKey = EncodeHex(Crypto.GenerateRandomBytes(6))
			    Self.mModified = True
			  End If
			  Return Self.mTrustKey
			End Get
		#tag EndGetter
		TrustKey As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.mUseCompression
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If Self.mUseCompression <> Value Then
			    Self.mUseCompression = Value
			    Self.mModified = True
			  End If
			End Set
		#tag EndSetter
		UseCompression As Boolean
	#tag EndComputedProperty


	#tag Constant, Name = DocumentVersion, Type = Double, Dynamic = False, Default = \"4", Scope = Private
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Description"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="DifficultyValue"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
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
			Name="IsPublic"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
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
			Name="MapCompatibility"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="UInt64"
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
			Name="Title"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
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
			Name="UseCompression"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TrustKey"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowUCS"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
